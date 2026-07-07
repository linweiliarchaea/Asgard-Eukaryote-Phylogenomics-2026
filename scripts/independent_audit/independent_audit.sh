#!/bin/bash
# ============================================================
# Script: independent_audit.sh (EXAMPLE TEMPLATE)
# Purpose: Independent post-hoc contamination audit on the 
#          already decontaminated genome collection (GS5-clean).
#          This is a robustness verification step to confirm that
#          residual contamination does not affect the main conclusions.
#          This follows the procedure described in Methods:
#          "Independent post hoc contamination audit".
# Stage: robustness
# Author: Weili Lin
# Date: 2026-07-07
# Note: This is an EXAMPLE template only.
# ============================================================

set -euo pipefail

# ------------------ Configuration (PLEASE MODIFY) ------------------
WORK_DIR="/path/to/your/project"
SORTWARE_DIR="/path/to/your/software"
INPUT_GENOMES="${WORK_DIR}/data/genomes/GS5_clean"           # Already decontaminated genomes
OUTPUT_DIR="${WORK_DIR}/results/independent_audit"
LOG_DIR="${OUTPUT_DIR}/logs"

mkdir -p "${OUTPUT_DIR}/gunc" \
         "${OUTPUT_DIR}/virsorter2" \
         "${OUTPUT_DIR}/checkv" \
         "${OUTPUT_DIR}/whokaryote" \
         "${OUTPUT_DIR}/gc_anomaly" \
         "${LOG_DIR}"

echo "=== [EXAMPLE] Starting Independent Post-hoc Contamination Audit ==="
echo "Input genomes (GS5-clean) : ${INPUT_GENOMES}"
echo "Output directory          : ${OUTPUT_DIR}"
date
echo ""

# ============================================================
# GUNC - Detect prokaryotic chimerism and taxonomic inconsistency
# ============================================================
echo ">>> Running GUNC for chimerism and taxonomic inconsistency detection..."
# GUNC is used to detect potential bacterial contamination and chimerism.

gunc run \
	--file_suffix .fna \
	--threads 96 \
	--input_dir "${INPUT_GENOMES}" \
    -r ${SORTWARE_DIR}/gunc_db_gtdb214_2/gunc_db_gtdb214.dmnd \
	--out_dir --out_dir "${OUTPUT_DIR}/gunc" \
    --contig_taxonomy_output


echo "    (GUNC step - placeholder)"
echo ""

# ============================================================
# VirSorter2 + CheckV - Detect free viral sequences
# ============================================================
echo ">>> Running VirSorter2 + CheckV for free viral detection..."
# Only free virus (not provirus) is considered for removal.
# Proviral sequences are retained by default.

virsorter run \
	-w "${OUTPUT_DIR}/virsorter2" \
    -i "${INPUT_GENOMES}" \
	--include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae \
	-j 18 all \
	--db-dir ${SORTWARE_DIR}/VirSorter2-master/db

checkv end_to_end \
	"${INPUT_GENOMES}" \
	"${OUTPUT_DIR}/checkv" \
	-t 4

echo "    (VirSorter2 + CheckV step - placeholder)"
echo ""

# ============================================================
# Whokaryote - Detect eukaryotic contigs
# ============================================================
echo ">>> Running Whokaryote for eukaryotic sequence detection..."
# Used to identify potential eukaryotic contamination.

whokaryote.py \
	--contigs "${INPUT_GENOMES}" \
    --outdir "${OUTPUT_DIR}/whokaryote" \
	--model S

echo "    (Whokaryote step - placeholder)"
echo ""

