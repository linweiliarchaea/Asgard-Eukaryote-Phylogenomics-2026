#!/bin/bash
# ============================================================
# Script: run_phylobayes.sh (EXAMPLE TEMPLATE)
# Purpose: Bayesian phylogenetic inference using PhyloBayes MPI
#          under the CAT-GTR model as a sensitivity analysis.
#          This follows the procedure described in Methods:
#          "Topology testing and Bayesian inference".
# Stage: phylogenomics
# Author: Weili Lin
# Date: 2026-07-07
# Software: PhyloBayes MPI
# Note: This is an EXAMPLE template only.
# ============================================================

set -euo pipefail

# ------------------ Configuration (PLEASE MODIFY) ------------------
WORK_DIR="/path/to/your/project"
SORTWARE_DIR="/path/to/your/software"
ALIGNMENT="${WORK_DIR}/data/alignments/supermatrix.faa"
OUTPUT_DIR="${WORK_DIR}/results/phylobayes"
CHAIN_PREFIX="CAT_GTR"

mkdir -p "${OUTPUT_DIR}"

echo "=== [EXAMPLE] Starting PhyloBayes MPI analysis ==="
echo "Alignment file : ${ALIGNMENT}"
echo "Output directory: ${OUTPUT_DIR}"
echo "Model          : CAT-GTR"
echo "Number of chains: 10 (independent)"
date
echo ""

# ============================================================
# Step 1: Run 10 independent Markov chains
# ============================================================
echo ">>> [Step 1] Running 10 independent PhyloBayes chains under CAT-GTR model..."

# In the actual study, 10 independent chains were run in parallel.
# Each chain was run for a sufficient number of generations until
# topology frequencies stabilized (see Extended Data Table 5).

for i in $(seq 1 10); do
    echo "    Starting chain ${i}..."
    
    # Example command (commented out):
    mpirun -np 54 ${SORTWARE_DIR}/pb_mpi \
		-d "${ALIGNMENT}" \
		-cat -gtr \
        "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain${i}"
    
    echo "    (Chain ${i} - placeholder)"
done

echo ""

# ============================================================
# Step 2: Summarize chain behaviour and topology frequencies
# ============================================================
echo ">>> [Step 2] Summarizing topology frequencies across chains..."

# bpcomp is used to compare bipartition frequencies between chains
# and to assess convergence of the posterior distribution.

# Example command (commented out):
bpcomp -c 0.5 \
   -o "${OUTPUT_DIR}/${CHAIN_PREFIX}_bpcomp" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain1" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain2" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain3" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain4" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain5" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain6" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain7" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain8" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain9" \
   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain10"

echo "    (bpcomp summary - placeholder)"
echo ""

# ============================================================
# Completion
# ============================================================
echo "=== [EXAMPLE] PhyloBayes MPI analysis template completed ==="
echo ""
echo "See Methods section: 'Topology testing and Bayesian inference'"
echo "and Extended Data Table 5 for detailed chain-level results."
date