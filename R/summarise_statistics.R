#' Summarise Statistics
#' 
#' Create the summary statistics from the simulation run
#' @param mycov 
#' @param out_data 
#' @param simple_estimated_clusters
#' @param actual_clusters
#' @param infx_clust
#' 
#' @returns a data.frame
#' 
#' @export
#' 


summarise_statistics <- function(mycov, out_data,simple_estimated_clusters ,actual_clusters,infx_clust){
    sumz <- mycov |>
left_join(out_data  |>select(patient_id,date )) |>
arrange(household) |>
left_join(simple_estimated_clusters, by = "patient_id") |>
left_join(actual_clusters |>
          mutate(patient_id= as.numeric(patient_id)) |>
          select(patient_id, cluster_member) )|>
group_by(household) |>
summarise( members = n(),
             infections = sum(!is.na(date)),
          clusters = length(unique(cluster_id)),
          actual_clusters = length(unique(cluster_member))) |>
          filter(infections > 0) |>
          arrange(household)


analysis_details <- list()

analysis_details$actual_cluster_n <- length(unique(membership(infx_clust)))
analysis_details$actual_cluster_size <- as.vector(prop.table(table(membership(infx_clust))) %*% 1:length(unique(membership(infx_clust))))

analysis_details$estimated_cluster_n <- length(unique(simple_estimated_clusters$cluster_id))
analysis_details$estimate_cluster_size <-mean(count(simple_estimated_clusters,cluster_id)$n)

return(as.data.frame(analysis_details))
}
