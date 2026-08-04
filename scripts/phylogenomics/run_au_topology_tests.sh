#!/bin/bash
# ============================================================
# Script : run_au_topology_tests.sh (EXAMPLE TEMPLATE)
# Purpose: Approximately Unbiased (AU) tests of competing
#          eukaryotic-placement topologies in IQ-TREE 3.
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote
# placements
#
# Methods mirrored by this script
# --------------------------------
# "Topology testing and Bayesian inference"
#
# Competing topologies (e.g. eukaryotes sister to Korarchaeia,
# Njordarchaeia, other Asgard subgroups, or to a monophyletic
# TACK–Asgard clade) were evaluated with the approximately
# unbiased (AU) test under the same site-heterogeneous model
# used for primary ML inference (LG+C60+F+G). Constraint trees
# were supplied as a multiphyly list (-z); site-wise log-
# likelihoods were resampled (-zb) and AU / other topology-test
# statistics were reported (-au -zw).
#
# Tools  : IQ-TREE 3
# Stage  : Phylogenomics (topology tests)
# Note   : EXAMPLE template. Paths are placeholders.
# ============================================================

set -euo pipefail

# ------------------ Configuration (MODIFY AS NEEDED) ------------------
WORK_DIR="/path/to/your/project"
SOFTWARE_DIR="/path/to/your/software"

# Supermatrix for the GS × PMS combination under test
# (typically a full-control clean + balanced collection)
ALIGNMENT="${WORK_DIR}/data/alignments/GS-Present-B-clean_PMS-MediumMAG.faa"

# Multiphyly file of constraint topologies to compare
# (one Newick tree per line; same taxon set as the alignment)
TREE_LIST="${WORK_DIR}/results/trees/AU_tests/all_constraint_topologies.treels"

OUTPUT_DIR="${WORK_DIR}/results/trees/AU_tests"
MODEL="LG+C60+F+G"
REPS=10000          # RELL replicates for AU (-zb)
THREADS=64

mkdir -p "${OUTPUT_DIR}"

echo "=== Approximately Unbiased (AU) topology tests ==="
echo "Alignment     : ${ALIGNMENT}"
echo "Tree list (-z): ${TREE_LIST}"
echo "Model         : ${MODEL}"
echo "RELL replicates: ${REPS}"
date
echo ""

# ============================================================
# AU tests in IQ-TREE 3
# ============================================================
# -z   : evaluate user trees (constraint / candidate topologies)
# -zb  : number of RELL bootstrap replicates
# -zw  : print weighted topology-test statistics
# -au  : compute the approximately unbiased test
# -n 0 : optional; skip tree search and only score supplied trees
#        (use when -z trees are complete and no ML search is needed)
#
echo ">>> Running AU tests..."
iqtree3 \
  -s "${ALIGNMENT}" \
  -st AA \
  -z "${TREE_LIST}" \
  -zb "${REPS}" \
  -zw \
  -au \
  -n 0 \
  -m "${MODEL}" \
  -nt "${THREADS}" \
  -pre "${OUTPUT_DIR}/AU_test_results"

echo ""
echo "=== AU topology tests finished ==="
date
echo "Results prefix: ${OUTPUT_DIR}/AU_test_results"
echo "Inspect *.iqtree for AU / bp-RELL / KH / SH / ELW statistics."
echo "In the study, topologies placing eukaryotes as sister to a"
echo "monophyletic TACK–Asgard clade were supported under full"
echo "control of contamination and sampling imbalance; alternative"
echo "placements (e.g. sister to Korarchaeia or Njordarchaeia) were"
echo "rejected or not significantly supported depending on the dataset."
echo "See Methods: 'Topology testing and Bayesian inference'."
