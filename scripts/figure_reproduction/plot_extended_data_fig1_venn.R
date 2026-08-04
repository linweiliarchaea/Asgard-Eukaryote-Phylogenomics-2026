################################################################################
# Extended Data — Viral detection overlap (geNomad vs Phager)
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Methods context
# ---------------
# Viral sequences were identified primarily with geNomad (conservative mode)
# during primary decontamination. An independent viral-calling tool (Phager)
# was used for comparison of detection overlap across major archaeal MAG
# groups. Free-virus calls (not proviruses) informed contaminant removal;
# method concordance is summarised as three-way counts (geNomad only, Phager
# only, shared) and plotted as Euler diagrams.
#
# Input
# -----
#   data/viral_detection_comparison/summary_venn_counts.xlsx
#   Required columns: group, geNomad_only, Phager_only, shared
#
# Output
# ------
#   data/viral_detection_comparison/venn_<group>.pdf
#
# Dependencies
# ------------
#   install.packages(c("eulerr", "readxl"))
################################################################################

library(eulerr)
library(readxl)

input_xlsx <- "data/viral_detection_comparison/summary_venn_counts.xlsx"
out_dir    <- "data/viral_detection_comparison"

if (!file.exists(input_xlsx)) {
  stop("Missing input: ", input_xlsx)
}
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

venn_summary <- as.data.frame(read_excel(input_xlsx, sheet = 1))
required <- c("group", "geNomad_only", "Phager_only", "shared")
missing_cols <- setdiff(required, names(venn_summary))
if (length(missing_cols) > 0) {
  stop("Table missing columns: ", paste(missing_cols, collapse = ", "))
}

for (i in seq_len(nrow(venn_summary))) {
  grp <- as.character(venn_summary$group[i])
  message("Plotting: ", grp)

  fit <- euler(c(
    geNomad = venn_summary$geNomad_only[i],
    Phager  = venn_summary$Phager_only[i],
    "geNomad&Phager" = venn_summary$shared[i]
  ))

  outfile <- file.path(out_dir, paste0("venn_", grp, ".pdf"))
  pdf(outfile, width = 5, height = 5)
  print(plot(
    fit,
    fills = list(fill = c("#1F77B4", "#FF7F0E"), alpha = 0.5),
    edges = list(col = "black", lwd = 2),
    quantities = list(font = 2, cex = 1.3),
    labels = list(font = 2, cex = 1.1),
    main = paste0(grp, " MAGs")
  ))
  dev.off()
  message("  Wrote ", outfile)
}

message("Done. Euler diagrams written under ", out_dir)
################################################################################
