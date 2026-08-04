#!/bin/bash
# ============================================================
# Script : run_phylobayes.sh (EXAMPLE TEMPLATE)
# Purpose: Bayesian phylogenetic inference with PhyloBayes MPI
#          under CAT-GTR, used as a conservative sensitivity
#          analysis relative to primary ML inference.
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
# Bayesian inference under CAT-GTR was performed in PhyloBayes MPI
# on contamination-controlled, taxonomically balanced datasets.
# Ten independent Markov chains were run. Although full
# convergence was not achieved — reflecting the difficulty of
# resolving extremely ancient divergences under complex
# site-heterogeneous models — seven of the ten chains recovered
# topologies in which eukaryotes were placed as sister to a
# monophyletic TACK–Asgard clade, consistent with ML and AU
# results. Remaining chains placed eukaryotes deeper within
# Asgard but did not converge on any single previously proposed
# extant Asgard lineage as the immediate sister group.
#
# All chains used the same burn-in and sampling settings.
# Because convergence diagnostics indicated non-convergence,
# chain-level topologies are summarized descriptively and are
# not interpreted as posterior consensus support. Primary
# phylogenetic inference is based on contamination-controlled
# maximum-likelihood analyses and topology tests.
#
# Tools  : PhyloBayes MPI (pb_mpi, bpcomp, tracecomp)
# Stage  : Phylogenomics (Bayesian sensitivity analysis)
# Note   : EXAMPLE template. Paths and MPI settings are placeholders.
# ============================================================

set -euo pipefail

# ------------------ Configuration (MODIFY AS NEEDED) ------------------
WORK_DIR="/path/to/your/project"
SOFTWARE_DIR="/path/to/your/software"

# Supermatrix for a full-control collection (example)
ALIGNMENT="${WORK_DIR}/data/alignments/GS-Present-B-clean_PMS-MediumMAG.phy"
# PhyloBayes typically expects PHYLIP; convert from FASTA if needed

OUTPUT_DIR="${WORK_DIR}/results/trees/CAT-GTR"
CHAIN_PREFIX="CAT_GTR"
N_CHAINS=10
MPI_NP=54

mkdir -p "${OUTPUT_DIR}"

echo "=== PhyloBayes MPI (CAT-GTR) sensitivity analysis ==="
echo "Alignment     : ${ALIGNMENT}"
echo "Output dir    : ${OUTPUT_DIR}"
echo "Model         : CAT-GTR (-cat -gtr)"
echo "Independent chains: ${N_CHAINS}"
date
echo ""

# ============================================================
# Step 1: Launch independent Markov chains
# ============================================================
# In the study, ten chains were run. Chains may be submitted as
# separate jobs on a cluster rather than sequentially as below.
echo ">>> [1/3] Starting ${N_CHAINS} independent CAT-GTR chains..."

for i in $(seq 1 "${N_CHAINS}"); do
  echo "    Chain ${i}..."
  # Background launch example; prefer one job per chain on HPC:
  mpirun -np "${MPI_NP}" "${SOFTWARE_DIR}/pb_mpi" \
    -d "${ALIGNMENT}" \
    -cat -gtr \
    "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain${i}" \
    > "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain${i}.launch.log" 2>&1 &
done
wait
echo "    All chains launched (or finished, if run synchronously)."
echo ""

# ============================================================
# Step 2: Convergence diagnostics (tracecomp)
# ============================================================
# Compare continuous parameters across chains. In this study,
# diagnostics indicated non-convergence; results were therefore
# not treated as a converged posterior sample.
echo ">>> [2/3] tracecomp (parameter convergence)..."
# Default burn-in is often 1/5 or user-specified; adjust -x as needed.
# Example:
# tracecomp -x 1000 \
#   "${OUTPUT_DIR}/${CHAIN_PREFIX}_chain"{1..10}
echo "    (Inspect effective sizes and rel_diff; non-convergence expected"
echo "     for this deep divergence under CAT-GTR — see Methods.)"
echo ""

# ============================================================
# Step 3: Bipartition comparison (bpcomp) — descriptive only
# ============================================================
# bpcomp compares bipartition frequencies among chains and can
# build a consensus. Because chains did not fully converge,
# topologies are reported at the chain level (e.g. 7/10 supporting
# TACK–Asgard + eukaryotes) rather than as posterior probabilities.
echo ">>> [3/3] bpcomp (bipartition frequencies across chains)..."
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

echo ""
echo "=== PhyloBayes CAT-GTR analysis finished ==="
date
echo "Chain outputs : ${OUTPUT_DIR}/${CHAIN_PREFIX}_chain*"
echo "bpcomp prefix : ${OUTPUT_DIR}/${CHAIN_PREFIX}_bpcomp"
echo ""
echo "Interpretation (as in the manuscript):"
echo "  • 10 independent chains; full convergence not achieved"
echo "  • 7/10 chains: eukaryotes sister to monophyletic TACK–Asgard"
echo "  • Remaining chains: deeper Asgard placements, no single"
echo "    extant Asgard lineage consistently preferred"
echo "  • Chain-level topologies summarised descriptively only"
echo "  • Primary inference: contamination-controlled ML + AU tests"
echo "See Methods: 'Topology testing and Bayesian inference'."
