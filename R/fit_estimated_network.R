fit_estimated_network <- function(dat){

    safe_estimate <- safely(autotracer::connect_probable_cases)
    plan(multisession)
    estimated_household <- future_map(split(dat, dat$household),safe_estimate )

    estimates_out <- estimated_household |>
    map("result") |>
    bind_rows(.id = "cluster_id")

    simple_estimated_clusters <- estimates_out |>
      select(cluster_id, from, to) |>
      gather(instance, patient_id, -cluster_id) |>
      select(patient_id, cluster_id)|>
      unique() 

    estimated_cluster = igraph::simplify(graph_from_data_frame(estimates_out, directed = FALSE))

    mapped_clusters = decompose(estimated_cluster) |>
    map(function(x) as_ids(V(x)))

    list(simple_estimated_clusters = simple_estimated_clusters, estimated_cluster = estimated_cluster, mapped_clusters = mapped_clusters)

}
