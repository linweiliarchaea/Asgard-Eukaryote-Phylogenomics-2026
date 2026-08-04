################################################################################
# Remove exogenous contigs and extract representative eggNOG marker proteins
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Methods mirrored by this script
# --------------------------------
# Primary decontamination combines:
#   (1) CAT-flagged candidate exogenous contigs (root / non-cellular /
#       non-Archaea ranks; "no ORFs found" already excluded upstream)
#   (2) geNomad conservative viral calls, excluding proviruses
#       (topology != "Provirus")
#
# Contigs flagged by either source are removed before orthologue selection.
# For each conserved eggNOG family, a single representative protein sequence
# is retained per genome after paralogue filtering, and written to
# per-family FASTA files used for single-protein trees and subsequent
# phylogenetic marker set (PMS) construction.
#
# Note
# ----
# Paths below are placeholders. Adapt to the local environment before running.
################################################################################

library(Biostrings)

# Prefer readxl / openxlsx over xlsx (no Java dependency)
if (!requireNamespace("readxl", quietly = TRUE)) {
  stop("Install readxl: install.packages('readxl')")
}
library(readxl)

##############################
# 1. Load geNomad virus calls
##############################
# Tables may be split by assembly level or data source; bind into one object.
genomad_contigs <- read_excel(
  "/path/to/genomad_conservative_MAG_archaea_contig.xlsx", sheet = 1
)
genomad_scaffolds <- read_excel(
  "/path/to/genomad_conservative_MAG_archaea_scaffold.xlsx", sheet = 1
)
genomad_chromosomes <- read_excel(
  "/path/to/genomad_conservative_MAG_archaea_chromosome.xlsx", sheet = 1
)
genomad_complete_genomes <- read.table(
  "/path/to/genomad_conservative_MAG_archaea_complete_genome.txt",
  stringsAsFactors = FALSE, header = TRUE
)
genomad_PRJNA1162170 <- read_excel(
  "/path/to/genomad_conservative_PRJNA1162170.xlsx", sheet = 1
)
genomad_Zhang_public_Asgard_add <- read_excel(
  "/path/to/genomad_conservative_Zhang_public_Asgard_add.xlsx", sheet = 1
)

genomad <- rbind(
  genomad_contigs,
  genomad_scaffolds,
  genomad_chromosomes,
  genomad_complete_genomes,
  genomad_PRJNA1162170,
  genomad_Zhang_public_Asgard_add
)

