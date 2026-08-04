#!/bin/bash
# ============================================================
# Script : run_decontamination.sh (EXAMPLE TEMPLATE)
# Purpose: Identify candidate exogenous sequences in archaeal MAGs
#          and generate decontaminated (clean) genome collections.
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote
# placements
#
# Methods section mirrored by this script
# ---------------------------------------
# "Identification of candidate exogenous sequences"
#
# Contig-level taxonomic classifications were generated with CAT v6.0
# (sensitive mode). Contigs annotated as "no ORFs found" were excluded.
# Candidate exogenous contigs were defined as those for which:
#   (i)   classification was restricted to the root level; or
#   (ii)  the second taxonomic rank was not cellular organisms
#         (NCBI Taxonomy ID 131567); or
#   (iii) the third taxonomic rank was not Archaea
#         (NCBI Taxonomy ID 2157).
# Contaminant origins were assigned to bacterial, eukaryotic, viral or
# unclassified categories. Viral sequences were additionally identified
# with geNomad v1.8.0 (conservative mode). Free-virus calls
# (topology != Provirus) were retained; proviruses were not treated as
# exogenous contamination. Contigs flagged by CAT and/or geNomad were
# removed to produce clean genome collections. Genomes before and after
# contaminant removal are referred to as raw and clean datasets.
#
# Companion R scripts (same repository)
# --------------------------------------
#   scripts/decontamination/flag_exogenous_contigs_CAT.R
#       → parse CAT official-names files; apply criteria (i)–(iii)
#   scripts/decontamination/collect_genomad_virus_summaries.R
#       → aggregate *_virus_summary.tsv tables
#   scripts/decontamination/remove_exogenous_and_extract_markers.R
#       → union(CAT, geNomad free-virus) and extract cleaned markers
#
# Tools  : CAT v6.0, geNomad v1.8.0, R
# Stage  : Primary decontamination
# Note   : EXAMPLE template only. Paths are placeholders and must be
#          adapted to the local environment.
# ============================================================

set -euo pipefail

# ------------------ Configuration (MODIFY AS NEEDED) ------------------
WORK_DIR="/path/to/your/project"
SOFTWARE_DIR="/path/to/your/software"
SCRIPT_DIR="${WORK_DIR}/scripts/decontamination"

RAW_GENOMES_DIR="${WORK_DIR}/data/genomes/raw_MAGs"
OUTPUT_DIR="${WORK_DIR}/results/decontamination"

CAT_DB="${SOFTWARE_DIR}/20240422_CAT_nr/db"
CAT_TAX="${SOFTWARE_DIR}/20240422_CAT_nr/tax"
GENOMAD_DB="${SOFTWARE_DIR}/genomad_db"

THREADS_CAT=18
THREADS_GENOMAD=4

mkdir -p \
  "${OUTPUT_DIR}/cat_classification/contigs" \
  "${OUTPUT_DIR}/cat_classification/add_names" \
  "${OUTPUT_DIR}/cat_classification/summaries" \
  "${OUTPUT_DIR}/genomad" \
  "${OUTPUT_DIR}/flags" \
  "${OUTPUT_DIR}/clean_genomes" \
  "${OUTPUT_DIR}/logs"

echo "=== Primary decontamination workflow ==="
echo "Input raw genomes : ${RAW_GENOMES_DIR}"
echo "Output directory  : ${OUTPUT_DIR}"
date
echo ""

