#!/bin/bash
# ============================================================
# Script: run_decontamination.sh (EXAMPLE TEMPLATE)
# Purpose: Identify candidate exogenous sequences in archaeal MAGs 
#          and generate decontaminated (clean) genome collections.
#          This script follows the procedure described in the Methods section:
#          "Identification of candidate exogenous sequences".
# Tools: CAT v6.0 + geNomad v1.8.0
# Stage: decontamination (Main decontamination procedure)
# Author: Weili Lin
# Date: 2026-07-07
# Note: This is an EXAMPLE template only. All commands are placeholders.
# ============================================================

set -euo pipefail

# ------------------ Configuration (PLEASE MODIFY) ------------------
WORK_DIR="/path/to/your/project"
SORTWARE_DIR="/path/to/your/software"
RAW_GENOMES_DIR="${WORK_DIR}/data/genomes/raw_MAGs"          # Input: original MAGs
OUTPUT_DIR="${WORK_DIR}/results/decontamination"             # Output: decontaminated genomes

mkdir -p "${OUTPUT_DIR}/cat_classification" \
         "${OUTPUT_DIR}/genomad" \
         "${OUTPUT_DIR}/logs"

echo "=== [EXAMPLE] Starting main decontamination workflow ==="
echo "Input raw genomes : ${RAW_GENOMES_DIR}"
date
echo ""

# ============================================================
# Contig-level taxonomic classification using CAT v6.0
# ============================================================
echo ">>> Running CAT classification (sensitive mode)..."
CAT_pack contigs \
	-c "${RAW_GENOMES_DIR}/example_genome.fna" \
	-d "${SORTWARE_DIR}/20240422_CAT_nr/db" \
	-t "${SORTWARE_DIR}/20240422_CAT_nr/tax" \ 
    -o "${OUTPUT_DIR}/cat_classification/CAT_pack/contigs/example_genome" \
    --sensitive -n 18


CAT_pack add_names \
	-i "${OUTPUT_DIR}/cat_classification/CAT_pack/contigs/example_genome.contig2classification.txt" \
	-o "${OUTPUT_DIR}/cat_classification/CAT_pack/add_names/example_genome.official_names.txt" \ 
    -t "${SORTWARE_DIR}/20240422_CAT_nr/tax" \
	--only_official


CAT_pack summarise \
	-c "${RAW_GENOMES_DIR}/example_genome.fna" \
    -i "${OUTPUT_DIR}/cat_classification/CAT_pack/contigs/example_genome.contig2classification.txt" \
    -o "${OUTPUT_DIR}/cat_classification/CAT_pack/add_names/example_genome.summary.txt"


echo "    (CAT classification step - placeholder)"
echo ""

# ============================================================
# Independent viral detection using geNomad v1.8.0
# ============================================================
echo ">>> Running geNomad for viral sequence detection (conservative mode)..."
genomad end-to-end \
	--threads 4 \
	--conservative \
	"${RAW_GENOMES_DIR}/example_genome.fna" \
    "${OUTPUT_DIR}/genomad" \
    "${SORTWARE_DIR}/genomad_db"


echo "    (geNomad viral detection step - placeholder)"
echo ""