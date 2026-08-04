################################################################################
# Flag candidate exogenous contigs from CAT official-names output
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Methods criteria (Identification of candidate exogenous sequences)
# -----------------------------------------------------------------
# Contig-level taxonomic classifications were generated with CAT v6.0
# (sensitive mode). Contigs annotated as "no ORFs found" were excluded.
# Candidate exogenous contigs were defined as those for which:
#   (i)   classification was restricted to the root level; or
#   (ii)  the second taxonomic rank was not cellular organisms
#         (NCBI Taxonomy ID 131567); or
#   (iii) the third taxonomic rank was not Archaea
#         (NCBI Taxonomy ID 2157).
#
# Input
# -----
# CAT_pack add_names output files matching:
#   *.contig2classification.official_names.txt
#
# Output
# ------
# Tab-delimited table of flagged contigs with genome identifiers
################################################################################

# Working directory should contain the CAT official-names files
class_files <- dir(pattern = "\\.contig2classification\\.official_names\\.txt$")

if (length(class_files) == 0) {
  stop("No *.contig2classification.official_names.txt files found in the working directory.")
}

cat_data <- data.frame()

for (x in class_files) {
  message("Processing: ", x)

  cat_name_2 <- read.delim(x, stringsAsFactors = FALSE, sep = "\t")

  # Exclude contigs with no predicted ORFs
  cat_name <- subset(cat_name_2, reason != "no ORFs found")

  if (nrow(cat_name) == 0) {
    next
  }

  # Parse lineage depth and rank taxids
  lineage_depth <- sapply(cat_name$lineage, function(y) {
    length(strsplit(y, ";")[[1]])
  })
  rank2 <- sapply(cat_name$lineage, function(y) {
    parts <- strsplit(y, ";")[[1]]
    if (length(parts) >= 2) parts[2] else NA_character_
  })
  rank3 <- sapply(cat_name$lineage, function(y) {
    parts <- strsplit(y, ";")[[1]]
    if (length(parts) >= 3) parts[3] else NA_character_
  })

  # Flag candidate exogenous contigs
  # (i)   root only          → lineage_depth == 1
  # (ii)  not cellular organisms (131567) at rank 2
  # (iii) not Archaea (2157) at rank 3
  is_exogenous <- (lineage_depth == 1) |
    (!is.na(rank2) & rank2 != "131567") |
    (!is.na(rank3) & rank3 != "2157")

  chimeric_contigs <- cat_name[is_exogenous, ]

  if (nrow(chimeric_contigs) > 0) {
    genome_id <- sub("\\.contig2classification\\.official_names\\.txt$", "", x)
    cat_data <- rbind(
      cat_data,
      data.frame(genome = genome_id, chimeric_contigs, stringsAsFactors = FALSE)
    )
  }
}

outfile <- "candidate_exogenous_contigs_CAT.txt"
write.table(
  cat_data,
  file = outfile,
  row.names = FALSE,
  quote = FALSE,
  sep = "\t"
)

message("Flagged contigs written to: ", outfile)
message("Total flagged contig records: ", nrow(cat_data))
################################################################################
