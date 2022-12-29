generate_table <- function(x){
    x |>
    separate(scenario, c("cluster size", "n"), ";") |>
    dplyr::mutate(`cluster size` = stringr::str_extract(`cluster size`, "\\d+")) |>
dplyr::mutate(n = stringr::str_extract(n, "\\d+")) |>
dplyr::select(Unit = `cluster size`, n, actual_cluster_n, 
estimated_cluster_n, cluster_n_error,cluster_size_error ) |>
dplyr::mutate_if(is.double, round, digits = 1) |>
dplyr::arrange(n) |>
gt::gt() |>
 gt::cols_label(
    Unit = "Average Members per Household (N)",
    n = "Population Size (N)",
    actual_cluster_n = "Average Synthetic Clusters (N)",
    estimated_cluster_n = "Average Estimated Clusters (N)",
    cluster_n_error = "Cluster Number Error (RMSE)",
    cluster_size_error = "Cluster Size Error (RMSE)"
  )  |>
  gt::tab_footnote(
    footnote = "Model parameter for the average number of members in a household.",
    locations = gt::cells_column_labels(
      columns = c(Unit)
    )) |>
    gt::tab_footnote(
    footnote = "Model parameter for the size of the population in which to simulate the spread of a pathogen.",
    locations = gt::cells_column_labels(
      columns = c(n)
    )) |>
  gt::tab_footnote(
    footnote = "Square root of the mean of the squared difference between actual and estimated.",
    locations = gt::cells_column_labels(
      columns = c(cluster_n_error,cluster_size_error )
    )) |>
    gt::gtsave("output/table1.docx")

    TRUE
}