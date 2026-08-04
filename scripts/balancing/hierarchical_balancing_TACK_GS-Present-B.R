################################################################################
# Hierarchical taxonomic balancing — TACK archaea (Thermoproteota)
# Dataset: GS-Present-B
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Purpose
# -------
# Construct a taxonomically balanced representation of TACK archaea for the
# independently assembled genome collection GS-Present-B. Balancing was
# performed hierarchically so that major archaeal groups (Asgard and TACK)
# were brought to comparable representation, while Euryarchaeota and DPANN
# were retained at modestly lower numbers.
#
# Core algorithm (as implemented and described in Methods)
# --------------------------------------------------------
# 1. At a given taxonomic rank, count the number of genomes in each lineage.
# 2. Sort lineages from smallest to largest.
# 3. average = remaining_target / number_of_lineages_still_to_be_processed.
# 4. If a lineage has ≤ average genomes → retain ALL of them.
# 5. If a lineage has > average genomes → descend to the next lower rank
#    (order → family → genus → species) and repeat the same calculation.
# 6. Final retention numbers for each terminal lineage are recorded in
#    sampling.xlsx.
# 7. The execution stage samples genomes according to sampling.xlsx and
#    copies the selected FASTA files to the output directory.
#
# Input
# -----
# - GTDB release metadata (ar53_metadata_r220.tsv)
# - GTDB-Tk summary tables (contig / scaffold / chromosome / complete)
# - dRep-dereplicated genome directory
# - sampling.xlsx (decision table prepared during the exploration stage)
#
# Output
# ------
# - Selected Thermoproteota genome FASTA files for GS-Present-B
################################################################################

##############################
# Stage 1: Data preparation
##############################

# --- 1.1 High-quality RefSeq isolate complete genomes ----------------------
# Filter criteria:
#   - RS_ accessions (RefSeq)
#   - ncbi_genome_category == "none"
#   - Complete Genome assembly level
#   - CheckM2 completeness ≥ 70%
#   - CheckM2 contamination ≤ 10%

ar53_metadata_r220 <- read.delim(
  "/path/to/ar53_metadata_r220.tsv",
  stringsAsFactors = FALSE,
  header = TRUE
)

ar53_metadata_r220_RS <- ar53_metadata_r220[
  substr(ar53_metadata_r220$accession, 1, 3) == "RS_" &
    ar53_metadata_r220$ncbi_genome_category == "none" &
    ar53_metadata_r220$ncbi_assembly_level == "Complete Genome" &
    ar53_metadata_r220$checkm2_completeness >= 70 &
    ar53_metadata_r220$checkm2_contamination <= 10,
]

# Extract Thermoproteota isolates (TACK component)
phylum <- sapply(ar53_metadata_r220_RS$gtdb_taxonomy, function(x) {
  strsplit(x, ";")[[1]][2]
})
RS_Thermoproteota <- ar53_metadata_r220_RS[phylum == "p__Thermoproteota", ]
RS_Thermoproteota_class <- sapply(RS_Thermoproteota$gtdb_taxonomy, function(x) {
  strsplit(x, ";")[[1]][3]
})

