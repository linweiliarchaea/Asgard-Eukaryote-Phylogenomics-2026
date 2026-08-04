#!/bin/bash
# ============================================================
# Script : independent_audit.sh (EXAMPLE TEMPLATE)
# Purpose: Independent post-hoc contamination audit on already
#          decontaminated genome collections (e.g. GS-Present-B-
#          clean / GS-Zhang2025-B-clean).
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote
# placements
#
# Methods mirrored by this script
# --------------------------------
# "Independent post-hoc contamination audit"
#
# This is a robustness verification step applied after primary
# decontamination. It does not rebuild collections from raw data,
# does not alter taxonomic sampling structure, and does not introduce
# new analysis variables. Residual bacterial, free-virus and
# eukaryotic signals are assessed with source-specific tools under a
# conservative multi-evidence framework. Proviruses were retained by
# default. In practice, additional candidate contamination identified
# at this stage accounted for <0.8% of contigs in each audited
# archaeal group and did not alter the recovered topology
# (eukaryotes sister to a monophyletic TACK–Asgard clade).
#
# Tool roles
# ----------
#   GUNC        bacterial chimerism / taxonomic inconsistency
#               (flag when chimeric AND contig assigned as bacterial;
#                intersected with GC-anomaly contigs)
#   VirSorter2  viral signal detection (score ≥ 0.5; full predictions)
#   CheckV      intersect with VirSorter2; free virus vs provirus
#   Whokaryote  eukaryotic sequence detection
#               (intersected with GC-anomaly contigs)
#   GC anomaly  supports bacterial and eukaryotic calls only
#               (not applied to viral decisions)
#
# Companion R script
# ------------------
#   scripts/independent_audit/merge_audit_flags_and_extract_markers.R
#   Merges primary flags (CAT + geNomad free-virus) with audit flags
#   (GUNC∩GC, VirSorter2∩CheckV, Whokaryote∩GC) and extracts cleaned
#   marker proteins.
#
# Stage  : Robustness (post-hoc audit)
# Note   : EXAMPLE template. Paths are placeholders.
# ============================================================

set -euo pipefail

# ------------------ Configuration (MODIFY AS NEEDED) ------------------
WORK_DIR="/path/to/your/project"
SOFTWARE_DIR="/path/to/your/software"
SCRIPT_DIR="${WORK_DIR}/scripts/independent_audit"

# Already primary-decontaminated genomes (clean collections)
INPUT_GENOMES="${WORK_DIR}/data/genomes/GS-Present-B-clean"

OUTPUT_DIR="${WORK_DIR}/results/independent_audit"
LOG_DIR="${OUTPUT_DIR}/logs"

GUNC_DB="${SOFTWARE_DIR}/gunc_db_gtdb214_2/gunc_db_gtdb214.dmnd"
VIRSORTER_DB="${SOFTWARE_DIR}/VirSorter2/db"

THREADS_GUNC=96
THREADS_VIRSORTER=18
THREADS_CHECKV=4

mkdir -p \
  "${OUTPUT_DIR}/gunc" \
  "${OUTPUT_DIR}/virsorter2" \
  "${OUTPUT_DIR}/checkv" \
  "${OUTPUT_DIR}/whokaryote" \
  "${OUTPUT_DIR}/flags" \
  "${LOG_DIR}"

echo "=== Independent post-hoc contamination audit ==="
echo "Input genomes (clean) : ${INPUT_GENOMES}"
echo "Output directory      : ${OUTPUT_DIR}"
date
echo ""

# ============================================================
# 1. GUNC — bacterial chimerism and taxonomic inconsistency
# ============================================================
# A contig is treated as bacterial-derived contamination when:
#   (1) GUNC_pass indicates chimeric, AND
#   (2) GUNC_contig_bac is Yes
# Downstream, GUNC hits are intersected with GC-anomaly contigs.
echo ">>> GUNC (chimerism / bacterial assignment)..."
gunc run \
  --input_dir "${INPUT_GENOMES}" \
  --file_suffix .fna \
  --threads "${THREADS_GUNC}" \
  -r "${GUNC_DB}" \
  --out_dir "${OUTPUT_DIR}/gunc" \
  --contig_taxonomy_output \
  > "${LOG_DIR}/gunc.log" 2>&1

