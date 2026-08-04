################################################################################
# Collect geNomad virus-summary tables across genomes
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Methods
# -------
# Viral sequences were independently identified using geNomad v1.8.0 with the
# conservative detection mode enabled. This script aggregates
# *_virus_summary.tsv outputs into a single table for downstream filtering.
#
# Input  : recursive search for *_virus_summary.tsv under the working directory
# Output : genomad_conservative.xlsx (or .txt)
################################################################################

genomad_files <- dir(pattern = "_virus_summary\\.tsv$", recursive = TRUE)

if (length(genomad_files) == 0) {
  stop("No *_virus_summary.tsv files found.")
}

genomad_data <- data.frame()

for (x in genomad_files) {
  message("Reading: ", x)
  genomad <- read.table(x, stringsAsFactors = FALSE, header = TRUE, sep = "\t")

  if (nrow(genomad) == 0) {
    next
  }

  # Genome ID = first path component (adjust if your directory layout differs)
  genome_id <- strsplit(x, "/")[[1]][1]
  genomad <- transform(genomad, genome = genome_id)
  genomad_data <- rbind(genomad_data, genomad)
}

# Prefer a plain TSV for portability; Excel optional
outfile <- "genomad_conservative.txt"
write.table(
  genomad_data,
  file = outfile,
  row.names = FALSE,
  quote = FALSE,
  sep = "\t"
)
message("Wrote ", nrow(genomad_data), " rows to ", outfile)

# Optional Excel export (requires Java for xlsx; prefer openxlsx or readxl workflows)
# if (requireNamespace("openxlsx", quietly = TRUE)) {
#   openxlsx::write.xlsx(genomad_data, "genomad_conservative.xlsx")
# }
################################################################################
