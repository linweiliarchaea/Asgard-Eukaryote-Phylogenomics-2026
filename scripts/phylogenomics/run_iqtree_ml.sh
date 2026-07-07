#!/bin/bash
# ============================================================
# Script: run_iqtree_ml.sh (EXAMPLE TEMPLATE)
# Purpose: Maximum-likelihood phylogenomic inference using IQ-TREE 3
#          under the LG+C60+F+G model with ultrafast bootstrap.
#          This follows the procedure described in Methods:
#          "Phylogenomic analyses".
# Stage: phylogenomics
# Author: Weili Lin
# Date: 2026-07-07
# Software: IQ-TREE 3
# Note: This is an EXAMPLE template only.
# ============================================================

set -euo pipefail

# ------------------ Configuration (PLEASE MODIFY) ------------------
WORK_DIR="/path/to/your/project"
SORTWARE_DIR="/path/to/your/software"
ALIGNMENT_DIR="${WORK_DIR}/data/alignments"
OUTPUT_DIR="${WORK_DIR}/results/trees"
MODEL="LG+C60+F+G"

mkdir -p "${OUTPUT_DIR}"

echo "=== [EXAMPLE] Starting IQ-TREE 3 Maximum-Likelihood analysis ==="
echo "Alignment directory : ${ALIGNMENT_DIR}"
echo "Output directory    : ${OUTPUT_DIR}"
echo "Model               : ${MODEL}"
date
echo ""

# ============================================================
# Step 1: Multiple sequence alignment (MAFFT-linsi)
# ============================================================
echo ">>> [Step 1] Running MAFFT-linsi for alignment..."
# For each single-gene marker set:

mafft-linsi --thread 6 \
	"${ALIGNMENT_DIR}/example_marker.faa" > 
    "${ALIGNMENT_DIR}/example_marker.aln"
	
echo "    (MAFFT alignment step - placeholder)"
echo ""

# ============================================================
# Step 2: Trimming ambiguously aligned regions (BMGE)
# ============================================================
echo ">>> [Step 2] Trimming alignments with BMGE (BLOSUM30 matrix)..."
# BMGE removes poorly aligned positions.

java -Xmx5000M -jar "${SORTWARE_DIR}/BMGE-1.12/BMGE.jar" \
	-i "${ALIGNMENT_DIR}/example_marker.aln" \
    -t AA -m BLOSUM30 \
	-of "${ALIGNMENT_DIR}/example_marker.trimmed.aln"


echo "    (BMGE trimming step - placeholder)"
echo ""

# ============================================================
# Step 3: Concatenation of trimmed alignments
# ============================================================
echo ">>> [Step 3] Concatenating trimmed single-gene alignments..."
# All trimmed markers are concatenated into a supermatrix.

${SORTWARE_DIR}/catfasta2phyml.pl \
	-f "${ALIGNMENT_DIR}/*.trimmed.aln" \
	--concatenate > "${ALIGNMENT_DIR}/supermatrix.faa"

echo "    (Concatenation step - placeholder)"
echo ""

# ============================================================
# Step 4: Maximum-likelihood inference with IQ-TREE 3
# ============================================================
echo ">>> [Step 4] Running IQ-TREE 3 (LG+C60+F+G + UFBoot)..."
# This is the core phylogenetic inference step.
# Model: LG+C60+F+G (site-heterogeneous mixture model)
# Bootstrap: 1000 ultrafast bootstrap replicates

${SORTWARE_DIR}/iqtree3-mpi \
	-s "${ALIGNMENT_DIR}/supermatrix.faa" \
	-st AA \
    -m ${MODEL} \
    -pre "${OUTPUT_DIR}/supermatrix" \
    -nt 96 \
    -bb 1000

echo "    (IQ-TREE 3 ML inference step - placeholder)"
echo ""

# ============================================================
# Completion
# ============================================================
echo "=== [EXAMPLE] IQ-TREE 3 Maximum-Likelihood analysis template completed ==="
echo ""
echo "Key parameters used in the study:"
echo "  - Model: LG+C60+F+G"
echo "  - Bootstrap: 1000 ultrafast bootstrap (UFBoot)"
echo "  - Software: IQ-TREE 3"
echo ""
echo "Note: This is an EXAMPLE template. All commands are placeholders."
echo "See Methods section: 'Phylogenomic analyses' for full details."
date