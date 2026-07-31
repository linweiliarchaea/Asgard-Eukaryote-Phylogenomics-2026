# Data directory

Overview of tables, alignments and trees deposited under `data/`. Paths are relative to the repository root.

---

## Subfolders

| Subfolder | Contents |
| --- | --- |
| `supplementary_tables/` | Complete set of Supplementary Tables and index README |
| `genome_sets/` | Genome accession lists and GTDB taxonomy for each collection (imbalanced and balanced) |
| `taxonomic_counts/` | Genome counts at phylum, class and order levels after hierarchical balancing (separate sheets for Archaea, Bacteria and Eukaryota) |
| `PMS/` | Marker membership and overlap among the four independently curated phylogenetic marker sets |
| `alignments/` | Concatenated amino-acid supermatrices used as IQ-TREE input |
| `trees/maximum_likelihood/` | IQ-TREE consensus trees (`.contree`) for GS × PMS combinations under LG+C60+F+G |
| `trees/PMSF/` | Site-heterogeneous maximum-likelihood analyses under LG+C60+F+G+PMSF |
| `trees/CAT-GTR/` | PhyloBayes MPI CAT-GTR trees (ten independent chains; chain-level topologies summarized descriptively) |
| `trees/AU_tests/` | Constraint topologies and approximately unbiased (AU) test output |
| `trees/robustness_analyses.xlsx` | Summary of topological outcomes across independent robustness analyses |
| `decontamination/assessment/` | Lineage-level contamination frequencies, contamination-derived eukaryote-like protein summaries, and related assessment tables |
| `decontamination/phylogenomic_sets/` | Contig-removal summaries for primary decontamination and independent post-hoc audit |
| `ESP/` | ESP / iESP presence–absence before versus after decontamination, by major archaeal group (Asgard, TACK, Euryarchaeota, DPANN) |
| `viral_detection_comparison/` | Summary tables supporting the comparison of viral-signal detectors (geNomad versus Phager) |

---

## Genome collections (GS)

| Label | Description |
| --- | --- |
| GS-Zhang2025 | Benchmark set based on Zhang et al. 2025 (sampling-imbalanced) |
| GS-Zhang2025-B | Taxonomically balanced version of GS-Zhang2025 |
| GS-Liu2021 | Benchmark set based on Liu et al. 2021 (sampling-imbalanced) |
| GS-Liu2021-B | Taxonomically balanced version of GS-Liu2021 |
| GS-Present-B | Independently assembled, taxonomically balanced genome set (this study) |

**Suffixes used in alignment and tree filenames**

| Suffix | Meaning |
| --- | --- |
| **raw** | Before primary decontamination |
| **clean** | After primary decontamination |
| **ultra-clean** | After independent post-hoc audit (where applicable) |
| **B** | Taxonomically balanced collection |

---

## Phylogenetic marker sets (PMS)

| PMS | Description |
| --- | --- |
| PMS-Isolate | Complete isolate genomes only (strictest contamination control; lowest diversity) |
| PMS-HighMAG1 | Isolates + high-quality MAGs after decontamination |
| PMS-HighMAG2 | Isolates + complete-genome-level MAGs after decontamination |
| PMS-MediumMAG | Isolates + CheckM-defined medium-quality MAGs after decontamination (highest diversity) |

The four marker sets were independently curated after decontamination and single-protein-tree screening for HGT-like or anomalous phylogenetic histories. They share a core of 28 markers but are not strictly nested.

Marker composition and overlap: `data/PMS/PMS_composition_and_overlap.xlsx`

---

## Supplementary Tables

Full index and descriptions: `data/supplementary_tables/README.md`

| Tables | Content |
| --- | --- |
| 1–5 | Genome accessions and GTDB taxonomy for each GS |
| 6 | Phylogenetic results across all GS × PMS combinations |
| 7–8 | Independent post-hoc contamination audit |
| 9 | Retention of core phylogenetic markers before and after decontamination |
| 10–17 | ESP inventories and aggregated loss rates (Asgard, TACK, Euryarchaeota, DPANN) |
| 18–20 | Final taxonomic counts after balancing (GS-Present-B, GS-Zhang2025-B, GS-Liu2021-B) |

---

## File naming conventions

Alignments and trees generally follow:

```text
{GS}-{raw|clean|ultra-clean}_{PMS}.{faa|contree}
```

Examples:

- `GS-Zhang2025-B-clean_PMS-MediumMAG.contree`
- `GS-Present-B-raw_PMS-Isolate.faa`
- `GS-Zhang2025-B-ultra-clean_PMS-MediumMAG.contree`

---

## Notes

- All accession lists use NCBI assembly accessions (GCA_/GCF_) where available.
- GTDB taxonomy follows GTDB release R220 (or the release used for the corresponding analysis).
- Under full control of both contamination and taxonomic sampling imbalance, all 12 genome-set–marker-set analyses recovered eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation.
- Numerical results underlying main-figure contamination panels are deposited under `data/decontamination/assessment/`.
- Example analysis commands are provided under `scripts/`; paths inside scripts are placeholders and should be adapted to local environments.