echo "    GUNC finished."
echo ""

# ============================================================
# 2. VirSorter2 + CheckV — free viral sequences only
# ============================================================
# VirSorter2 provides viral-signal evidence (score ≥ 0.5).
# Only "full" predictions are retained; sequence names are stripped
# of the ||full suffix before intersecting with CheckV contig IDs.
# CheckV classifies structure:
#   free_virus      → candidate for removal
#   provirus        → retained by default
#   host_dominated  → viral signal unreliable; not used for removal
echo ">>> VirSorter2 (viral signal)..."
virsorter run \
  -w "${OUTPUT_DIR}/virsorter2" \
  -i "${INPUT_GENOMES}" \
  --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae \
  -j "${THREADS_VIRSORTER}" \
  --db-dir "${VIRSORTER_DB}" \
  all \
  > "${LOG_DIR}/virsorter2.log" 2>&1

echo ">>> CheckV (free virus vs provirus)..."
checkv end_to_end \
  "${INPUT_GENOMES}" \
  "${OUTPUT_DIR}/checkv" \
  -t "${THREADS_CHECKV}" \
  > "${LOG_DIR}/checkv.log" 2>&1

echo "    VirSorter2 + CheckV finished."
echo ""

# ============================================================
# 3. Whokaryote — eukaryotic contigs
# ============================================================
# Downstream, Whokaryote hits are intersected with GC-anomaly contigs.
echo ">>> Whokaryote (eukaryotic sequence detection)..."
whokaryote.py \
  --contigs "${INPUT_GENOMES}" \
  --outdir "${OUTPUT_DIR}/whokaryote" \
  --model S \
  > "${LOG_DIR}/whokaryote.log" 2>&1

echo "    Whokaryote finished."
echo ""

# ============================================================
# 4. Merge multi-evidence flags and extract cleaned markers (R)
# ============================================================
# Per genome, contigs are excluded if flagged by any of:
#   • geNomad free-virus (topology != Provirus)   [primary]
#   • CAT exogenous contigs                       [primary]
#   • GUNC bacterial/chimeric ∩ GC anomaly        [audit]
#   • VirSorter2 full hits ∩ CheckV               [audit]
#   • Whokaryote eukaryotic ∩ GC anomaly          [audit]
#
# GC anomaly supports bacterial and eukaryotic calls only (not viral).
# Proviruses are retained. The union of the above contig sets is removed
# before orthologue selection.
#
# Companion script:
#   merge_audit_flags_and_extract_markers.R
#
echo ">>> Merging audit flags and extracting markers..."
# Rscript "${SCRIPT_DIR}/merge_audit_flags_and_extract_markers.R"
# Edit paths inside the R script to point at:
#   - tool outputs under ${OUTPUT_DIR}
#   - primary CAT / geNomad flag tables
#   - eggNOG annotation and protein FASTA inventories

echo ""
echo "=== Independent post-hoc audit finished ==="
date
echo "Tool outputs:"
echo "  GUNC       : ${OUTPUT_DIR}/gunc/"
echo "  VirSorter2 : ${OUTPUT_DIR}/virsorter2/"
echo "  CheckV     : ${OUTPUT_DIR}/checkv/"
echo "  Whokaryote : ${OUTPUT_DIR}/whokaryote/"
echo ""
echo "Marker FASTAs after audit: produced by"
echo "  merge_audit_flags_and_extract_markers.R"
echo "Additional contig removal at this stage was <0.8% per archaeal group"
echo "and did not alter the main phylogenetic topology (Methods / Results)."
echo "Primary conclusions remain based on the clean collections; the audit"
echo "verifies that residual contamination is not topology-determining."
