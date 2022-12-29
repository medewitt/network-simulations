combine_scenarios <- function(x, scenario_names ){
    x <- lapply(x, bind_rows)
    names(x) <- scenario_names
    data.table::rbindlist(x, idcol = "scenario")
}