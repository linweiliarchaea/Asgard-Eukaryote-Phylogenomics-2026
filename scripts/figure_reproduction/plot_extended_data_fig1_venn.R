library(eulerr)

venn_summary <- read.csv("data/viral_detection_comparison/summary_venn_counts.csv")

for (i in seq_len(nrow(venn_summary))) {
  fit <- euler(c(
    geNomad = venn_summary$geNomad_only[i],
    Phager  = venn_summary$Phager_only[i],
    "geNomad&Phager" = venn_summary$shared[i]
  ))
  pdf(file.path("data/viral_detection_comparison",
                paste0("venn_", venn_summary$group[i], ".pdf")),
      width = 5, height = 5)
  print(plot(
    fit,
    fills = list(fill = c("#1F77B4", "#FF7F0E"), alpha = 0.5),
    edges = list(col = "black", lwd = 2),
    quantities = list(font = 2, cex = 1.3),
    main = paste0(venn_summary$group[i], " MAGs")
  ))
  dev.off()
}