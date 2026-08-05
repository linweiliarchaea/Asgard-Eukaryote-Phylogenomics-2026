#!/usr/bin/env Rscript
# ============================================================
# Script: count_eukaryote_like_proteins_from_CAT.R
# Purpose: Count the number of proteins classified as Eukaryota 
#          (NCBI taxonomy: 1;131567;2759) on contigs that were 
#          previously annotated as bacterial, eukaryotic, viral 
#          or chimeric by CAT.
# ============================================================

# ---------------------------
# 1. Helper function: safely read ORF2LCA file
# ---------------------------
read_ORF2LCA <- function(genome_id) {
  possible_paths <- c(
    paste0("/share/home/u08118/LWL/tj08118/ToL/CAT_pack/contigs/Asgardarchaeota/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/tj08118/ToL/CAT_pack/contigs/Thermoproteota/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/PRJNA1162170/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/Zhang_public_Asgard_add/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/PRJNA629047/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/PRJNA628571/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/41586_2021_3494_MOESM3_ESM_NCBI/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/PRJNA680430/", genome_id, ".ORF2LCA.txt"),
    paste0("/share/home/u08118/LWL/CAT_pack/contigs/MG-RAST/", genome_id, ".ORF2LCA.txt")
  )
  
  for (path in possible_paths) {
    if (file.exists(path)) {
      return(read.delim(path, stringsAsFactors = FALSE, sep = "\t", header = TRUE))
    }
  }
  
  warning(paste("ORF2LCA file not found for genome:", genome_id))
  return(NULL)
}

# ---------------------------
# 2. Core function: count Eukaryota proteins on specific contigs
# ---------------------------
count_eukaryotic_proteins <- function(genome_id, target_contigs) {
  ORF2LCA <- read_ORF2LCA(genome_id)
  if (is.null(ORF2LCA) || nrow(ORF2LCA) == 0) {
    return(0)
  }
  
  # Extract contig ID from ORF name (remove the last _ORF part)
  ORF2LCA$contig <- sapply(ORF2LCA$X..ORF, function(y) {
    parts <- strsplit(y, "_")[[1]]
    paste(parts[1:(length(parts)-1)], collapse = "_")
  })
  
  # Keep only ORFs located on the target contigs
  idx <- which(ORF2LCA$contig %in% target_contigs)
  if (length(idx) == 0) {
    return(0)
  }
  
  # Extract the first three ranks of the lineage
  lineages <- sapply(ORF2LCA$lineage[idx], function(z) {
    paste(strsplit(z, ";")[[1]][1:3], collapse = ";")
  })
  
  # Count proteins classified as Eukaryota (1;131567;2759)
  sum(lineages == "1;131567;2759", na.rm = TRUE)
}

# ---------------------------
# 3. Main analysis for different contig categories
# ---------------------------

# --- 3.1 Bacterial contigs ---
cat_bacteria_eukaryotic_protein <- sapply(unique(cat_bacteria$genome), function(x) {
  contigs <- subset(cat_bacteria, genome == x)$X..contig
  count_eukaryotic_proteins(x, contigs)
})

# --- 3.2 Eukaryotic contigs ---
cat_eukaryota_eukaryotic_protein <- sapply(unique(cat_eukaryota$genome), function(x) {
  contigs <- subset(cat_eukaryota, genome == x)$X..contig
  count_eukaryotic_proteins(x, contigs)
})

# --- 3.3 Viral contigs ---
# Note: here we use union of cat_viruses and genomad_Asgardarchaeota
viral_genomes <- union(cat_viruses$genome, genomad_Asgardarchaeota$genome)
cat_viruses_eukaryotic_protein <- sapply(viral_genomes, function(x) {
  # Adjust the subset according to your actual data structure
  contigs <- subset(cat_Asgardarchaeota, genome == x)$X..contig   # or the correct virus table
  count_eukaryotic_proteins(x, contigs)
})

# --- 3.4 Chimeric contigs ---
cat_chimeric_eukaryotic_protein <- sapply(unique(cat_chimeric$genome), function(x) {
  contigs <- subset(cat_chimeric, genome == x)$X..contig
  count_eukaryotic_proteins(x, contigs)
})

# ---------------------------
# 4. Optional: save results
# ---------------------------
# results <- data.frame(
#   genome = names(cat_bacteria_eukaryotic_protein),
#   bacteria_euk_proteins = cat_bacteria_eukaryotic_protein,
#   # add other categories...
# )
# write.table(results, file = "eukaryote_like_protein_counts.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

message("Analysis completed.")