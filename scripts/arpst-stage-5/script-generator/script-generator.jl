include("/home/papablazadon/git/NEM-reliability-suite/utils/generate-run-scripts.jl")

generate_run_scripts(
    target_years     = [2030],                          # e.g. collect(2025:2050)
    scenarios        = [1,2,3],
    poes             = [10,50],
    ref_traces       = collect(2011:2023),
    samples          = 1000,
    julia_output_dir = "/home/papablazadon/git/NEM-reliability-suite/scripts/arpst-stage-5/runs",
    slurm_output_dir = "/home/papablazadon/executions/ar-pst/slurm",
    batch_output_dir = "/home/papablazadon/executions/ar-pst/batch",
)
