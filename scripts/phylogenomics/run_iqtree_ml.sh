#!/bin/bash
# ============================================================
# Script : run_iqtree_ml.sh (EXAMPLE TEMPLATE)
# Purpose: Maximum-likelihood phylogenomic inference with
#          IQ-TREE 3 under LG+C60+F+G and ultrafast bootstrap.
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote
# placements
#
# Methods mirrored by this script
# --------------------------------
# "Phylogenomic analyses"
#
# For each combination of genome collection (GS) and phylogenetic
# marker set (PMS), single-gene protein alignments were built with
# MAFFT-linsi, trimmed with BMGE (BLOSUM30), concatenated into a
# supermatrix, and analysed in IQ-TREE 3 under LG+C60+F+G. Node
# support was estimated from 1,000 ultrafast bootstrap replicates.
# The factorial design (all GS × all PMS) assesses topological
# stability across contamination control and sampling balance.
#
# Genome collections (examples)
#   GS-Zhang2025 / GS-Zhang2025-B  (raw | clean)
#   GS-Liu2021   / GS-Liu2021-B    (raw | clean)
#   GS-Present-B                   (raw | clean | ultra-clean)
#
# Marker sets
#   PMS-Isolate | PMS-HighMAG1 | PMS-HighMAG2 | PMS-MediumMAG
#
# Tools  : MAFFT, BMGE, catfasta2phyml (or equivalent), IQ-TREE 3
# Stage  : Phylogenomics (primary ML inference)
# Note   : EXAMPLE template. Paths and MPI settings are placeholders.
# ============================================================

set -euo pipefail

# ------------------ Configuration (MODIFY AS NEEDED) ------------------
WORK_DIR="/path/to/your/project"
SOFTWARE_DIR="/path/to/your/software"

# Example: one GS × PMS combination
GS_LABEL="GS-Present-B-clean"
PMS_LABEL="PMS-MediumMAG"

MARKER_FAA_DIR="${WORK_DIR}/data/markers/${GS_LABEL}_${PMS_LABEL}"
# Directory of single-gene FASTA files (one .faa per marker family)

ALIGNMENT_DIR="${WORK_DIR}/results/alignments/${GS_LABEL}_${PMS_LABEL}"
OUTPUT_DIR="${WORK_DIR}/results/trees/maximum_likelihood"
MODEL="LG+C60+F+G"
UFBOOT=1000

THREADS_MAFFT=6
THREADS_IQTREE=48
MPI_MAP="ppr:2:node:PE=48"

mkdir -p "${ALIGNMENT_DIR}" "${OUTPUT_DIR}"

echo "=== IQ-TREE 3 maximum-likelihood analysis ==="
echo "Genome set / PMS : ${GS_LABEL} × ${PMS_LABEL}"
echo "Marker FASTAs    : ${MARKER_FAA_DIR}"
echo "Alignment dir    : ${ALIGNMENT_DIR}"
echo "Tree output dir  : ${OUTPUT_DIR}"
echo "Model            : ${MODEL}"
date
echo ""

# ============================================================
# Step 1: Multiple sequence alignment (MAFFT-linsi)
# ============================================================
echo ">>> [1/4] MAFFT-linsi (per marker)..."
shopt -s nullglob
marker_faas=("${MARKER_FAA_DIR}"/*.faa)

if [[ ${#marker_faas[@]} -eq 0 ]]; then
  echo "WARNING: No .faa files in ${MARKER_FAA_DIR}"
else
  for faa in "${marker_faas[@]}"; do
    base=$(basename "${faa}" .faa)
    echo "  → ${base}"
    mafft-linsi --thread "${THREADS_MAFFT}" \
      "${faa}" \
      > "${ALIGNMENT_DIR}/${base}.aln"
  done
fi
echo ""

# ============================================================
# Step 2: Trim ambiguously aligned regions (BMGE, BLOSUM30)
# ============================================================
echo ">>> [2/4] BMGE trimming (BLOSUM30)..."
aln_files=("${ALIGNMENT_DIR}"/*.aln)

if [[ ${#aln_files[@]} -eq 0 ]]; then
  echo "WARNING: No .aln files in ${ALIGNMENT_DIR}"
else
  for aln in "${aln_files[@]}"; do
    base=$(basename "${aln}" .aln)
    echo "  → ${base}"
    java -Xmx5G -jar "${SOFTWARE_DIR}/BMGE-1.12/BMGE.jar" \
      -i "${aln}" \
      -t AA \
      -m BLOSUM30 \
      -of "${ALIGNMENT_DIR}/${base}.trimmed.aln"
  done
fi
echo ""

# ============================================================
# Step 3: Concatenate trimmed single-gene alignments
# ============================================================
echo ">>> [3/4] Concatenating into supermatrix..."
# catfasta2phyml.pl (or an equivalent concatenator) builds the
# amino-acid supermatrix used as IQ-TREE input.
SUPERMATRIX="${ALIGNMENT_DIR}/${GS_LABEL}_${PMS_LABEL}.faa"

"${SOFTWARE_DIR}/catfasta2phyml.pl" \
  -f "${ALIGNMENT_DIR}"/*.trimmed.aln \
  --concatenate \
  > "${SUPERMATRIX}"

echo "    Supermatrix: ${SUPERMATRIX}"
echo ""

# ============================================================
# Step 4: Maximum-likelihood inference (IQ-TREE 3)
# ============================================================
echo ">>> [4/4] IQ-TREE 3 (${MODEL}, UFBoot=${UFBOOT})..."
PREFIX="${OUTPUT_DIR}/${GS_LABEL}_${PMS_LABEL}"

mpirun --bind-to core --map-by "${MPI_MAP}" \
  "${SOFTWARE_DIR}/iqtree3-mpi" \
  -s "${SUPERMATRIX}" \
  -st AA \
  -m "${MODEL}" \
  -bb "${UFBOOT}" \
  -pre "${PREFIX}" \
  -nt "${THREADS_IQTREE}"

echo "    Tree prefix: ${PREFIX}"
echo ""

# ============================================================
# Completion
# ============================================================
echo "=== IQ-TREE 3 ML analysis finished ==="
date
echo "Key settings used in the study:"
echo "  Model              : LG+C60+F+G"
echo "  Support            : 1,000 ultrafast bootstrap replicates"
echo "  Alignment          : MAFFT-linsi"
echo "  Trimming           : BMGE (BLOSUM30)"
echo "  Design             : all genome collections × all four PMSs"
echo ""
echo "Primary topology under full control of contamination and sampling"
echo "imbalance: eukaryotes sister to a monophyletic TACK–Asgard clade."
echo "See Methods: 'Phylogenomic analyses'."
