# Data directory

Overview of tables, alignments and trees deposited under `data/`. Paths are relative to the repository root.

This repository supports the manuscript  
**Contamination and taxon sampling explain conflicting eukaryote placements**.

---

## Directory structure

```text
data/
├── genome_sets/                 # 1. Genome accession lists and GTDB taxonomy
├── taxonomic_counts/            # 2. Phylum / class / order counts after balancing
├── decontamination/
│   ├── assessment/              # 3. Lineage-level contamination frequencies
│   └── phylogenomic_sets/       # 4. Contig-removal summaries (primary + post-hoc)
├── viral_detection_comparison/  # 5. geNomad versus Phager comparison
├── PMS/                         # 6. Marker composition and overlap
├── alignments/                  # 7. Concatenated amino-acid supermatrices
├── trees/
│   ├── maximum_likelihood/      # 8a. IQ-TREE LG+C60+F+G consensus trees
│   ├── PMSF/                    # 8b. LG+C60+F+G+PMSF trees
│   ├── CAT-GTR/                 # 8c. PhyloBayes MPI chain-level trees
│   ├── AU_tests/                # 8d. Constraint topologies and AU test output
│   └── robustness_analyses.xlsx # 8e. Summary of independent robustness tests
├── ESP/                         # 9. ESP presence before vs after decontamination
├── supplementary_tables/        # 10. Complete Supplementary Tables (Tables 1–21)
└── data_README.md
```

---

## Subfolder contents

Ordered to follow the analytical workflow of the study (genome collection → bias assessment → marker construction → phylogenomic inference → functional impact → compiled tables).

| Subfolder | Contents |
| --- | --- |
| `genome_sets/` | Genome accession lists and GTDB taxonomy for each collection (imbalanced and balanced) |
| `taxonomic_counts/` | Genome counts at phylum, class and order levels after hierarchical balancing (separate sheets for Archaea, Bacteria and Eukaryota) |
| `decontamination/assessment/` | Lineage-level contamination frequencies, contamination-derived eukaryote-like protein summaries, and related assessment tables |
| `decontamination/phylogenomic_sets/` | Contig-removal summaries for primary decontamination and the independent post-hoc audit |
| `viral_detection_comparison/` | Summary tables supporting the comparison of viral-signal detectors (geNomad versus Phager) |
| `PMS/` | Marker membership and overlap among the four independently curated phylogenetic marker sets |
| `alignments/` | Concatenated amino-acid supermatrices used as IQ-TREE input |
| `trees/maximum_likelihood/` | IQ-TREE consensus trees (`.contree`) for GS × PMS combinations under LG+C60+F+G |
| `trees/PMSF/` | Site-heterogeneous maximum-likelihood analyses under LG+C60+F+G+PMSF |
| `trees/CAT-GTR/` | PhyloBayes MPI CAT-GTR trees (ten independent chains; chain-level topologies summarised descriptively because full convergence was not achieved) |
| `trees/AU_tests/` | Constraint topologies and approximately unbiased (AU) test output |
| `trees/robustness_analyses.xlsx` | Summary of topological outcomes across independent robustness analyses |
| `ESP/` | ESP / iESP presence–absence before versus after decontamination, by major archaeal group (Asgard, TACK, Euryarchaeota, DPANN) |
| `supplementary_tables/` | Complete set of Supplementary Tables and index README |

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

Primary decontamination removed approximately 4–5% of contigs from the balanced collections (GS-Zhang2025-B 4.91%; GS-Liu2021-B 4.22%; GS-Present-B 5.11%). Additional candidate contamination identified in the independent post-hoc audit accounted for <0.8% of contigs in each audited archaeal group.

---

## Phylogenetic marker sets (PMS)

| PMS | Description |
| --- | --- |
| PMS-Isolate | Complete isolate genomes only (strictest contamination control; lowest diversity) |
| PMS-HighMAG1 | Isolates + high-quality MAGs after decontamination |
| PMS-HighMAG2 | Isolates + complete-genome-level MAGs after decontamination |
| PMS-MediumMAG | Isolates + CheckM-defined medium-quality MAGs after decontamination (highest diversity) |

The four marker sets were independently curated after decontamination and single-protein-tree screening for HGT-like or anomalous phylogenetic histories. They contain 35, 34, 32 and 30 proteins, respectively, and share a core of 28 markers but are not strictly nested.

Marker composition and overlap: `data/PMS/PMS_composition_and_overlap.xlsx`

---

## Supplementary Tables

Full index and descriptions: `data/supplementary_tables/README.md`

| Tables | Content |
| --- | --- |
| 1 | Composition and overlap of the four independently curated PMSs |
| 2–6 | Genome accessions and GTDB taxonomy for each GS |
| 7 | Phylogenetic results across all GS × PMS combinations |
| 8 | Retention of core phylogenetic markers before and after decontamination |
| 9–10 | Independent post-hoc contamination audit |
| 11–18 | ESP inventories and aggregated loss rates (Asgard, TACK, Euryarchaeota, DPANN) |
| 19–21 | Final taxonomic counts after balancing (GS-Present-B, GS-Zhang2025-B, GS-Liu2021-B) |

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

## Key result reflected in these data

Under simultaneous control of both contamination and taxonomic sampling imbalance, all 12 analyses across the three independently assembled balanced genome sets and four independently curated marker sets recovered eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation, outside all currently sampled Asgard lineages.

---

## Notes

- All accession lists use NCBI assembly accessions (GCA_/GCF_) where available.
- GTDB taxonomy follows GTDB release R220 (or the release used for the corresponding analysis).
- Numerical results underlying main-figure contamination panels are deposited under `data/decontamination/assessment/`.
- Example analysis commands are provided under `scripts/`; paths inside scripts are placeholders and should be adapted to local environments.
- CAT-GTR analyses did not reach full convergence; chain-level topologies are summarised descriptively and are not interpreted as posterior consensus support.