# --- 1.2 GTDB-Tk classifications for MAGs at all assembly levels -----------
gtdbtk.ar53_contig <- read.table(
  "/path/to/gtdbtk/MAG_archaea_contig_new/gtdbtk.ar53.summary.tsv",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
gtdbtk.ar53_scaffold <- read.table(
  "/path/to/gtdbtk/MAG_archaea_scaffold_new/gtdbtk.ar53.summary.tsv",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
gtdbtk.ar53_chromosome <- read.table(
  "/path/to/gtdbtk/MAG_archaea_chromosome_new/gtdbtk.ar53.summary.tsv",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
gtdbtk.ar53_complete_genomes <- read.table(
  "/path/to/gtdbtk/MAG_archaea_complete_genomes/gtdbtk.ar53.summary.tsv",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)

gtdbtk.ar53.summary_all <- rbind(
  gtdbtk.ar53_contig,
  gtdbtk.ar53_scaffold,
  gtdbtk.ar53_chromosome,
  gtdbtk.ar53_complete_genomes
)

# Retain only genomes that survived dRep dereplication
dRep <- dir("/path/to/dRep/Thermoproteota/dereplicated_genomes")
dRep_ids <- sapply(dRep, function(x) strsplit(x, ".fna")[[1]][1])
gtdbtk.ar53.summary <- subset(
  gtdbtk.ar53.summary_all,
  user_genome %in% dRep_ids
)

# Class-level taxonomy (starting rank for hierarchical balancing)
gtdbtk.ar53.summary_class <- sapply(
  gtdbtk.ar53.summary$classification,
  function(x) strsplit(x, ";")[[1]][3]
)


##############################
# Stage 2: Exploration & decision phase
#
# Manually inspect taxonomic distributions to decide how many genomes to
# retain at each rank. Results of this phase are recorded in sampling.xlsx.
#
# Procedure at each rank:
#   look at counts → calculate average → keep small lineages fully →
#   drill down into large lineages at the next lower rank
##############################

cat("\n========== Class-level distribution (Thermoproteota) ==========\n")
print(sort(table(gtdbtk.ar53.summary_class), decreasing = TRUE))

# ----- Class: Methanomethylicia -------------------------------------------
cat("\n----- c__Methanomethylicia -----\n")
Methanomethylicia <- gtdbtk.ar53.summary[
  gtdbtk.ar53.summary_class == "c__Methanomethylicia",
]
Methanomethylicia_order <- sapply(
  Methanomethylicia$classification,
  function(x) strsplit(x, ";")[[1]][4]
)
print(sort(table(Methanomethylicia_order), decreasing = TRUE))

# Order B29-G17 → Family DSZF01 → species level
B29_G17 <- Methanomethylicia[Methanomethylicia_order == "o__B29-G17", ]
B29_G17_family <- sapply(B29_G17$classification, function(x) strsplit(x, ";")[[1]][5])
print(sort(table(B29_G17_family), decreasing = TRUE))

DSZF01 <- B29_G17[B29_G17_family == "f__DSZF01", ]
DSZF01_species <- sapply(DSZF01$classification, function(x) strsplit(x, ";")[[1]][7])
print(sort(table(DSZF01_species), decreasing = TRUE))

# Order Nezhaarchaeales
Nezhaarchaeales <- Methanomethylicia[
  Methanomethylicia_order == "o__Nezhaarchaeales",
]
Nezhaarchaeales_family <- sapply(
  Nezhaarchaeales$classification,
  function(x) strsplit(x, ";")[[1]][5]
)
print(sort(table(Nezhaarchaeales_family), decreasing = TRUE))

B40_G2 <- Nezhaarchaeales[Nezhaarchaeales_family == "f__B40-G2", ]
B40_G2_genus <- sapply(B40_G2$classification, function(x) strsplit(x, ";")[[1]][6])
print(sort(table(B40_G2_genus), decreasing = TRUE))

unknown <- B40_G2[B40_G2_genus == "g__", ]
unknown_species <- sapply(unknown$classification, function(x) strsplit(x, ";")[[1]][7])
print(sort(table(unknown_species), decreasing = TRUE))

WYZ_LMO8 <- Nezhaarchaeales[Nezhaarchaeales_family == "f__WYZ-LMO8", ]
WYZ_LMO8_genus <- sapply(WYZ_LMO8$classification, function(x) strsplit(x, ";")[[1]][6])
print(sort(table(WYZ_LMO8_genus), decreasing = TRUE))

WYZ_LMO8_2 <- WYZ_LMO8[WYZ_LMO8_genus == "g__WYZ-LMO8", ]
WYZ_LMO8_2_species <- sapply(
  WYZ_LMO8_2$classification,
  function(x) strsplit(x, ";")[[1]][7]
)
print(sort(table(WYZ_LMO8_2_species), decreasing = TRUE))

# Order Methanomethylicales → Family Methanomethylicaceae → genus → species
Methanomethylicales <- Methanomethylicia[
  Methanomethylicia_order == "o__Methanomethylicales",
]
Methanomethylicales_family <- sapply(
  Methanomethylicales$classification,
  function(x) strsplit(x, ";")[[1]][5]
)
print(sort(table(Methanomethylicales_family), decreasing = TRUE))

Methanomethylicaceae <- Methanomethylicales[
  Methanomethylicales_family == "f__Methanomethylicaceae",
]
Methanomethylicaceae_genus <- sapply(
  Methanomethylicaceae$classification,
  function(x) strsplit(x, ";")[[1]][6]
)
print(sort(table(Methanomethylicaceae_genus), decreasing = TRUE))

for (g in c("g__WYZ-LMO11", "g__Methanomethylicus",
            "g__WYZ-LMO10", "g__Methanosuratincola")) {
  sub <- Methanomethylicaceae[Methanomethylicaceae_genus == g, ]
  sp  <- sapply(sub$classification, function(x) strsplit(x, ";")[[1]][7])
  cat("\nSpecies within ", g, ":\n", sep = "")
  print(sort(table(sp), decreasing = TRUE))
}

# ----- Class: Nitrososphaeria_A -------------------------------------------
cat("\n----- c__Nitrososphaeria_A -----\n")
Nitrososphaeria_A <- gtdbtk.ar53.summary[
  gtdbtk.ar53.summary_class == "c__Nitrososphaeria_A",
]
Nitrososphaeria_A_family <- sapply(
  Nitrososphaeria_A$classification,
  function(x) strsplit(x, ";")[[1]][5]
)
print(sort(table(Nitrososphaeria_A_family), decreasing = TRUE))
# Continue hierarchical inspection for Caldarchaeaceae, HR02,
# Wolframiiraptoraceae and their genera/species as needed.
# Pattern: inspect counts → decide keep-all or drill down one rank.

# ----- Class: Thermoprotei ------------------------------------------------
cat("\n----- c__Thermoprotei -----\n")
Thermoprotei <- gtdbtk.ar53.summary[
  gtdbtk.ar53.summary_class == "c__Thermoprotei",
]
Thermoprotei_order <- sapply(
  Thermoprotei$classification,
  function(x) strsplit(x, ";")[[1]][4]
)
print(sort(table(Thermoprotei_order), decreasing = TRUE))
# Continue hierarchical inspection for large orders.

# ----- Class: Bathyarchaeia -----------------------------------------------
cat("\n----- c__Bathyarchaeia -----\n")
Bathyarchaeia <- gtdbtk.ar53.summary[
  gtdbtk.ar53.summary_class == "c__Bathyarchaeia",
]
Bathyarchaeia_order <- sapply(
  Bathyarchaeia$classification,
  function(x) strsplit(x, ";")[[1]][4]
)
print(sort(table(Bathyarchaeia_order), decreasing = TRUE))
# Large orders (e.g. EX4484-135, B25, B24, RBG-16-48-13, TCS64) are further
# inspected at family → genus → species.

# ----- Class: Nitrososphaeria ---------------------------------------------
cat("\n----- c__Nitrososphaeria -----\n")
Nitrososphaeria <- gtdbtk.ar53.summary[
  gtdbtk.ar53.summary_class == "c__Nitrososphaeria",
]
Nitrososphaeria_order <- sapply(
  Nitrososphaeria$classification,
  function(x) strsplit(x, ";")[[1]][4]
)
print(sort(table(Nitrososphaeria_order), decreasing = TRUE))
# Conexivisphaerales and Nitrososphaerales further broken down as needed.

# After completing inspections for all major classes, record the final
# retention numbers for each terminal lineage in sampling.xlsx.
#
# Expected format of sampling.xlsx (no header row):
#   column 1 : class
#   column 2 : order   (NA if sampling is performed only at class level)
#   column 3 : family  (NA if sampling stops at order level)
#   column 4 : genus   (NA if sampling stops at family level)
#   column 5 : species (NA if sampling stops at genus level)
#   column 6 : n_retain (integer — number of genomes to keep)


##############################
# Stage 3: Execution phase
# Read the pre-decided sampling table and retain the prescribed genomes
##############################

# Pre-compute taxonomy vectors for efficient matching
class_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][3])
order_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][4])
family_gtdbtk  <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][5])
genus_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][6])
species_gtdbtk <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][7])

