################################################################################
# Hierarchical taxonomic balancing for TACK archaea (GS-Present-B)
# 
# Core logic (exactly as implemented and described in Methods):
# 1. At a given taxonomic rank, count the number of genomes in each lineage
# 2. Sort lineages from smallest to largest
# 3. average = remaining_target / number_of_lineages_still_to_be_processed
# 4. If a lineage has ≤ average genomes → keep ALL of them
# 5. If a lineage has > average genomes → go down to the next lower rank
#    (order → family → genus → species) and repeat the same calculation
# 6. Final decided numbers are recorded in sampling.xlsx
# 7. The last part of the script executes the sampling according to sampling.xlsx
################################################################################

##############################
# Stage 1: Data preparation
##############################

# Load GTDB release 220 metadata
# Used to extract high-quality isolate genomes at the complete-genome level
ar53_metadata_r220 <- read.delim(
  "/public/home/bdpguest/zhuruixin/software/release220/ar53_metadata_r220.tsv",
  stringsAsFactors = FALSE, header = TRUE
)

# Keep only high-quality RefSeq isolate complete genomes
ar53_metadata_r220_RS <- ar53_metadata_r220[
  substr(ar53_metadata_r220$accession, 1, 3) == "RS_" &
  ar53_metadata_r220$ncbi_genome_category == "none" &
  ar53_metadata_r220$ncbi_assembly_level == "Complete Genome" &
  ar53_metadata_r220$checkm2_completeness >= 70 &
  ar53_metadata_r220$checkm2_contamination <= 10, 
]

# Extract Thermoproteota isolates (part of TACK)
phylum <- sapply(ar53_metadata_r220_RS$gtdb_taxonomy, function(x) strsplit(x, ";")[[1]][2])
RS_Thermoproteota <- ar53_metadata_r220_RS[phylum == "p__Thermoproteota", ]
RS_Thermoproteota_class <- sapply(RS_Thermoproteota$gtdb_taxonomy, function(x) strsplit(x, ";")[[1]][3])

# Load GTDB-Tk classification results for MAGs at all assembly levels
# (contig-level, scaffold-level, chromosome-level and complete-genome level)
gtdbtk.ar53_contig          <- read.table("/public/home/bdpguest/zhuruixin/gtdbtk/MAG_archaea_contig_new/gtdbtk.ar53.summary.tsv",
                                          stringsAsFactors = FALSE, sep = "\t", header = TRUE)
gtdbtk.ar53_scaffold        <- read.table("/public/home/bdpguest/zhuruixin/gtdbtk/MAG_archaea_scaffold_new/gtdbtk.ar53.summary.tsv",
                                          stringsAsFactors = FALSE, sep = "\t", header = TRUE)
gtdbtk.ar53_chromosome      <- read.table("/public/home/bdpguest/zhuruixin/gtdbtk/MAG_archaea_chromosome_new/gtdbtk.ar53.summary.tsv",
                                          stringsAsFactors = FALSE, sep = "\t", header = TRUE)
gtdbtk.ar53_complete_genomes <- read.table("/public/home/bdpguest/zhuruixin/gtdbtk/MAG_archaea_complete_genomes/gtdbtk.ar53.summary.tsv",
                                          stringsAsFactors = FALSE, sep = "\t", header = TRUE)

gtdbtk.ar53.summary_all <- rbind(
  gtdbtk.ar53_contig,
  gtdbtk.ar53_scaffold,
  gtdbtk.ar53_chromosome,
  gtdbtk.ar53_complete_genomes
)

# Keep only genomes that survived dRep dereplication
dRep <- dir("/public/home/bdpguest/zhuruixin/dRep/Thermoproteota/dereplicated_genomes")
dRep_ids <- sapply(dRep, function(x) strsplit(x, ".fna")[[1]][1])
gtdbtk.ar53.summary <- subset(gtdbtk.ar53.summary_all, user_genome %in% dRep_ids)

# Parse class-level taxonomy (this is the starting rank for balancing)
gtdbtk.ar53.summary_class <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][3])

