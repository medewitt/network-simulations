#' Write Performance
#' Write the output of the performance metrics to a csv
#' @param dat a data.frame to write to csv
#' @export 

write_performance <- function(dat){
    readr::write_csv(dat, file.path("output", "performance.csv"))
    file.path("output", "performance.csv")
}
