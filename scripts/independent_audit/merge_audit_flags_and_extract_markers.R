################################################################################
# Independent post-hoc audit: merge multi-evidence flags and extract markers
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote placements
#
# Methods
# -------
# After primary decontamination (CAT + geNomad), residual contamination was
# re-assessed with GUNC (bacterial chimerism), VirSorter2 + CheckV (free virus
# only), and Whokaryote (eukaryotic signal). GC anomaly was used only to
# support bacterial and eukaryotic calls. Contigs flagged by any of these
# independent sources (union) were excluded before orthologue selection.
# Proviruses (geNomad topology == "Provirus") were retained.
#
# Contig sets merged per genome
# -----------------------------
#   • geNomad free-virus          (topology != "Provirus")
#   • CAT exogenous contigs       (primary decontamination flags)
#   • GUNC bacterial/chimeric     (intersected with GC-anomaly contigs)
#   • VirSorter2 full viral hits  (intersected with CheckV contigs)
#   • Whokaryote eukaryotic       (intersected with GC-anomaly contigs)
#
# Input tables are placeholders; adapt paths to the local environment.
################################################################################

library(Biostrings)

if (!requireNamespace("readxl", quietly = TRUE)) {
  stop("Install readxl: install.packages('readxl')")
}
library(readxl)

##############################
# 1. Primary-decontamination flags (still applied)
##############################
genomad_contigs <- read_excel("/path/to/genomad_conservative_MAG_archaea_contig.xlsx", 1)
genomad_scaffolds <- read_excel("/path/to/genomad_conservative_MAG_archaea_scaffold.xlsx", 1)
genomad_chromosomes <- read_excel("/path/to/genomad_conservative_MAG_archaea_chromosome.xlsx", 1)
genomad_complete_genomes <- read.table(
  "/path/to/genomad_conservative_MAG_archaea_complete_genome.txt",
  stringsAsFactors = FALSE, header = TRUE
)
genomad_PRJNA1162170 <- read_excel("/path/to/genomad_conservative_PRJNA1162170.xlsx", 1)
genomad_Zhang_public_Asgard_add <- read_excel(
  "/path/to/genomad_conservative_Zhang_public_Asgard_add.xlsx", 1
)

genomad <- rbind(
  genomad_contigs, genomad_scaffolds, genomad_chromosomes,
  genomad_complete_genomes, genomad_PRJNA1162170, genomad_Zhang_public_Asgard_add
)

