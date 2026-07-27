# Sampling imbalance and contamination explain conflicting archaeal placements of eukaryotes

Data and analysis scripts supporting the manuscript:

**Bias-controlled phylogenomics resolves conflicting archaeal placements of eukaryotes**

This repository archives genome lists, taxonomic counts, phylogenetic marker sets, concatenated alignments, phylogenetic trees, decontamination assessment tables, ESP inventories, viral-detection summaries, and example analysis scripts used in the study.

---

## Repository structure

```text
Asgard_Eukaryote_Data/
├── README.md
├── docs/
│   └── Data_Availability_Statement.md
├── scripts/
│   ├── phylogenomics/          # IQ-TREE, PhyloBayes, AU tests
│   ├── decontamination/        # Primary contamination removal
│   ├── independent_audit/      # Post-hoc multi-evidence audit
│   ├── balancing/              # Hierarchical taxonomic balancing
│   ├── ESP/                    # ESP detection pipeline
│   └── figure_reproduction/    # Scripts and notes for selected figures
└── data/
    ├── data_README.md
    ├── genome_sets/            # Genome accession lists (GS*)
    ├── taxonomic_counts/       # Phylum / class / order counts after balancing
    ├── PMS/                    # Marker composition and overlap
    ├── alignments/             # Concatenated amino-acid supermatrices
    ├── trees/                  # ML, PMSF, CAT-GTR, AU tests
    ├── decontamination/
    │   ├── assessment/         # Contamination frequencies and related summaries
    │   └── phylogenomic_sets/  # Contig-removal summaries for phylogenomic collections
    ├── ESP/                    # ESP presence before / after decontamination
    └── viral_detection_comparison/  # geNomad-related summary tables
```

---

## Genome collections (GS)

| Label in repository | Description |
| --- | --- |
| GS-Zhang2025 | Benchmark set based on Dong/Zhang et al. (sampling-imbalanced) |
| GS-Zhang2025-B | Taxonomically balanced version of GS-Zhang2025 |
| GS-Liu2021 | Benchmark set based on Liu et al. (2021) (sampling-imbalanced) |
| GS-Liu2021-B | Taxonomically balanced version of GS-Liu2021 |
| GS-Present-B | Independently assembled, taxonomically balanced genome set (this study) |

**File suffixes used with alignments and trees**

| Suffix | Meaning |
| --- | --- |
| **raw** | Before primary decontamination |
| **clean** | After primary decontamination |
| **ultra-clean** | After independent post-hoc audit (where applicable) |
| **B** | Taxonomically balanced collection |

Genome accession lists: `data/genome_sets/`  
Taxonomic counts after balancing: `data/taxonomic_counts/`

---

## Phylogenetic marker sets (PMS)

| PMS | Description |
| --- | --- |
| PMS-Isolate | Complete isolate genomes only (strictest contamination control; lowest diversity) |
| PMS-HighMAG1 | Isolates + MIMAG-defined high-quality MAGs after decontamination |
| PMS-HighMAG2 | Isolates + NCBI complete-genome-level MAGs after decontamination |
| PMS-MediumMAG | Isolates + CheckM-defined medium-quality MAGs after decontamination (highest diversity) |

Composition and overlap among the four PMSs:  
`data/PMS/PMS_composition_and_overlap.xlsx`

---

## Key analyses

1. **Contamination assessment** — genome- and lineage-level frequencies of bacterial, eukaryotic, viral and unclassified contaminants, including Asgard order/class summaries and contamination-derived proteins with apparent similarity to eukaryotic homologues (`data/decontamination/assessment/`).
2. **Primary decontamination** — contig removal for phylogenomic genome collections (`data/decontamination/phylogenomic_sets/`).
3. **Factorial phylogenomics** — combinations of genome collections (raw/clean × imbalanced/balanced) and the four PMSs (`data/alignments/`, `data/trees/maximum_likelihood/`).
4. **Topology tests** — approximately unbiased (AU) tests (`data/trees/AU_tests/`).
5. **Bayesian inference** — PhyloBayes MPI under CAT-GTR (multiple independent chains; `data/trees/CAT-GTR/`).
6. **Site-heterogeneous ML (PMSF)** — where applied (`data/trees/PMSF/`).
7. **ESP inventories** — presence before versus after decontamination across Asgard, TACK, Euryarchaeota and DPANN (`data/ESP/`).
8. **Independent post-hoc audit** — multi-evidence residual contamination check (`scripts/independent_audit/`).
9. **Viral detection comparison** — summary tables supporting viral-contaminant analyses (`data/viral_detection_comparison/`).

---

## Software (main)

- IQ-TREE 3 (LG+C60+F+G; PMSF where noted)
- PhyloBayes MPI (CAT-GTR)
- GTDB-Tk, CheckM / CheckM2, CAT, geNomad, VirSorter2, CheckV, GUNC, Whokaryote
- Python 3 (e.g. matplotlib, numpy) for selected figure panels
- R for hierarchical taxonomic balancing and selected Extended Data panels

Example commands are provided under `scripts/`. Paths inside scripts are placeholders and should be adapted to local environments.

---

## Figures

Panel-level notes (scripted versus GraphPad Prism, iTOL, Illustrator or BioRender) are described in:

`scripts/figure_reproduction/figure_reproduction_README.md`

Underlying numerical tables for contamination-frequency and related panels are intended for `data/decontamination/assessment/`.

---

## Citation

Please cite the published article when using these data or scripts. A repository https://doi.org/10.5281/zenodo.21612449, is listed in `docs/Data_Availability_Statement.md`.

---

## License

Data are provided for academic reuse consistent with the journal data policy. Scripts are provided as documentation of the analytical workflow.
```

---