##############################
# Stage 2: Exploration & decision phase
# (This is the part you did manually to decide the numbers in sampling.xlsx)
# The long chain of subsetting below is the concrete implementation of:
#   “look at counts → calculate average → keep small lineages fully →
#    drill down into large lineages at the next lower rank”
##############################

# ----- Class: Methanomethylicia -----
Methanomethylicia <- gtdbtk.ar53.summary[gtdbtk.ar53.summary_class == "c__Methanomethylicia", ]
Methanomethylicia_order <- sapply(Methanomethylicia$classification, function(x) strsplit(x, ";")[[1]][4])

# Order B29-G17 → Family DSZF01 → Species level
B29_G17 <- Methanomethylicia[Methanomethylicia_order == "o__B29-G17", ]
B29_G17_family <- sapply(B29_G17$classification, function(x) strsplit(x, ";")[[1]][5])
DSZF01 <- B29_G17[B29_G17_family == "f__DSZF01", ]
DSZF01_species <- sapply(DSZF01$classification, function(x) strsplit(x, ";")[[1]][7])

# Order Nezhaarchaeales
Nezhaarchaeales <- Methanomethylicia[Methanomethylicia_order == "o__Nezhaarchaeales", ]
Nezhaarchaeales_family <- sapply(Nezhaarchaeales$classification, function(x) strsplit(x, ";")[[1]][5])

B40_G2 <- Nezhaarchaeales[Nezhaarchaeales_family == "f__B40-G2", ]
B40_G2_genus <- sapply(B40_G2$classification, function(x) strsplit(x, ";")[[1]][6])
unknown <- B40_G2[B40_G2_genus == "g__", ]
unknown_species <- sapply(unknown$classification, function(x) strsplit(x, ";")[[1]][7])

WYZ_LMO8 <- Nezhaarchaeales[Nezhaarchaeales_family == "f__WYZ-LMO8", ]
WYZ_LMO8_genus <- sapply(WYZ_LMO8$classification, function(x) strsplit(x, ";")[[1]][6])
WYZ_LMO8_2 <- WYZ_LMO8[WYZ_LMO8_genus == "g__WYZ-LMO8", ]
WYZ_LMO8_2_species <- sapply(WYZ_LMO8_2$classification, function(x) strsplit(x, ";")[[1]][7])

# Order Methanomethylicales → Family Methanomethylicaceae → Genus → Species
Methanomethylicales <- Methanomethylicia[Methanomethylicia_order == "o__Methanomethylicales", ]
Methanomethylicales_family <- sapply(Methanomethylicales$classification, function(x) strsplit(x, ";")[[1]][5])
Methanomethylicaceae <- Methanomethylicales[Methanomethylicales_family == "f__Methanomethylicaceae", ]
Methanomethylicaceae_genus <- sapply(Methanomethylicaceae$classification, function(x) strsplit(x, ";")[[1]][6])

WYZ_LMO11 <- Methanomethylicaceae[Methanomethylicaceae_genus == "g__WYZ-LMO11", ]
WYZ_LMO11_species <- sapply(WYZ_LMO11$classification, function(x) strsplit(x, ";")[[1]][7])

Methanomethylicus <- Methanomethylicaceae[Methanomethylicaceae_genus == "g__Methanomethylicus", ]
Methanomethylicus_species <- sapply(Methanomethylicus$classification, function(x) strsplit(x, ";")[[1]][7])

WYZ_LMO10 <- Methanomethylicaceae[Methanomethylicaceae_genus == "g__WYZ-LMO10", ]
WYZ_LMO10_species <- sapply(WYZ_LMO10$classification, function(x) strsplit(x, ";")[[1]][7])

Methanosuratincola <- Methanomethylicaceae[Methanomethylicaceae_genus == "g__Methanosuratincola", ]
Methanosuratincola_species <- sapply(Methanosuratincola$classification, function(x) strsplit(x, ";")[[1]][7])

# ----- Class: Nitrososphaeria_A -----
Nitrososphaeria_A <- gtdbtk.ar53.summary[gtdbtk.ar53.summary_class == "c__Nitrososphaeria_A", ]
Nitrososphaeria_A_family <- sapply(Nitrososphaeria_A$classification, function(x) strsplit(x, ";")[[1]][5])