##############################
# 2. Load CAT-flagged contigs
##############################
cat_Asgardarchaeota <- read.table(
  "/path/to/cat_Asgardarchaeota.txt",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
cat_PRJNA1162170 <- read.table(
  "/path/to/cat_PRJNA1162170.txt",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
cat_Zhang_public_Asgard_add <- read.table(
  "/path/to/cat_Zhang_public_Asgard_add.txt",
  stringsAsFactors = FALSE, sep = "\t", header = TRUE
)

cat_list <- rbind(
  cat_Asgardarchaeota,
  cat_PRJNA1162170,
  cat_Zhang_public_Asgard_add
)

##############################
# 3. Genome / protein inventories
##############################
# Prodigal protein FASTA paths (one .faa per genome)
prodigal <- read.table(
  "/path/to/dereplicated_Asgardarchaeota_add_PRJNA1162170_public_prodigal.txt",
  stringsAsFactors = FALSE, sep = "\t"
)
prodigal_name <- sapply(prodigal$V1, function(u) {
  bn <- strsplit(u, "/")[[1]]
  sub("\\.faa$", "", bn[length(bn)])
})

# eggNOG families retained after paralogue screening (decision table)
eggnog_remove_paralogs <- read_excel(
  "/path/to/eggnog.xlsx", sheet = 21
)

# eggNOG-mapper annotation files present in the working directory
annotations_file <- dir(pattern = "\\.emapper\\.annotations$")

# Genomes excluded from this run (isolates / special cases)
exclude_annotations <- c(
  "GCF_008000775.2_ASM800077v2_genomic.emapper.annotations",
  "GCA_025839675.1_ASM2583967v1_genomic.emapper.annotations",
  "Heimdallarchaeota_archaeon_HC1.emapper.annotations",
  "Heimdallarchaeota_archaeon_SC1.emapper.annotations"
)

target_annotations <- setdiff(
  intersect(annotations_file, paste0(prodigal_name, ".emapper.annotations")),
  exclude_annotations
)

# Output directory for cleaned per-family protein FASTAs
out_dir <- "/path/to/emapper_faa/eggNOG_0.8_remove_paralogs/screen_cultured_MAGs/MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs/Asgard_dRep/"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

##############################
# 4. Per-genome decontamination + marker extraction
##############################
# Helper: map protein ID → contig ID
# eggNOG-mapper query IDs are typically <contig>_<orf_index>
protein_to_contig <- function(pid) {
  parts <- strsplit(pid, "_")[[1]]
  paste(parts[1:(length(parts) - 1)], collapse = "_")
}

for (ann_file in target_annotations) {
  genome_id <- sub("\\.emapper\\.annotations$", "", ann_file)
  message("Processing genome: ", genome_id)

  annotations <- read.delim(
    ann_file,
    stringsAsFactors = FALSE,
    comment.char = "#",
    header = FALSE
  )

  # --- Contigs to remove: free virus (geNomad) ∪ CAT exogenous -------------
  genomad_sub <- subset(genomad, genome == genome_id)
  cat_sub     <- subset(cat_list, genome == genome_id)

  # Exclude integrated proviruses; retain only free-virus calls
  viral_contigs <- subset(genomad_sub, topology != "Provirus")$seq_name
  cat_contigs   <- cat_sub[["X..contig"]]
  if (is.null(cat_contigs)) {
    # fallback if column name differs
    cat_contigs <- cat_sub$contig
  }
  vc_contigs <- union(viral_contigs, cat_contigs)

  # Drop proteins encoded on flagged contigs
  protein_contigs <- sapply(annotations$V1, protein_to_contig)
  annotations <- annotations[!(protein_contigs %in% vc_contigs), ]

  # Load protein sequences for this genome
  faa_path <- prodigal$V1[which(prodigal_name == genome_id)]
  if (length(faa_path) != 1) {
    warning("Protein FASTA not found or not unique for ", genome_id)
    next
  }
  protein <- readAAStringSet(faa_path)
  protein_name <- sapply(names(protein), function(v) strsplit(v, " ")[[1]][1])

  # --- For each eggNOG family, keep one representative sequence ------------
  for (y in seq_len(nrow(eggnog_remove_paralogs))) {
    root_id <- as.character(eggnog_remove_paralogs$root[y])

    # Proteins annotated with this eggNOG root family
    hit <- annotations[
      sapply(annotations$V5, function(z) root_id %in% strsplit(z, ",")[[1]]),
    ]
    if (nrow(hit) == 0) next

    # Prefer annotations with a single root-level assignment
    hit_single <- hit[
      sapply(hit$V5, function(z) {
        ranks <- sapply(strsplit(z, ",")[[1]], function(u) strsplit(u, "@")[[1]][2])
        sum(ranks == "1|root") == 1
      }),
    ]
    if (nrow(hit_single) == 0) next

    # Restrict to Archaea / Eukaryota secondary ranks listed for this family
    allowed_second <- strsplit(as.character(eggnog_remove_paralogs[y, "All"]), ";")[[1]]
    allowed_second <- allowed_second[
      sapply(allowed_second, function(t) strsplit(t, "\\|")[[1]][2]) %in%
        c("Archaea", "Eukaryota")
    ]

    hit_second <- hit_single[
      sapply(hit_single$V5, function(w) strsplit(w, ",")[[1]][2]) %in% allowed_second,
    ]
    if (nrow(hit_second) == 0) next

    # Best hit by score (column V3); write one sequence per genome per family
    best_id <- hit_second$V1[order(hit_second$V3)[1]]
    faa_one <- protein[match(best_id, protein_name)]
    names(faa_one) <- genome_id

    family_tag <- strsplit(root_id, "@")[[1]][1]
    out_faa <- file.path(out_dir, paste0(family_tag, ".faa"))
    writeXStringSet(faa_one, out_faa, format = "fasta", append = TRUE)
  }
}

message("Finished decontamination-aware marker extraction.")
################################################################################
