#' Run Simulation
#' @param N_in a positive integer, the size of the population for the simulation
#' @param cluster_frac_use a positive integer, represents average household size
#' @param homophily a double, representing the log odds contribution to being an edge
#' 
#' @export a data.frame 

run_simulation <- function(N_in = 100, cluster_frac_use = 5, homophily = 7){
    dat_in = simulate_data(N_in, cluster_frac = cluster_frac_use, homophily =homophily)
    dat_fit = fit_estimated_network(dat_in[["out_data"]])

    summarise_statistics(dat_in[[1]], dat_in$out_data, dat_fit$simple_estimated_clusters, 
                         actual_clusters = dat_in$actual_clusters, infx_clust = dat_in$infx_clust)


}

safe_run_simulation = purrr::safely(run_simulation)


clean_safe_results <- function(x){
    x |>
    purrr::map("result")

}