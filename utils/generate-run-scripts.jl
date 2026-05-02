# utils/generate-run-scripts.jl
#
# Utility to programmatically generate paired Julia run-scripts, SLURM job
# scripts, and a batch submission script for NEM adequacy assessments on the
# Spartan HPC cluster.
#
# Usage (from the REPL or another script):
#
#   include("utils/generate-run-scripts.jl")
#   generate_run_scripts(target_years = [2030, 2035])


function write_julia_script(
    filepath::String,
    target_year::Int,
    scenario::Int,
    poe::Int,
    ref_traces::Vector{Int},
    samples::Int,
    base_path::String,
    julia_repo_path::String,
    results_folder::String
)
    ref_traces_str = join(ref_traces, ", ")
    content = """
using Pkg; Pkg.activate("$(julia_repo_path)")
using PRAS, Gurobi, JuMP, PRASNEM, SchedNEM, Dates, CSV, Statistics
include("$(julia_repo_path)/functions/assess_adequacy.jl")

for ref_trace in [$(ref_traces_str)]
    assess_adequacy(
        target_year     = $(target_year),
        reference_trace = ref_trace,
        poe             = $(poe),
        samples         = $(samples),
        scenario        = $(scenario),
        base_path       = "$(base_path)",
        solver          = "Gurobi",
        results_folder  = "$(results_folder)"
    )
end
"""
    open(filepath, "w") do io
        write(io, content)
    end
end


function write_slurm_script(
    filepath::String,
    julia_script_path::String,
    target_year::Int,
    scenario::Int,
    poe::Int,
    n_threads::Int,
    time_limit::String
)
    job_name = "NEM-TY$(target_year)-S$(scenario)-POE$(poe)"
    content = """
#!/bin/bash
#SBATCH --partition=sapphire
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=$(n_threads)
#SBATCH --mem=64G
#SBATCH --time=$(time_limit)
#SBATCH --job-name=$(job_name)
#SBATCH --output=%j-%x.out
#SBATCH --error=%j-%x.err
#SBATCH --mail-user=pablo.apablazadonoso@unimelb.edu.au
#SBATCH --mail-type=all

module load GCCcore/11.3.0
module load Gurobi/13.0.1

julia --threads=$(n_threads) $(julia_script_path)

echo "ALL DONE!"
my-job-stats -a -n -s
"""
    open(filepath, "w") do io
        write(io, content)
    end
end


function write_batcher_script(
    filepath::String,
    slurm_paths::Vector{String}
)
    sbatch_lines = join(["sbatch $p" for p in slurm_paths], "\n")
    content = """
#!/bin/bash
$(sbatch_lines)
"""
    open(filepath, "w") do io
        write(io, content)
    end
    chmod(filepath, 0o755)
end


"""
    generate_run_scripts(; target_years, [kwargs...])

Generate one paired Julia + SLURM script per `(target_year, scenario, poe)`
combination, plus a single batch submission script that calls `sbatch` on every
generated SLURM file.

Julia scripts go to `julia_output_dir`, SLURM scripts to `slurm_output_dir`,
and the batcher to `batch_output_dir`. All three directories are created with
`mkpath` if they do not exist.

The batcher filename includes a random 8-character hex ID so successive calls
do not overwrite each other: `batch-<id>.sh`.

# Threading note
The existing code uses `Threads.@threads` (not `Distributed`). The effective
parallelism cap is `ceil(samples / sample_number_per_run)` — with defaults
(samples=1000, sample_number_per_run=100) this is **10 batches**, so setting
`n_threads > 10` reserves extra CPUs without improving throughput.

# Parameters
- `target_years`         — Years to assess (e.g. `[2030, 2035]`).
- `julia_output_dir`     — Directory for generated Julia scripts.
- `slurm_output_dir`     — Directory for generated SLURM scripts.
- `batch_output_dir`     — Directory for the batch submission script.
- `scenarios`            — ISP24 scenarios: 1=Progressive Change,
                           2=Step Change, 3=Green Energy Exports. Default: `[1,2,3]`.
- `poes`                 — Probability-of-exceedance for demand. Default: `[10, 50]`.
- `ref_traces`           — Weather/demand reference traces. Default: 2011–2023.
- `samples`              — Total Monte Carlo samples. Default: `1000`.
- `base_path`            — Root GPFS path for all datasets and results on Spartan.
- `julia_repo_path`      — Absolute path to this repo on Spartan.
- `n_threads`            — Julia thread count (`--threads` flag and `--cpus-per-task`).
- `time_limit`           — SLURM wall-time limit string. Default: `"2-00:00:00"`.
- `results_folder`       — Sub-folder name for result CSVs. Default: `"results-spartan"`.
- `sample_number_per_run`— Batch size used only to validate `n_threads` (see threading
                           note above); not forwarded to the generated scripts.
"""
function generate_run_scripts(;
    target_years::Vector{Int},
    julia_output_dir::String         = "scripts/arpst-stage-5/julia",
    slurm_output_dir::String         = "scripts/arpst-stage-5/slurm",
    batch_output_dir::String         = "scripts/arpst-stage-5/batch",
    scenarios::Vector{Int}           = [1, 2, 3],
    poes::Vector{Int}                = [10, 50],
    ref_traces::Vector{Int}          = collect(2011:2023),
    samples::Int                     = 1000,
    base_path::String                = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597",
    julia_repo_path::String          = "/home/papablazadon/git/NEM-reliability-suite",
    n_threads::Int                   = 10,
    time_limit::String               = "2-00:00:00",
    results_folder::String           = "results-spartan",
    sample_number_per_run::Int       = 100
)
    parallelism_cap = ceil(Int, samples / sample_number_per_run)
    if n_threads > parallelism_cap
        @warn "n_threads=$n_threads exceeds the effective parallelism cap of $parallelism_cap " *
              "(= samples=$samples / sample_number_per_run=$sample_number_per_run). " *
              "Extra CPUs will be reserved but idle."
    end

    mkpath(julia_output_dir)
    mkpath(slurm_output_dir)
    mkpath(batch_output_dir)

    n_scripts = length(target_years) * length(scenarios) * length(poes)
    slurm_paths = String[]

    for ty in target_years
        for scenario in scenarios
            for poe in poes
                base_name  = "RUN-TY$(ty)-S$(scenario)-POE$(poe)"
                jl_path    = joinpath(julia_output_dir, base_name * ".jl")
                slurm_path = joinpath(slurm_output_dir, base_name * ".slurm")

                write_julia_script(
                    jl_path, ty, scenario, poe,
                    ref_traces, samples, base_path, julia_repo_path, results_folder
                )
                write_slurm_script(
                    slurm_path, abspath(jl_path), ty, scenario, poe, n_threads, time_limit
                )
                push!(slurm_paths, abspath(slurm_path))
            end
        end
    end

    batch_id      = lpad(string(rand(UInt32), base=16), 8, '0')
    batcher_path  = joinpath(batch_output_dir, "batch-$(batch_id).sh")
    write_batcher_script(batcher_path, slurm_paths)

    println("Generated $n_scripts Julia + SLURM script pairs.")
    println("  Julia scripts : $julia_output_dir")
    println("  SLURM scripts : $slurm_output_dir")
    println("  Batcher       : $batcher_path")
end
