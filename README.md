# Sampling imbalance and contamination explain conflicting archaeal placements of eukaryotes

Data and analysis scripts supporting the manuscript:

**Bias-controlled phylogenomics resolves conflicting archaeal placements of eukaryotes**

This repository archives genome lists, phylogenetic marker sets, alignments, trees, decontamination assessment tables, ESP inventories, and example analysis scripts used in the study.

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
│   └── figure_reproduction/    # Scripts and notes for main figures
└── data/
    ├── genome_sets/            # Genome accession lists (GS*)
    ├── taxonomic_counts/       # Phylum/class/order counts after balancing
    ├── PMS/                    # Marker composition and overlap
    ├── alignments/             # Concatenated amino-acid supermatrices
    ├── trees/                  # ML, PMSF, CAT-GTR, AU tests
    ├── decontamination/        # Assessment + removed-contig summaries
    └── ESP/                    # ESP presence before/after decontamination
```

## Genome collections (GS)

| Label in repository | Description |
| --- | --- |
| GS-Zhang2025 | Benchmark set based on Dong/Zhang et al. (sampling-imbalanced) |
| GS-Zhang2025-B | Taxonomically balanced version of GS-Zhang2025 |
| GS-Liu2021 | Benchmark set based on Liu et al. 2021 (sampling-imbalanced) |
| GS-Liu2021-B | Taxonomically balanced version of GS-Liu2021 |
| GS-Present-B | Independently assembled, taxonomically balanced genome set (this study) |

**Suffixes:**

- **raw** — before primary decontamination
- **clean** — after primary decontamination

## Phylogenetic marker sets (PMS)

| PMS | Description |
| --- | --- |
| PMS-Isolate | Complete isolate genomes only (strictest contamination control; lowest diversity) |
| PMS-HighMAG1 | Isolates + MIMAG-defined high-quality MAGs after decontamination |
| PMS-HighMAG2 | Isolates + NCBI complete-genome-level MAGs after decontamination |
| PMS-MediumMAG | Isolates + CheckM medium-quality MAGs after decontamination (highest diversity) |

Marker composition and overlap: `data/PMS/PMS_composition_and_overlap.xlsx`

## Key analyses

1. **Contamination assessment** — genome- and lineage-level frequencies (`data/decontamination/assessment/`)
2. **Primary decontamination** — contig removal summaries (`data/decontamination/phylogenomic_sets/`)
3. **Factorial phylogenomics** — all combinations of GS (raw/clean × imbalanced/balanced) × four PMSs
4. **Topology tests** — Approximately Unbiased (AU) tests (`data/trees/AU_tests/`)
5. **Bayesian inference** — PhyloBayes MPI CAT-GTR (10 chains; `data/trees/CAT-GTR/`)
6. **ESP inventories** — before vs after decontamination (`data/ESP/`)
7. **Independent post-hoc audit** — multi-evidence residual contamination check

## Software (main)

- IQ-TREE 3 (LG+C60+F+G; PMSF where noted)
- PhyloBayes MPI (CAT-GTR)
- GTDB-Tk, CheckM/CheckM2, CAT, geNomad, VirSorter2, CheckV, GUNC, Whokaryote
- Python 3 (matplotlib, numpy) for selected figure panels
- R (balancing script)

Exact commands are recorded as example scripts under `scripts/`. Paths inside scripts are placeholders and should be adapted to local environments.

## Figures

See `scripts/figure_reproduction/README.md` for panel-by-panel notes (scripted vs Prism / iTOL / Illustrator / BioRender).

## Citation

Please cite the published article when using these data or scripts. Repository DOI (Zenodo), if available, will be listed in `docs/Data_Availability_Statement.md`.

## License

Data are provided for academic reuse consistent with the journal data policy. Scripts are provided as documentation of the analytical workflow.
