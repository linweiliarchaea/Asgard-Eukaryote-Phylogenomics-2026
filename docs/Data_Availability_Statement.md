# Data availability statement

All data and code supporting the findings of this study are available as follows.

---

## This repository

Genome collections, phylogenetic marker sets, concatenated alignments, phylogenetic trees, decontamination assessment tables, taxonomic count tables, ESP inventories, viral-detection summaries, and example analysis scripts are deposited in this repository:

**https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026**

(Update the URL if the repository is transferred to another institutional account.)

**Key contents**

| Content | Path |
| --- | --- |
| Genome accession lists (GS-Zhang2025, GS-Liu2021, GS-Present-B and balanced **-B** derivatives) | `data/genome_sets/` |
| Taxonomic counts after hierarchical balancing (phylum / class / order) | `data/taxonomic_counts/` |
| Four phylogenetic marker sets; composition and overlap | `data/PMS/` |
| Concatenated amino-acid supermatrices | `data/alignments/` |
| Maximum-likelihood, PMSF, CAT-GTR and AU-test outputs | `data/trees/` |
| Contamination assessment tables and primary decontamination / post-hoc audit summaries | `data/decontamination/` |
| ESP / iESP detection counts before and after decontamination | `data/ESP/` |
| Viral-detection comparison summaries | `data/viral_detection_comparison/` |
| Example analysis scripts (phylogenomics, decontamination, balancing, ESP, independent audit) | `scripts/` |
| Figure-panel production notes | `scripts/figure_reproduction/figure_reproduction_README.md` |

Overview of the `data/` layout: `data/data_README.md`.

---

## Archival DOI (recommended)

Upon submission or acceptance, a frozen release of this repository should be archived at Zenodo (or an equivalent repository). Insert the DOI below when available:

- Zenodo DOI: `https://doi.org/10.5281/zenodo.21612449` 

---

## External sequence data

Public isolate genomes and MAGs were obtained from NCBI RefSeq/GenBank and from the additional public sources listed in the genome-list tables. Accession numbers and GTDB taxonomic assignments are provided in `data/genome_sets/`.

---

## Source data for figures

Summary statistics underlying main and Extended Data figures are included in:

- `data/decontamination/assessment/`
- `data/ESP/`
- `data/viral_detection_comparison/`
- tree files under `data/trees/`

Panel-level notes on scripted versus manually assembled displays (GraphPad Prism, iTOL, Adobe Illustrator, BioRender) are given in:

`scripts/figure_reproduction/figure_reproduction_README.md`

---

## Code availability

Example commands and workflows are provided under `scripts/` for documentation of the analytical pipeline. Paths inside scripts are placeholders and should be adapted to local computing environments. Software versions used for the primary analyses are listed in the Methods section of the manuscript and in the repository root `README.md`.
```

