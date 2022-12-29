# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tidyverse","scoringRules", "epinet", "autotracer", "igraph", "future", "furrr", "data.table"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multiprocess")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source(files = "R")
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(
    name = performance4,
    command = clean_safe_results(purrr::rerun(40, safe_run_simulation(cluster_frac_use = 4)))
  ),
  tar_target(
    name = performance5,
    command = clean_safe_results(purrr::rerun(40, safe_run_simulation(cluster_frac_use = 5)))
  ),
  tar_target(
    name = performance6,
    command = purrr::rerun(40, run_simulation(cluster_frac_use = 6))
  ),
  tar_target(
    name = performance7,
    command = purrr::rerun(40, run_simulation(N=250))
  ),
  tar_target(
    name = performance8,
    command = purrr::rerun(40, run_simulation(N=500))
  ),
  tar_target(
    name = performance9,
    command = purrr::rerun(40, run_simulation(N=1000))
  ),
  tar_target(
    name = performance,
    command = combine_scenarios(list(performance4, performance5, performance6,performance7,performance8,performance9), 
                               c(sprintf("Cluster = %s;N = 100", 4:6), "Cluster = 5;N = 250","Cluster = 5;N = 500", "Cluster = 5;N = 1000"))
  ),
  tar_target(
    name = output,
    command = write_performance(performance),
    format = "file"
  ),
  tar_target(
    name = results,
    command = calculate_rms(performance)
  ),
  tar_target(
    name = figures,
    command = make_figures_for_publication()
  ),
  tar_target(
    name = table1,
    command = generate_table(results)
  )
)
