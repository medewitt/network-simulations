#' Simulate Network and Epidemic Data for Use in Simulations
#' @param N an integer, the population size
#' @param cluster_frac an positive double, the average household size
#' @param homophily a double, the log-odds contribution of matching family unit
#' 

simulate_data <- function(N = 100, cluster_frac = 4, homophily = 7){

    cluster_center <- round(N / cluster_frac)
    
    mycov <- data.frame(patient_id = 1:N, xpos = runif(N), ypos = runif(N))

    mycov$household <- kmeans(as.matrix(mycov[, 2:3]), centers = cluster_center)$cluster
    
    mycov$employer <- round(rexp(N,1)*10)

    dyadCov <- BuildX(mycov, binaryCol = list(c(2, 3)), 
                      binaryFunc = "euclidean", unaryCol = c(4,5), 
                      unaryFunc = c("match", "match"))

    eta <- c(0, homophily, 2,-10)

    net <- SimulateDyadicLinearERGM(N = N, dyadiccovmat = dyadCov, eta = eta)

    epi <- SEIR.simulator(M = net, N = N, beta = .2,
                      ki = 30.25, thetai = .18, 
                      ke = 30/25, thetae = .18, latencydist = "gamma")

    contact_mat <- epi |>
    as.data.frame() |>
    setNames(c("to", "from", "exposure", "infected", "recovered")) |>
    na.omit()

    infected <- unique(c(contact_mat$to, contact_mat$from))

    infx_net <- graph_from_data_frame(contact_mat, 
    directed = FALSE,
    vertices = as.data.frame(mycov) |> filter(patient_id %in% infected))

    infx_clust <- fastgreedy.community(infx_net)

    actual_clusters <- tibble(patient_id =  as_ids(V(infx_net)),
                              cluster_member = membership(infx_clust),
                              household = V(infx_net)$household,
                              employer = V(infx_net)$employer) |>
                              arrange(cluster_member)

    out_data <- mycov |>
    dplyr::filter(patient_id %in% infected) |>
    dplyr::arrange(household) |>
    dplyr::left_join(contact_mat |>
                 select(patient_id = to, infected), 
                 by = "patient_id") |>
           mutate(date = ceiling(infected) + Sys.Date())


    list(mycov, epi = epi, contact_mat = contact_mat, 
        infected=infected, 
        infx_net=infx_net, infx_clust=infx_clust,
        actual_clusters = actual_clusters, out_data=out_data)
}