# ============================================================
# Helper: process a single genome (CAT + geNomad)
# ============================================================
process_genome() {
  local genome_fna="$1"
  local base
  base=$(basename "${genome_fna}" .fna)

  echo ">>> Processing ${base}"

  # ----------------------------------------------------------
  # 1. Contig-level taxonomic classification (CAT v6.0, sensitive)
  # ----------------------------------------------------------
  echo "    CAT classification (sensitive mode)..."
  CAT_pack contigs \
    -c "${genome_fna}" \
    -d "${CAT_DB}" \
    -t "${CAT_TAX}" \
    -o "${OUTPUT_DIR}/cat_classification/contigs/${base}" \
    --sensitive \
    -n "${THREADS_CAT}" \
    > "${OUTPUT_DIR}/logs/${base}.CAT_contigs.log" 2>&1

  # Official names file is the input to flag_exogenous_contigs_CAT.R
  CAT_pack add_names \
    -i "${OUTPUT_DIR}/cat_classification/contigs/${base}.contig2classification.txt" \
    -o "${OUTPUT_DIR}/cat_classification/add_names/${base}.contig2classification.official_names.txt" \
    -t "${CAT_TAX}" \
    --only_official \
    > "${OUTPUT_DIR}/logs/${base}.CAT_add_names.log" 2>&1

  CAT_pack summarise \
    -c "${genome_fna}" \
    -i "${OUTPUT_DIR}/cat_classification/contigs/${base}.contig2classification.txt" \
    -o "${OUTPUT_DIR}/cat_classification/summaries/${base}.summary.txt" \
    > "${OUTPUT_DIR}/logs/${base}.CAT_summarise.log" 2>&1

  # ----------------------------------------------------------
  # 2. Independent viral detection (geNomad v1.8.0, conservative)
  # ----------------------------------------------------------
  echo "    geNomad viral detection (conservative mode)..."
  genomad end-to-end \
    --threads "${THREADS_GENOMAD}" \
    --conservative \
    "${genome_fna}" \
    "${OUTPUT_DIR}/genomad" \
    "${GENOMAD_DB}" \
    > "${OUTPUT_DIR}/logs/${base}.genomad.log" 2>&1

  echo "    Done: ${base}"
  echo ""
}

# ============================================================
# Batch: CAT + geNomad for all genomes
# ============================================================
echo ">>> Scanning input directory for *.fna files..."
shopt -s nullglob
genome_files=("${RAW_GENOMES_DIR}"/*.fna)

if [[ ${#genome_files[@]} -eq 0 ]]; then
  echo "WARNING: No .fna files found in ${RAW_GENOMES_DIR}"
  echo "         Place genomes there or call process_genome on a single file."
else
  for fna in "${genome_files[@]}"; do
    process_genome "${fna}"
  done
fi

# ============================================================
# 3. Flag CAT-based exogenous contigs (R)
#    Criteria (i)–(iii); exclude "no ORFs found"
#    Input : *.contig2classification.official_names.txt
#    Output: candidate_exogenous_contigs_CAT.txt
# ============================================================
echo ">>> Flagging CAT exogenous contigs..."
(
  cd "${OUTPUT_DIR}/cat_classification/add_names"
  Rscript "${SCRIPT_DIR}/flag_exogenous_contigs_CAT.R"
  mv -f candidate_exogenous_contigs_CAT.txt \
    "${OUTPUT_DIR}/flags/candidate_exogenous_contigs_CAT.txt"
)

# ============================================================
# 4. Aggregate geNomad virus summaries (R)
#    Input : recursive *_virus_summary.tsv under OUTPUT_DIR/genomad
#    Output: genomad_conservative.txt
# ============================================================
echo ">>> Collecting geNomad virus summaries..."
(
  cd "${OUTPUT_DIR}/genomad"
  Rscript "${SCRIPT_DIR}/collect_genomad_virus_summaries.R"
  mv -f genomad_conservative.txt \
    "${OUTPUT_DIR}/flags/genomad_conservative.txt"
)

# ============================================================
# 5. Merge flags and write clean genomes / cleaned markers (R)
#    union(CAT exogenous, geNomad free-virus [topology != Provirus])
#    Then remove flagged contigs from annotations / genomes and
#    extract representative eggNOG proteins for PMS construction.
#
#    See: remove_exogenous_and_extract_markers.R
# ============================================================
echo ">>> Removing exogenous contigs and extracting cleaned markers..."
# Rscript "${SCRIPT_DIR}/remove_exogenous_and_extract_markers.R"
# (Paths inside the R script must point to the flag tables above
#  and to the relevant genome / annotation collections.)

echo ""
echo "=== Primary decontamination workflow finished ==="
date
echo "Flag tables : ${OUTPUT_DIR}/flags/"
echo "Clean genomes / cleaned marker FASTAs are produced by the"
echo "companion R script remove_exogenous_and_extract_markers.R"
echo "Raw vs clean designations correspond to genome sets before and"
echo "after contaminant removal, as defined in the manuscript."
