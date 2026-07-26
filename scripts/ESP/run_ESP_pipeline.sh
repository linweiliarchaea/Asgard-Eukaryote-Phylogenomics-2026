#!/usr/bin/env bash
# run_ESP_pipeline.sh
# ESP/iESP detection per genome:
#   DIAMOND screen → per-family hmmbuild → combine HMMs → hmmpress → hmmsearch
# Reference ESP/iESP families: curated list (e.g. Köstlbacher et al.)
# Contaminant-contig filtering (CAT/geNomad) and before/after counts are done downstream.

set -euo pipefail

########################
# Paths (edit these)
########################
WORKDIR="/path/to/your/project"
PROTEIN_DIR="${WORKDIR}/proteins"                 # one .faa per genome
ESP_REF_FAA="${WORKDIR}/reference/ESP_reference.faa"
ALN_DIR="${WORKDIR}/reference/cogs_v2"            # one *.aln per ESP family
ESP_HMM_DIR="${WORKDIR}/reference/ESP_iESP"       # output: one *.hmm per family
ESP_HMM_ALL="${WORKDIR}/reference/all_families.hmm"
THREADS="${THREADS:-16}"
THREADS_HMM="${THREADS_HMM:-32}"

mkdir -p "${WORKDIR}"/{diamond/per_genome,hmmsearch/per_genome}
mkdir -p "${ESP_HMM_DIR}"

########################
# 1. DIAMOND database
########################
echo "[1/5] Building DIAMOND database..."
diamond makedb \
  --in "${ESP_REF_FAA}" \
  -d "${WORKDIR}/ESP_reference" \
  --threads "${THREADS}"

########################
# 2. DIAMOND screen (per genome)
########################
echo "[2/5] DIAMOND screening (per genome)..."
for faa in "${PROTEIN_DIR}"/*.faa; do
  [[ -e "$faa" ]] || continue
  base=$(basename "$faa" .faa)
  echo "  → ${base}"

  diamond blastp \
    -q "$faa" \
    -d "${WORKDIR}/ESP_reference.dmnd" \
    -o "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.tsv" \
    --ultra-sensitive \
    --evalue 1e-5 \
    --max-target-seqs 50 \
    --threads "${THREADS}" \
    --outfmt 6 qseqid sseqid pident length qlen slen qcovhsp scovhsp evalue bitscore

  awk 'BEGIN{FS=OFS="\t"} $9<=1e-5 && $7>=50 && $8>=50' \
    "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.tsv" \
    > "${WORKDIR}/diamond/per_genome/${base}_vs_ESP.filtered.tsv"
done

# Optional merged table for downstream R summary
cat "${WORKDIR}/diamond/per_genome"/*_vs_ESP.filtered.tsv \
  > "${WORKDIR}/diamond/all_vs_ESP.filtered.tsv"

########################
# 3. Per-family HMMs from alignments
########################
echo "[3/5] hmmbuild (one HMM per family alignment)..."
for aln in "${ALN_DIR}"/*.aln; do
  [[ -e "$aln" ]] || continue
  base=$(basename "$aln" .aln)
  echo "  → ${base}"
  hmmbuild --cpu "${THREADS_HMM}" \
    "${ESP_HMM_DIR}/${base}.hmm" \
    "$aln"
done

########################
# 4. Combine HMMs + hmmpress
########################
echo "[4/5] Concatenating family HMMs and hmmpress..."
rm -f "${ESP_HMM_ALL}" "${ESP_HMM_ALL}".h3{m,i,f,p}

find "${ESP_HMM_DIR}" -name "*.hmm" -type f -print0 \
  | xargs -0 cat >> "${ESP_HMM_ALL}"

hmmpress "${ESP_HMM_ALL}"

########################
# 5. hmmsearch (per genome)
########################
echo "[5/5] hmmsearch (per genome)..."
for faa in "${PROTEIN_DIR}"/*.faa; do
  [[ -e "$faa" ]] || continue
  base=$(basename "$faa" .faa)
  echo "  → ${base}"

  hmmsearch --cpu "${THREADS}" \
    --tblout "${WORKDIR}/hmmsearch/per_genome/${base}_vs_ESP.tbl" \
    "${ESP_HMM_ALL}" \
    "$faa" \
    > "${WORKDIR}/hmmsearch/per_genome/${base}_vs_ESP.out"
done

echo "Done."
echo "  DIAMOND filtered hits: ${WORKDIR}/diamond/per_genome/ and all_vs_ESP.filtered.tsv"
echo "  HMMER tblout:          ${WORKDIR}/hmmsearch/per_genome/"
echo "  Next: map hits to contigs, exclude contaminant contigs (CAT/geNomad),"
echo "        then summarize Genome_Count_Before / After per ESP family."