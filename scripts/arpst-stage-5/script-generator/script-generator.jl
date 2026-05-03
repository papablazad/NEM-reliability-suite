include("/home/papablazadon/git/NEM-reliability-suite/utils/generate-run-scripts.jl")

generate_run_scripts(
    target_years     = collect(2025:2040),                          # e.g. collect(2025:2050)
    scenarios        = [1,2,3],
    poes             = [10,50],
    ref_traces       = collect(2011:2023),
    samples          = 1000,
    julia_output_dir = "/home/papablazadon/git/NEM-reliability-suite/scripts/arpst-stage-5/runs-v2",
    slurm_output_dir = "/home/papablazadon/executions/ar-pst/slurm-v2",
    batch_output_dir = "/home/papablazadon/executions/ar-pst/batch-v2",
)

# generate_run_scripts(
#     target_years     = [2029],                          # e.g. collect(2025:2050)
#     scenarios        = [1,2,3],
#     poes             = [10],
#     ref_traces       = [2011,2012,2013,2017,2020],
#     samples          = 100,
#     julia_output_dir = "/home/papablazadon/git/NEM-reliability-suite/scripts/arpst-stage-5/runs-test",
#     slurm_output_dir = "/home/papablazadon/executions/ar-pst/slurm-test",
#     batch_output_dir = "/home/papablazadon/executions/ar-pst/batch-test",
# )
