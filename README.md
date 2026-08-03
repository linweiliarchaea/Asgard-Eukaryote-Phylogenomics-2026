# Contamination and taxon sampling explain conflicting eukaryote placements

<p align="center">
  <a href="https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026"><img src="https://img.shields.io/badge/Status-Submitted%20to%20Nature-C41E3A?style=flat-square" alt="Status"></a>
  <a href="https://doi.org/10.5281/zenodo.21769162"><img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21769162-blue?style=flat-square" alt="DOI"></a>
  <a href="./Reproducible_Workflow.ipynb"><img src="https://img.shields.io/badge/Notebook-Reproducible%20Workflow-2ea44f?style=flat-square" alt="Notebook"></a>
</p>

<p align="center">
  <b>Data · Alignments · Trees · Scripts</b><br>
  accompanying the manuscript submitted to <i>Nature</i>
</p>

---

## Contents

- [Overview](#overview)
- [Main result](#main-result)
- [Genome collections](#genome-collections)
- [Phylogenetic marker sets](#phylogenetic-marker-sets)
- [Repository structure](#repository-structure)
- [Reproducible workflow](#reproducible-workflow)
- [Data availability](#data-availability)
- [Citation](#citation)

---

## Overview

The archaeal origin of eukaryotes remains unresolved. Phylogenomic studies have placed eukaryotes within or near different Asgard lineages, often with strong statistical support for mutually incompatible topologies.

This repository supports a study showing that much of this conflict arises from two upstream biases in MAG-based phylogenomics:

1. **Genome contamination**
2. **Taxonomic sampling imbalance**

rather than from alternative historical signals.

When both biases are controlled, **twelve independent analyses** (three balanced genome sets × four independently curated marker sets) converge on a single topology:

> **Eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation,**  
> outside all currently sampled Asgard subgroups.

---

## Main result

**Full-control condition** — contamination removed **and** taxonomic sampling balanced:

| | |
|:--|:--|
| **Topology** | Eukaryotes sister to monophyletic TACK–Asgard |
| **Support** | Recovered in **all 12** genome-set × marker-set combinations |
| **Interpretation** | Outside currently sampled Asgard subgroups |

| Source of bias | Effect on phylogenetic inference |
|:---------------|:---------------------------------|
| Contamination | Increases disagreement among independently curated marker sets |
| Sampling imbalance | Generates recurrent directional attraction toward particular archaeal lineages |
| Both controlled | Topological consistency across marker sets |

Only simultaneous control of both biases produces a stable placement of eukaryotes.

---

## Genome collections

| Genome set | Description | Sampling |
|:-----------|:------------|:--------:|
| **GS-Zhang2025** | Zhang *et al.* (2025) benchmark | Imbalanced |
| **GS-Liu2021** | Liu *et al.* (2021) benchmark | Imbalanced |
| **GS-Zhang2025-B** | Balanced version of GS-Zhang2025 | Balanced |
| **GS-Liu2021-B** | Balanced version of GS-Liu2021 | Balanced |
| **GS-Present-B** | Independently constructed balanced collection | Balanced |

Raw (**contaminated**) and clean (**decontaminated**) versions of each collection were analysed in parallel.

---

## Phylogenetic marker sets

| Marker set | Source genomes | Proteins |
|:-----------|:---------------|--------:|
| **PMS-Isolate** | Complete isolate genomes only | 35 |
| **PMS-HighMAG1** | Isolates + MIMAG high-quality MAGs | 34 |
| **PMS-HighMAG2** | Isolates + NCBI complete-genome-level MAGs | 32 |
| **PMS-MediumMAG** | Isolates + CheckM medium-quality MAGs (≥70% / ≤10%) | 30 |

- Candidate marker families were examined in single-protein trees before concatenation.
- Families showing HGT-like or anomalous domain-level clustering were excluded.
- The four sets share a core of **28 markers** but are not strictly nested.
- Agreement across independently curated gene sets is used as a robustness criterion.

---

## Repository structure

```text
.
├── README.md
├── Reproducible_Workflow.ipynb
│
├── data/
│   ├── genome_sets/           # Final genome lists (raw & clean)
│   ├── taxonomic_counts/      # Phylum / class / order counts
│   ├── PMS/                   # Marker composition lists
│   ├── alignments/            # Concatenated alignments
│   ├── trees/                 # ML and AU tree files
│   ├── decontamination/       # Contamination calls & post-hoc audit
│   ├── ESP/                   # ESP inventories before/after decontamination
│   └── supplementary_tables/  # Supplementary tables (CSV)
│
└── scripts/
    ├── balancing/
    ├── decontamination/
    ├── phylogenomics/
    ├── independent_audit/
    ├── ESP/
    └── figure_reproduction/
```

> **Note:** Scripts under `scripts/` are templates with placeholder paths.  
> Published numerical results are defined by the files under `data/`.

---

## Reproducible workflow

**Notebook:** [Reproducible_Workflow.ipynb](./Reproducible_Workflow.ipynb)  
**Online view:** [nbviewer](https://nbviewer.org/github/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

| Section | Content | Data location |
|:-------:|:--------|:--------------|
| **A** | Contamination landscape across archaeal MAGs | `data/decontamination/` |
| **B** | Bias-controlled phylogenomics<br>(ML · AU · CAT-GTR · post-hoc audit) | `data/genome_sets/` · `data/PMS/` · `data/alignments/` · `data/trees/` |
| **C** | ESP inventories before vs after decontamination | `data/ESP/` |

---

## Data availability

| Resource | Link | Access |
|:---------|:-----|:-------|
| **Zenodo** | [10.5281/zenodo.21769162](https://doi.org/10.5281/zenodo.21769162) | Open access |
| **GitHub** | [tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026) | Analysis scripts and reproducible notebook |

---

## Citation

```text
Lin, W. et al. Contamination and taxon sampling explain conflicting
eukaryote placements. Submitted to Nature (2026).
Data and code: https://doi.org/10.5281/zenodo.21769162
```

---

## License

Data and scripts are released for academic reuse in accordance with the manuscript and the licenses of upstream databases (NCBI, GTDB) and software authors.
