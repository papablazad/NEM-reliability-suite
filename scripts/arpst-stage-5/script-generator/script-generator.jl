include(joinpath(@__DIR__, "utils/generate-run-scripts.jl"))

generate_run_scripts(
    target_years     = [2030],                          # e.g. collect(2025:2050)
    scenarios        = [1, 2, 3],
    poes             = [10, 50],
    ref_traces       = collect(2011:2023),
    samples          = 1000,
    julia_output_dir = "/Users/papablaza/git/ARPST-CSIRO-STAGE-5/NEM-reliability-suite/scripts/arpst-stage-5/julia",
    slurm_output_dir = "/Users/papablaza/git/ARPST-CSIRO-STAGE-5/NEM-reliability-suite/scripts/arpst-stage-5/slurm",
    batch_output_dir = "/Users/papablaza/git/ARPST-CSIRO-STAGE-5/NEM-reliability-suite/scripts/arpst-stage-5/batch",
)
