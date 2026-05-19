include("/home/papablaza/git/NEM-reliability-suite/utils/generate-run-scripts.jl")

generate_run_scripts(
    target_years          = [2025, 2030, 2035, 2040],                          # e.g. collect(2025:2050)
    scenarios             = [2],
    poes                  = [50],
    ref_traces            = [2017],
    samples               = 500,
    julia_output_dir      = "/home/papablaza/git/NEM-reliability-suite/scripts/arpst-stage-5/jobs/runs-r11-2017p10-s2-baseVPP",
    slurm_output_dir      = "/home/papablaza/executions/ar-pst/jobs/runs-r11-2017p10-s2-baseVPP/slurm",
    batch_output_dir      = "/home/papablaza/executions/ar-pst/jobs/runs-r11-2017p10-s2-baseVPP/batch",
    base_path             = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597",
    julia_repo_path       = "/home/papablaza/git/NEM-reliability-suite",
    n_threads             = 10,
    time_limit            = "3-00:00:00",
    results_folder_name   = "results-spartan",
    sample_number_per_run = 100,
    assess_adequacy_kwargs = Dict(
        :DER_parameters => "PRASNEM.get_DER_parameters(; case=\"baseVPP\")",
        :case_name      => "\"baseVPP\""
    )
)