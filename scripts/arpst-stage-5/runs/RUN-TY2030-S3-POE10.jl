using Pkg; Pkg.activate("/home/papablazadon/git/NEM-reliability-suite")
using PRAS, Gurobi, JuMP, PRASNEM, SchedNEM, Dates, CSV, Statistics
include("/home/papablazadon/git/NEM-reliability-suite/functions/assess_adequacy.jl")

for ref_trace in [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
    assess_adequacy(
        target_year     = 2030,
        reference_trace = ref_trace,
        poe             = 10,
        samples         = 1000,
        scenario        = 3,
        base_path       = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597",
        solver          = "Gurobi",
        results_folder  = "results-spartan"
    )
end
