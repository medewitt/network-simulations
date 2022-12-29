make_figures_for_publication <- function(){

    set.seed(23)

    dat_in = simulate_data()
    dat_fit = fit_estimated_network(dat_in[["out_data"]])


    ragg::agg_jpeg(here::here("output", "tranmission-tree.jpeg"), quality = 900,  height = 8.5, width = 11, units = "in")
    plot(dat_in$epi, main = "")
    dev.off()

    ragg::agg_jpeg(here::here("output", "tranmission-clusters.jpeg"), quality = 900,  height = 8.5, width = 11, units = "in")
    
    op <- par()
    par(mfrow = c(1,2))
    plot(dat_in$infx_clust, dat_in$infx_net,vertex.label=NA )
    mtext("A", side = 3, line = 1, adj = .1, cex = 2)
    plot(dat_fit$estimated_cluster,vertex.label=NA)
    mtext("B", side = 3, line = 1, adj = .1, cex = 2)
    dev.off()
    on.exit(op)

    TRUE

}