
#%%
using Pkg; Pkg.activate("."); #Pkg.instantiate()
using PRAS
using Gurobi
using JuMP
using PRASNEM
using SchedNEM
using Dates
using CSV
using Statistics

include("/home/papablazadon/git/NEM-reliability-suite/functions/assess_adequacy.jl")

scenario = 2
samples  = 1000
for ty in [2030]
    for ref_trace in collect(2011:2023)
        for poe in [10, 50]
            ens = assess_adequacy(  target_year     = ty, 
                                    reference_trace = ref_trace, 
                                    poe             = poe, 
                                    samples         = samples, 
                                    scenario        = scenario, 
                                    base_path       = "/data/gpfs/projects/punim2114/arpst/proj-4310_arpst_2026-1128.4.1597", 
                                    solver          = "Gurobi",
                                    results_folder  = "results-spartan")
        end
    end
end
