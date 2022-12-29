calculate_rms <- function(dat){
    dat |>
    group_by(scenario)  |>
    summarise(cluster_n_error = sqrt(mean((actual_cluster_n-estimated_cluster_n)^2)),
              #cluster_n_crps = crps(estimated_cluster_n, "pois", lambda = actual_cluster_size),
          cluster_size_error = sqrt(mean((actual_cluster_size - estimate_cluster_size)^2) ),
          actual_cluster_n = mean(actual_cluster_n),
          estimated_cluster_n = mean(estimated_cluster_n))
}

