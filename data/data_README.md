# Data directory

Overview of tables, alignments and trees deposited under `data/`. Paths are relative to the repository root.

---

## Subfolders

| Subfolder | Contents |
| --- | --- |
| `genome_sets/` | Genome accession lists and GTDB taxonomy for each collection (imbalanced and balanced) |
| `taxonomic_counts/` | Genome counts at phylum, class and order levels after hierarchical balancing (separate sheets or files per domain where applicable) |
| `PMS/` | Marker membership and overlap among the four phylogenetic marker sets |
| `alignments/` | Concatenated amino-acid supermatrices used as IQ-TREE input |
| `trees/maximum_likelihood/` | IQ-TREE consensus trees (`.contree`) for GS × PMS combinations |
| `trees/PMSF/` | PMSF (posterior mean site frequency) analyses |
| `trees/CAT-GTR/` | PhyloBayes MPI CAT-GTR trees (per chain and/or consensus, as deposited) |
| `trees/AU_tests/` | Constraint topologies and approximately unbiased (AU) test output |
| `trees/robustness_analyses.xlsx` | Summary of topological outcomes across robustness analyses |
| `decontamination/assessment/` | Lineage-level contamination frequencies, contamination-derived eukaryotic-like protein summaries, and related assessment tables (e.g. supporting Fig. 1 and Extended Data figures) |
| `decontamination/phylogenomic_sets/` | Contig-removal summaries for primary decontamination of phylogenomic collections; post-hoc audit tables where provided |
| `ESP/` | ESP / iESP presence–absence before versus after decontamination, by major archaeal group (Asgard, TACK, Euryarchaeota, DPANN) |
| `viral_detection_comparison/` | Summary tables for viral-signal comparison (e.g. hallmark genes, taxonomy pies, set overlaps) |

---

## Genome collections (GS) represented in filenames

| Label | Description |
| --- | --- |
| GS-Zhang2025 | Benchmark set based on Dong/Zhang et al. (sampling-imbalanced) |
| GS-Zhang2025-B | Taxonomically balanced version of GS-Zhang2025 |
| GS-Liu2021 | Benchmark set based on Liu et al. (2021) (sampling-imbalanced) |
| GS-Liu2021-B | Taxonomically balanced version of GS-Liu2021 |
| GS-Present-B | Independently assembled, taxonomically balanced set (this study) |

---

## File name conventions

| Pattern | Meaning |
| --- | --- |
| `*-raw-*` | Before primary decontamination |
| `*-clean-*` | After primary decontamination |
| `*-ultra-clean-*` | After independent post-hoc contamination audit (where applicable) |
| `*-B-*` | Taxonomically balanced genome collection |
| `*_PMS-Isolate` / `*_PMS-HighMAG1` / `*_PMS-HighMAG2` / `*_PMS-MediumMAG` | Marker set used for that alignment or tree |

Alignment files are amino-acid FASTA (`.faa`). Tree files follow IQ-TREE / PhyloBayes naming (e.g. `.treefile`, `.contree`).

---

## Notes

- Not every GS × PMS × (raw/clean) combination is deposited if it was unused in the final analyses; deposited files correspond to those supporting the manuscript figures and tables.
- Large intermediate files (raw MAG assemblies, per-contig CAT/geNomad outputs) are not included; accession lists and summary tables are provided instead.
- For script paths and software versions, see the repository root `README.md` and `scripts/`.
```

---