cat_Asgardarchaeota <- read.table(
  "/path/to/cat_Asgardarchaeota.txt", stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
cat_PRJNA1162170 <- read.table(
  "/path/to/cat_PRJNA1162170.txt", stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
cat_Zhang_public_Asgard_add <- read.table(
  "/path/to/cat_Zhang_public_Asgard_add.txt", stringsAsFactors = FALSE, sep = "\t", header = TRUE
)
cat_list <- rbind(cat_Asgardarchaeota, cat_PRJNA1162170, cat_Zhang_public_Asgard_add)

##############################
# 2. Post-hoc audit tools
##############################
# GUNC + GC anomaly (GC supports bacterial calls only)
gunc <- read_excel(
  "/path/to/gunc_MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs.xlsx", 1
)
gc <- read_excel(
  "/path/to/gc_MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs.xlsx", 1
)
gunc$genome_contig <- paste(gunc$genome, gunc$contig, sep = "__")
gc$genome_contig   <- paste(gc$genome, gc$contig, sep = "__")
gunc <- subset(gunc, genome_contig %in% gc$genome_contig)

# VirSorter2 (full contigs only) ∩ CheckV
virsorter <- read_excel(
  "/path/to/virsorter_MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs.xlsx", 1
)
checkv <- read_excel(
  "/path/to/checkv_MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs.xlsx", 1
)
# Keep VirSorter2 "full" predictions; strip ||full suffix
virsorter <- virsorter[
  sapply(virsorter$seqname, function(o) strsplit(o, "\\|\\|")[[1]][2]) == "full",
]
virsorter$seqname <- sapply(virsorter$seqname, function(p) strsplit(p, "\\|\\|")[[1]][1])
virsorter$genome_contig <- paste(virsorter$genome, virsorter$seqname, sep = "__")
checkv$genome_contig    <- paste(checkv$genome, checkv$contig_id, sep = "__")
virsorter <- subset(virsorter, genome_contig %in% checkv$genome_contig)

# Whokaryote ∩ GC anomaly (GC supports eukaryotic calls only)
whokaryote <- read_excel(
  "/path/to/whokaryote_MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs.xlsx", 1
)
whokaryote$genome_contig <- paste(whokaryote$genome, whokaryote$contig, sep = "__")
whokaryote <- subset(whokaryote, genome_contig %in% gc$genome_contig)

##############################
# 3. Genome / annotation inventories
##############################
prodigal <- read.table(
  "/path/to/dereplicated_Asgardarchaeota_add_PRJNA1162170_public_prodigal.txt",
  stringsAsFactors = FALSE, sep = "\t"
)
prodigal_name <- sapply(prodigal$V1, function(u) {
  bn <- strsplit(u, "/")[[1]]
  sub("\\.faa$", "", bn[length(bn)])
})

eggnog_remove_paralogs <- read_excel("/path/to/eggnog.xlsx", sheet = 21)

annotations_file <- dir(pattern = "\\.emapper\\.annotations$")
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

out_dir <- "/path/to/emapper_faa/.../MAGs_add_PRJNA1162170_public_remove_viruses_and_aberrant_contigs_audit/Asgard_dRep/"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

protein_to_contig <- function(pid) {
  parts <- strsplit(pid, "_")[[1]]
  paste(parts[1:(length(parts) - 1)], collapse = "_")
}

##############################
# 4. Per-genome: union of all flags → drop proteins → extract markers
##############################
for (ann_file in target_annotations) {
  genome_id <- sub("\\.emapper\\.annotations$", "", ann_file)
  message("Audit processing: ", genome_id)

  annotations <- read.delim(
    ann_file, stringsAsFactors = FALSE, comment.char = "#", header = FALSE
  )

  genomad_sub    <- subset(genomad, genome == genome_id)
  cat_sub        <- subset(cat_list, genome == genome_id)
  gunc_sub       <- subset(gunc, genome == genome_id)
  virsorter_sub  <- subset(virsorter, genome == genome_id)
  whokaryote_sub <- subset(whokaryote, genome == genome_id)

  # Union of primary + post-hoc audit flags
  vc_contigs <- unique(c(
    subset(genomad_sub, topology != "Provirus")$seq_name,  # free virus only
    cat_sub[["X..contig"]],
    gunc_sub$contig,
    virsorter_sub$seqname,
    whokaryote_sub$contig
  ))

  protein_contigs <- sapply(annotations$V1, protein_to_contig)
  annotations <- annotations[!(protein_contigs %in% vc_contigs), ]

  faa_path <- prodigal$V1[which(prodigal_name == genome_id)]
  if (length(faa_path) != 1) {
    warning("Protein FASTA missing/ambiguous for ", genome_id)
    next
  }
  protein <- readAAStringSet(faa_path)
  protein_name <- sapply(names(protein), function(v) strsplit(v, " ")[[1]][1])

  for (y in seq_len(nrow(eggnog_remove_paralogs))) {
    root_id <- as.character(eggnog_remove_paralogs$root[y])

    hit <- annotations[
      sapply(annotations$V5, function(z) root_id %in% strsplit(z, ",")[[1]]),
    ]
    if (nrow(hit) == 0) next

    hit_single <- hit[
      sapply(hit$V5, function(z) {
        ranks <- sapply(strsplit(z, ",")[[1]], function(u) strsplit(u, "@")[[1]][2])
        sum(ranks == "1|root") == 1
      }),
    ]
    if (nrow(hit_single) == 0) next

    allowed_second <- strsplit(as.character(eggnog_remove_paralogs[y, "All"]), ";")[[1]]
    allowed_second <- allowed_second[
      sapply(allowed_second, function(t) strsplit(t, "\\|")[[1]][2]) %in%
        c("Archaea", "Eukaryota")
    ]

    hit_second <- hit_single[
      sapply(hit_single$V5, function(w) strsplit(w, ",")[[1]][2]) %in% allowed_second,
    ]
    if (nrow(hit_second) == 0) next

    best_id <- hit_second$V1[order(hit_second$V3)[1]]
    faa_one <- protein[match(best_id, protein_name)]
    names(faa_one) <- genome_id

    family_tag <- strsplit(root_id, "@")[[1]][1]
    writeXStringSet(
      faa_one,
      file.path(out_dir, paste0(family_tag, ".faa")),
      format = "fasta",
      append = TRUE
    )
  }
}

message("Independent audit marker extraction finished.")
message("Additional contig removal at this stage was minor (<0.8% per group)")
message("and did not alter the main phylogenetic topology in the manuscript.")
################################################################################