# ... (Caldarchaeaceae, HR02, Wolframiiraptoraceae and their genera/species)
# The same pattern continues: look at counts → decide whether to keep all
# or go one level deeper.

# ----- Class: Thermoprotei -----
Thermoprotei <- gtdbtk.ar53.summary[gtdbtk.ar53.summary_class == "c__Thermoprotei", ]
Thermoprotei_order <- sapply(Thermoprotei$classification, function(x) strsplit(x, ";")[[1]][4])
# ... continue the same hierarchical inspection

# ----- Class: Bathyarchaeia -----
Bathyarchaeia <- gtdbtk.ar53.summary[gtdbtk.ar53.summary_class == "c__Bathyarchaeia", ]
Bathyarchaeia_order <- sapply(Bathyarchaeia$classification, function(x) strsplit(x, ";")[[1]][4])
# ... many orders (EX4484-135, B25, B24, RBG-16-48-13, TCS64, etc.)
# Each large order is further inspected at family → genus → species

# ----- Class: Nitrososphaeria -----
Nitrososphaeria <- gtdbtk.ar53.summary[gtdbtk.ar53.summary_class == "c__Nitrososphaeria", ]
Nitrososphaeria_order <- sapply(Nitrososphaeria$classification, function(x) strsplit(x, ";")[[1]][4])
# ... Conexivisphaerales and Nitrososphaerales further broken down

# After finishing all the above inspections, the decided numbers
# (how many genomes to keep from each terminal lineage) are written
# into sampling.xlsx (sheet 5 in this case).

##############################
# Stage 3: Execution phase
# Read the pre-decided sampling table and actually sample the genomes
##############################

# Pre-compute taxonomy vectors for fast matching
class_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][3])
order_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][4])
family_gtdbtk  <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][5])
genus_gtdbtk   <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][6])
species_gtdbtk <- sapply(gtdbtk.ar53.summary$classification, function(x) strsplit(x, ";")[[1]][7])

library(xlsx)
sampling <- read.xlsx("sampling.xlsx", 5, header = FALSE)
# Columns: class | order | family | genus | species | n_retain

# Perform the actual sampling according to the decisions in sampling.xlsx
selected <- unlist(sapply(1:nrow(sampling), function(x) {
  print(x)   # progress indicator
  
  n_levels <- sum(!is.na(sampling[x, 1:5]))
  
  if (n_levels == 1) {
    pool <- gtdbtk.ar53.summary$user_genome[class_gtdbtk == sampling[x, 1]]
  } else if (n_levels == 2) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == sampling[x, 1] & order_gtdbtk == sampling[x, 2]
    ]
  } else if (n_levels == 3) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == sampling[x, 1] & order_gtdbtk == sampling[x, 2] &
      family_gtdbtk == sampling[x, 3]
    ]
  } else if (n_levels == 4) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == sampling[x, 1] & order_gtdbtk == sampling[x, 2] &
      family_gtdbtk == sampling[x, 3] & genus_gtdbtk == sampling[x, 4]
    ]
  } else if (n_levels == 5) {
    pool <- gtdbtk.ar53.summary$user_genome[
      class_gtdbtk == sampling[x, 1] & order_gtdbtk == sampling[x, 2] &
      family_gtdbtk == sampling[x, 3] & genus_gtdbtk == sampling[x, 4] &
      species_gtdbtk == sampling[x, 5]
    ]
  }
  
  # Sample the pre-decided number (or take all if fewer are available)
  n_keep <- sampling[x, 6]
  if (length(pool) <= n_keep) {
    return(pool)
  } else {
    return(sample(pool, n_keep))
  }
}))

# Copy the selected genome files to the final directory
file.copy(
  paste0("/public/home/bdpguest/zhuruixin/dRep/Thermoproteota/dereplicated_genomes/",
         selected, ".fna"),
  "/public/home/bdpguest/zhuruixin/genome_all/Thermoproteota_MAGs_selected_167/"
)