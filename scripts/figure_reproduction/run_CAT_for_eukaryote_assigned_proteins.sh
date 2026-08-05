#!/bin/bash
# ============================================================
# Script: run_CAT_contigs.sh
# Purpose: Run CAT in contigs mode to generate ORF2LCA.txt
#          files used for identifying eukaryote-assigned proteins
#          on candidate exogenous contigs.
# ============================================================

set -euo pipefail

# ----- User-configurable parameters -----
genome_fna="$1"                  # input genome fasta
base=$(basename "${genome_fna}" .fna)
base=${base%.fa}
base=${base%.fasta}

CAT_DB="/path/to/CAT_database"   # CAT database directory
CAT_TAX="/path/to/CAT_taxonomy"  # CAT taxonomy directory
OUTPUT_DIR="/path/to/output"
THREADS_CAT=16

mkdir -p "${OUTPUT_DIR}/cat_classification/contigs"
mkdir -p "${OUTPUT_DIR}/logs"

# ----- Run CAT -----
CAT_pack contigs \
    -c "${genome_fna}" \
    -d "${CAT_DB}" \
    -t "${CAT_TAX}" \
    -o "${OUTPUT_DIR}/cat_classification/contigs/${base}" \
    --sensitive \
    -n "${THREADS_CAT}" \
    > "${OUTPUT_DIR}/logs/${base}.CAT_contigs.log" 2>&1

echo "Finished CAT classification for ${base}"