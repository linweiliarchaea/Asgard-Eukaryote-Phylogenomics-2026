# Contamination and taxon sampling explain conflicting eukaryote placements

[![Status](https://img.shields.io/badge/Status-Submitted%20to%20Nature-C41E3A)](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026)

Data, alignments, trees, supplementary tables and analysis scripts accompanying the manuscript.

---

## Overview

The archaeal origin of eukaryotes remains unresolved. Phylogenomic studies have placed eukaryotes within or near different Asgard lineages, often with strong statistical support for mutually incompatible topologies. This repository supports a study showing that much of this conflict arises from two upstream biases in MAG-based phylogenomics—genome contamination and taxonomic sampling imbalance—rather than from alternative historical signals.

When both biases are controlled, twelve independent analyses (three balanced genome sets × four independently curated marker sets) converge on a single topology: eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation, outside all currently sampled Asgard subgroups.

---

## Main result

**Full-control condition** (contamination removed + taxonomic sampling balanced):

> Eukaryotes are recovered as sister to a monophyletic TACK–Asgard radiation in all 12 genome-set × marker-set combinations.

Contamination primarily increases disagreement among marker sets. Sampling imbalance generates recurrent directional attraction toward particular archaeal lineages. Only simultaneous control of both biases produces topological consistency across independently curated marker sets.

---

## Genome collections

| Genome set | Description | Sampling |
|---|---|---|
| GS-Zhang2025 | Zhang *et al.* (2025) benchmark | Imbalanced |
| GS-Liu2021 | Liu *et al.* (2021) benchmark | Imbalanced |
| GS-Zhang2025-B | Balanced version of GS-Zhang2025 | Balanced |
| GS-Liu2021-B | Balanced version of GS-Liu2021 | Balanced |
| GS-Present-B | Independently constructed balanced collection | Balanced |

Raw (contaminated) and clean (decontaminated) versions of each collection were analysed in parallel.

---

## Phylogenetic marker sets

| Marker set | Source genomes | Proteins |
|---|---|---|
| PMS-Isolate | Complete isolate genomes only | 35 |
| PMS-HighMAG1 | Isolates + MIMAG high-quality MAGs | 34 |
| PMS-HighMAG2 | Isolates + NCBI complete-genome-level MAGs | 32 |
| PMS-MediumMAG | Isolates + CheckM medium-quality MAGs (≥70% / ≤10%) | 30 |

Candidate marker families were examined in single-protein trees before concatenation. Families showing HGT-like or anomalous domain-level clustering were excluded. The four sets share a core of 28 markers but are not strictly nested, allowing agreement across independently curated gene sets to serve as a robustness criterion.

---

## Repository structure

```
.
├── README.md
├── Reproducible_Workflow.ipynb
├── data/
│   ├── genome_sets/           # Final genome lists (raw & clean)
│   ├── taxonomic_counts/      # Phylum / class / order counts
│   ├── PMS/                   # Marker composition lists
│   ├── alignments/            # Concatenated alignments
│   ├── trees/                 # ML and AU tree files
│   ├── decontamination/       # Contamination calls & post-hoc audit
│   ├── ESP/                   # ESP inventories before/after decontamination
│   └── supplementary_tables/  # Supplementary tables (CSV)
└── scripts/
    ├── balancing/
    ├── decontamination/
    ├── phylogenomics/
    ├── independent_audit/
    ├── ESP/
    └── figure_reproduction/
```

Scripts under `scripts/` are templates with placeholder paths. Published results are defined by the files under `data/`.

---

## Reproducible workflow

Interactive notebook: [`Reproducible_Workflow.ipynb`](./Reproducible_Workflow.ipynb)

| Section | Content | Location |
|---|---|---|
| A | Contamination landscape across archaeal MAGs | `data/decontamination/` |
| B | Bias-controlled phylogenomics (ML, AU, CAT-GTR, post-hoc audit) | `data/genome_sets/`, `data/PMS/`, `data/alignments/`, `data/trees/` |
| C | ESP inventories before versus after decontamination | `data/ESP/` |

Online view: [nbviewer](https://nbviewer.org/github/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

---

## Data availability

- Analysis scripts and the reproducible notebook are available in this repository:  
  **https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026**

---

## Citation

Lin, W. *et al.* Contamination and taxon sampling explain conflicting eukaryote placements. Submitted to *Nature* (2026).  

---

## License

Data and scripts are released for academic reuse in accordance with the manuscript and the licenses of upstream databases (NCBI, GTDB) and software authors.
