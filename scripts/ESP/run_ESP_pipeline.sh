#!/usr/bin/env bash
# ============================================================
# Script : run_ESP_pipeline.sh (EXAMPLE TEMPLATE)
# Purpose: Detect canonical ESPs and extended iESPs in archaeal
#          genomes, enabling comparison before versus after
#          decontamination.
#
# Manuscript
# ----------
# Contamination and taxon sampling explain conflicting eukaryote
# placements
#
# Methods mirrored by this script
# --------------------------------
# ESP/iESP detection was based on the curated family list of
# Köstlbacher et al. For each family, a reference sequence cluster
# was compiled and used both for DIAMOND screening and for building
# a family-specific HMM. Predicted proteins from each genome were
# first screened with DIAMOND (ultra-sensitive); candidate hits were
# then confirmed with HMMER. High-confidence assignments required
# support from both searches. Contaminant-contig filtering
# (CAT / geNomad; primary decontamination) and before/after genome-
# count summaries were performed downstream of this pipeline.
#
# Workflow
# --------
#   1. Build DIAMOND database from ESP/iESP reference sequences
#   2. DIAMOND screen per genome → filter by e-value and coverage
#   3. hmmbuild one HMM per family alignment
#   4. Concatenate family HMMs and hmmpress
#   5. hmmsearch per genome
#
# Tools  : DIAMOND, HMMER (hmmbuild, hmmpress, hmmsearch)
# Note   : EXAMPLE template. Paths are placeholders.
# ============================================================

set -euo pipefail

########################
# Paths (edit these)
########################
WORKDIR="/path/to/your/project"
PROTEIN_DIR="${WORKDIR}/proteins"              # one .faa per genome (Prodigal)
ESP_REF_FAA="${WORKDIR}/reference/ESP_reference.faa"
                                               # merged ESP/iESP family sequences
                                               # headers should retain family IDs
                                               # e.g. >ESP0001|seq1
ALN_DIR="${WORKDIR}/reference/family_alignments"
                                               # one *.aln per ESP/iESP family
ESP_HMM_DIR="${WORKDIR}/reference/ESP_iESP_hmms"
ESP_HMM_ALL="${WORKDIR}/reference/all_families.hmm"

THREADS="${THREADS:-16}"
THREADS_HMM="${THREADS_HMM:-32}"

# DIAMOND filter thresholds (Methods)
EVALUE_MAX="1e-5"
QCOV_MIN=50
SCOV_MIN=50

mkdir -p \
  "${WORKDIR}/diamond/per_genome" \
  "${WORKDIR}/hmmsearch/per_genome" \
  "${ESP_HMM_DIR}"

echo "=== ESP / iESP detection pipeline ==="
echo "Protein directory : ${PROTEIN_DIR}"
echo "Reference FASTA   : ${ESP_REF_FAA}"
date
echo ""

########################
# 1. DIAMOND database
########################
echo "[1/5] Building DIAMOND database from ESP/iESP reference..."
diamond makedb \
  --in "${ESP_REF_FAA}" \
  -d "${WORKDIR}/ESP_reference" \
  --threads "${THREADS}"

########################
# 2. DIAMOND screen (per genome)
########################
echo "[2/5] DIAMOND screening (ultra-sensitive; per genome)..."
shopt -s nullglob
faa_files=("${PROTEIN_DIR}"/*.faa)

if [[ ${#faa_files[@]} -eq 0 ]]; then
  echo "WARNING: No .faa files found in ${PROTEIN_DIR}"
else
  for faa in "${faa_files[@]}"; do
    base=$(basename "$faa" .faa)
    echo "  → ${base}"

    diamond blastp \
      -q "$faa" \
      -d "${WORKDIR}/ESP_reference.dmnd" \
      -o "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.tsv" \
      --ultra-sensitive \
      --evalue "${EVALUE_MAX}" \
      --max-target-seqs 50 \
      --threads "${THREADS}" \
      --outfmt 6 qseqid sseqid pident length qlen slen qcovhsp scovhsp evalue bitscore

    # Keep hits with e-value ≤ 1e-5 and query/subject coverage ≥ 50%
    awk -v emax="${EVALUE_MAX}" -v qmin="${QCOV_MIN}" -v smin="${SCOV_MIN}" \
      'BEGIN{FS=OFS="\t"} $9<=emax+0 && $7>=qmin && $8>=smin' \
      "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.tsv" \
      > "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.filtered.tsv"
  done

  # Optional merged table for downstream summary in R
  cat "${WORKDIR}/diamond/per_genome"/*_vs_ESP.filtered.tsv \
    > "${WORKDIR}/diamond/all_vs_ESP.filtered.tsv" 2>/dev/null || true
fi

########################
# 3. Per-family HMMs from alignments
########################
echo "[3/5] hmmbuild (one HMM per family alignment)..."
aln_files=("${ALN_DIR}"/*.aln)

if [[ ${#aln_files[@]} -eq 0 ]]; then
  echo "WARNING: No .aln files found in ${ALN_DIR}"
else
  for aln in "${aln_files[@]}"; do
    base=$(basename "$aln" .aln)
    echo "  → ${base}"
    hmmbuild --cpu "${THREADS_HMM}" \
      "${ESP_HMM_DIR}/${base}.hmm" \
      "$aln"
  done
fi

########################
# 4. Combine HMMs + hmmpress
########################
echo "[4/5] Concatenating family HMMs and running hmmpress..."
rm -f "${ESP_HMM_ALL}" "${ESP_HMM_ALL}".h3{m,i,f,p}

find "${ESP_HMM_DIR}" -name "*.hmm" -type f -print0 \
  | xargs -0 cat >> "${ESP_HMM_ALL}"

hmmpress "${ESP_HMM_ALL}"

########################
# 5. hmmsearch (per genome)
########################
echo "[5/5] hmmsearch (per genome)..."
if [[ ${#faa_files[@]} -gt 0 ]]; then
  for faa in "${faa_files[@]}"; do
    base=$(basename "$faa" .faa)
    echo "  → ${base}"

    hmmsearch --cpu "${THREADS}" \
      --tblout "${WORKDIR}/hmmsearch/per_genome/${base}_vs_ESP.tbl" \
      "${ESP_HMM_ALL}" \
      "$faa" \
      > "${WORKDIR}/hmmsearch/per_genome/${base}_vs_ESP.out"
  done
fi

echo ""
echo "=== ESP / iESP detection finished ==="
date
echo "  DIAMOND filtered hits : ${WORKDIR}/diamond/per_genome/"
echo "                         ${WORKDIR}/diamond/all_vs_ESP.filtered.tsv"
echo "  HMMER tblout          : ${WORKDIR}/hmmsearch/per_genome/"
echo ""
echo "Downstream (not in this script):"
echo "  - Map protein hits to contigs"
echo "  - Exclude proteins on contaminant contigs (CAT + geNomad free-virus)"
echo "  - Summarise Genome_Count_Before / After per ESP family"
echo "    (see data/ESP/ and Supplementary Tables 11–18)"
