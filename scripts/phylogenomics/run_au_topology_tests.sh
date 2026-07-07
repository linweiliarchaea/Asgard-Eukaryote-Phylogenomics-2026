#!/bin/bash
# ============================================================
# Script: run_au_topology_tests.sh (EXAMPLE TEMPLATE)
# Purpose: Approximately Unbiased (AU) topology tests to evaluate
#          competing hypotheses of eukaryotic placement.
#          This follows the procedure described in Methods:
#          "Topology testing and Bayesian inference".
# Stage: phylogenomics
# Author: Weili Lin
# Date: 2026-07-07
# Software: IQ-TREE 3
# Note: This is an EXAMPLE template only.
# ============================================================

set -euo pipefail

# ------------------ Configuration (PLEASE MODIFY) ------------------
WORK_DIR="/path/to/your/project"
ALIGNMENT="${WORK_DIR}/data/alignments/supermatrix.faa"
TREE_DIR="${WORK_DIR}/results/trees"
OUTPUT_DIR="${WORK_DIR}/results/au_tests"

mkdir -p "${OUTPUT_DIR}"

echo "=== [EXAMPLE] Starting AU Topology Tests ==="
echo "Alignment file : ${ALIGNMENT}"
echo "Output directory: ${OUTPUT_DIR}"
date
echo ""

# ============================================================
#  Run AU tests in IQ-TREE 3
# ============================================================
echo ">>> Running Approximately Unbiased (AU) tests..."

# IQ-TREE command structure for AU test:
# Example command (commented out):
iqtree3 \
  -s "${ALIGNMENT}" -st AA \
  -z "${TREE_DIR}/all_constraint_topologies.treels" \
  -zb 10000 -n 0 \
  -zw -au -m LG+C60+F+G4 -nt 64 \
  -pre "${OUTPUT_DIR}/AU_test_results"


echo "    (AU test execution - placeholder)"
echo ""

