# Contamination and taxon sampling explain conflicting eukaryote placements

<p align="center">
  <a href="https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026"><img src="https://img.shields.io/badge/Status-Data%20%26%20code-6B7280?style=flat-square" alt="Data"></a>
  <a href="./Reproducible_Workflow.ipynb"><img src="https://img.shields.io/badge/Notebook-Reproducible%20Workflow-2ea44f?style=flat-square" alt="Notebook"></a>
  <a href="./docs/Data_Availability_Statement.md"><img src="https://img.shields.io/badge/Data-Availability-0A66C2?style=flat-square" alt="Data availability"></a>
</p>

<p align="center">
  <b>Data · Alignments · Trees · Scripts</b><br>
  accompanying the manuscript
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

rather than from alternative historical signals alone.

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
| Sampling imbalance | Generates recurrent directional attraction toward particular archaeal lineages (e.g. Korarchaeia) |
| Both controlled | Topological consistency across marker sets |

Only simultaneous control of both biases produces a stable placement of eukaryotes. Independent tests (post-hoc contamination audit, expanded taxon sampling, PMSF, AU topology tests, and ten CAT-GTR chains) support the same relationship; Bayesian chain-level results are summarised descriptively because full convergence was not achieved under CAT-GTR.

---

## Genome collections

| Genome set | Description | Sampling |
|:-----------|:------------|:--------:|
| **GS-Zhang2025** | Zhang *et al.* (2025) benchmark | Imbalanced |
| **GS-Liu2021** | Liu *et al.* (2021) benchmark | Imbalanced |
| **GS-Zhang2025-B** | Balanced version of GS-Zhang2025 | Balanced |
| **GS-Liu2021-B** | Balanced version of GS-Liu2021 | Balanced |
| **GS-Present-B** | Independently constructed balanced collection (this study) | Balanced |

Raw (**contaminated**) and clean (**decontaminated**) versions of each collection were analysed in parallel. Hierarchical balancing brought **Asgard and TACK** to comparable representation, with Euryarchaeota and DPANN retained at modestly lower numbers.

Accession lists and GTDB taxonomy: `data/genome_sets/` and Supplementary Tables 1–5.  
Taxonomic counts after balancing: `data/taxonomic_counts/`.

---

## Phylogenetic marker sets

| Marker set | Source genomes | Proteins |
|:-----------|:---------------|--------:|
| **PMS-Isolate** | Complete isolate genomes only | 35 |
| **PMS-HighMAG1** | Isolates + MIMAG high-quality MAGs | 34 |
| **PMS-HighMAG2** | Isolates + NCBI complete-genome-level MAGs | 32 |
| **PMS-MediumMAG** | Isolates + CheckM medium-quality MAGs (≥70% complete / ≤10% contamination) | 30 |

- MAG sequences were decontaminated before marker selection.
- Candidate families were examined in **single-protein trees** before concatenation; HGT-like or anomalous domain-level clustering led to exclusion.
- The four sets share a core of **28 markers** but are not strictly nested.
- Agreement across independently curated gene sets is used as a **robustness criterion**, not as an assumption of correctness.

Composition and overlap: `data/PMS/PMS_composition_and_overlap.xlsx`.

---

## Repository structure

```text
.
├── README.md
├── Reproducible_Workflow.ipynb
├── docs/
│   └── Data_Availability_Statement.md
│
├── data/
│   ├── data_README.md
│   ├── genome_sets/              # Accession + GTDB lists (GS-*)
│   ├── taxonomic_counts/         # Phylum / class / order counts (balanced GS)
│   ├── PMS/                      # Marker composition and overlap
│   ├── alignments/               # Concatenated amino-acid supermatrices
│   ├── trees/
│   │   ├── maximum_likelihood/   # IQ-TREE .contree (LG+C60+F+G)
│   │   ├── PMSF/                 # Alternative site-heterogeneous ML
│   │   ├── CAT-GTR/              # PhyloBayes chain-level trees
│   │   ├── AU_tests/             # Constraint topologies and AU output
│   │   └── robustness_analyses.xlsx
│   ├── decontamination/
│   │   ├── assessment/           # Fig. 1 source tables (frequencies, lineages)
│   │   └── phylogenomic_sets/    # Contigs removed (%); post-hoc audit
│   ├── ESP/                      # ESP/iESP counts before vs after decontamination
│   ├── viral_detection_comparison/  # geNomad vs Phager summaries
│   └── supplementary_tables/     # Supplementary Tables 1–21 (.xlsx)
│
└── scripts/
    ├── balancing/                # Hierarchical taxonomic balancing (R)
    ├── decontamination/          # CAT + geNomad primary decontamination
    ├── phylogenomics/            # IQ-TREE ML, AU tests, PhyloBayes CAT-GTR
    ├── independent_audit/        # GUNC / VirSorter2 / CheckV / Whokaryote
    ├── ESP/                      # DIAMOND + HMMER ESP/iESP detection
    └── figure_reproduction/      # Selected panel scripts + notes
```

> **Note:** Scripts under `scripts/` are **example templates** with placeholder paths.  
> Published numerical results are defined by the files under `data/`.

---

## Reproducible workflow

**Notebook:** [Reproducible_Workflow.ipynb](./Reproducible_Workflow.ipynb)  
**Online view:** [nbviewer](https://nbviewer.org/github/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

The notebook follows the manuscript logic and embeds the **complete example scripts** in order:

| Section | Content | Data location |
|:-------:|:--------|:--------------|
| **A** | Contamination landscape across archaeal MAGs (Fig. 1) | `data/decontamination/assessment/` |
| **B** | Bias-controlled phylogenomics — balancing, four PMSs, ML factorial design, AU, CAT-GTR, post-hoc audit (Fig. 2–3) | `data/genome_sets/` · `data/PMS/` · `data/alignments/` · `data/trees/` |
| **C** | ESP inventories before vs after decontamination (Fig. 4) | `data/ESP/` |

Figure-panel production notes (scripted vs Prism / iTOL / Illustrator / BioRender):  
[`scripts/figure_reproduction/figure_reproduction_README.md`](./scripts/figure_reproduction/figure_reproduction_README.md)

---

## Data availability

| Resource | Link | Access |
|:---------|:-----|:-------|
| **GitHub** | [tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026) | Open access |
| **Zenodo** | DOI to be assigned upon deposition | Open access (planned) |

Full statement: [`docs/Data_Availability_Statement.md`](./docs/Data_Availability_Statement.md)

Public isolate genomes and MAGs were obtained from NCBI and the additional sources listed in the genome-list tables. Accession numbers are provided in `data/genome_sets/` and Supplementary Tables 1–5; full raw FASTA assemblies are not re-hosted here.

---

## Citation

```text
Lin, W. et al. Contamination and taxon sampling explain conflicting
eukaryote placements. (2026).
Code and data: https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026
```

Update the citation with the Zenodo DOI once the archive is published.

---

## License

Data and scripts are released for academic reuse in accordance with the manuscript and the licenses of upstream databases (NCBI, GTDB) and software authors.
