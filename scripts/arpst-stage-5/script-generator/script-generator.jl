# include("/home/papablaza/git/NEM-reliability-suite/utils/generate-run-scripts.jl")

# generate_run_scripts(
#     target_years          = collect(2025:2040),                          # e.g. collect(2025:2050)
#     scenarios             = [1,2,3],
#     poes                  = [10,50],
#     ref_traces            = collect(2011:2023),
#     samples               = 100,
#     julia_output_dir      = "/home/papablaza/git/NEM-reliability-suite/scripts/arpst-stage-5/jobs/runs-100s",
#     slurm_output_dir      = "/home/papablaza/executions/ar-pst/jobs/slurm-100s",
#     batch_output_dir      = "/home/papablaza/executions/ar-pst/jobs/batch-100s",
#     base_path             = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597",
#     julia_repo_path       = "/home/papablaza/git/NEM-reliability-suite",
#     n_threads             = 10,
#     time_limit            = "2-00:00:00",
#     results_folder        = "results-spartan",
#     sample_number_per_run = 100
# )

generate_run_scripts(
    target_years     = [2045],                          # e.g. collect(2025:2050)
    scenarios        = [2],
    poes             = [10],
    ref_traces       = [2011],
    samples          = 100,
    julia_output_dir = "/home/papablaza/git/NEM-reliability-suite/scripts/arpst-stage-5/jobs/runs-test",
    slurm_output_dir = "/home/papablaza/executions/ar-pst/jobs/test/slurm",
    batch_output_dir = "/home/papablaza/executions/ar-pst/jobs/test/batch",
    base_path        = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597",
    julia_repo_path  = "/home/papablaza/git/NEM-reliability-suite",
    n_threads        = 10,
    time_limit       = "2-00:00:00",
    results_folder   = "results-spartan",
)