# Prefer readxl (xlsx depends on Java and is more fragile)
if (!requireNamespace("readxl", quietly = TRUE)) {
  stop("Please install the 'readxl' package: install.packages('readxl')")
}
library(readxl)

# Sheet index corresponds to the Thermoproteota decision table
# (adjust sheet number if sampling.xlsx uses a different layout)
sampling <- read_excel("sampling.xlsx", sheet = 5, col_names = FALSE)
sampling[[6]] <- as.integer(sampling[[6]])

# Select genomes according to the taxonomic depth specified in each row
select_genomes <- function(row) {
  n_levels <- sum(!is.na(unlist(row[1:5])))
  n_keep   <- as.integer(row[[6]])

  if (n_levels == 1) {
    pool <- gtdbtk.ar53.summary$user_genome[class_gtdbtk == row[[1]]]
  } else if (n_levels == 2) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == row[[1]] & order_gtdbtk == row[[2]]
    ]
  } else if (n_levels == 3) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == row[[1]] & order_gtdbtk == row[[2]] &
        family_gtdbtk == row[[3]]
    ]
  } else if (n_levels == 4) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == row[[1]] & order_gtdbtk == row[[2]] &
        family_gtdbtk == row[[3]] & genus_gtdbtk == row[[4]]
    ]
  } else if (n_levels == 5) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == row[[1]] & order_gtdbtk == row[[2]] &
        family_gtdbtk == row[[3]] & genus_gtdbtk == row[[4]] &
        species_gtdbtk == row[[5]]
    ]
  } else {
    stop("Invalid number of taxonomic levels in sampling row")
  }

  if (length(pool) <= n_keep) {
    return(pool)
  }
  # Note: Methods describe representative selection prioritising genome
  # quality and within-lineage diversity. The sampling.xlsx table records
  # the final retention numbers; random sampling is used here when the
  # pool exceeds n_keep. For strict reproducibility, replace sample()
  # with a deterministic ranking (e.g. by completeness, contamination, N50).
  sample(pool, n_keep)
}

selected <- unlist(lapply(seq_len(nrow(sampling)), function(i) {
  message("Processing row ", i, " / ", nrow(sampling))
  select_genomes(sampling[i, ])
}))

# Copy selected genomes to the output directory for GS-Present-B
output_dir <- "/path/to/genome_all/Thermoproteota_MAGs_selected/"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

source_dir <- "/path/to/dRep/Thermoproteota/dereplicated_genomes/"

file.copy(
  from = paste0(source_dir, selected, ".fna"),
  to   = output_dir,
  overwrite = FALSE
)

message("Selected ", length(selected), " Thermoproteota genomes for GS-Present-B.")
message("Files written to: ", output_dir)

################################################################################
# End of script
################################################################################
