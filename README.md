# Automatic Case Cluster Detection

This project contains the code used to generate the manuscript, **Automatic Case Cluster Detection Using Hospital Electronic Health Record Data**.

This project utilizes the [targets](https://books.ropensci.org/targets/) package and approach for workflow automation.
Additionally, the [renv](https://rstudio.github.io/renv/articles/renv.html) package was used for ensuring that the proper version of R packages was recorded to ensure repeatability.

## Running the Code
1. In order to run this project, first ensure that you have a current version of R (R >= 4.1.2). 
1. Install the `renv` package. 
1. In an R session run `renv::restore()` to restore the R package contents.
1. To reproduce the outputs, run `targets::tar_make()`

## Contents

* **R** the necessary R scripts to run the simulation
* **output** outputs from the simulations


