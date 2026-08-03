# Data availability statement

All data and code supporting the findings of this study are available as follows.

---

## Primary deposits

| Resource | Link | Access |
|:---------|:-----|:-------|
| **Zenodo** | [https://doi.org/10.5281/zenodo.21769162](https://doi.org/10.5281/zenodo.21769162) | Open access |
| **GitHub** | [https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026) | Open access |

The Zenodo deposit archives genome collections, phylogenetic marker sets, concatenated alignments, phylogenetic trees, decontamination assessment tables, taxonomic count tables, ESP inventories, Supplementary Tables and example analysis scripts. The GitHub repository hosts the same materials together with a structured notebook (**Reproducible_Workflow.ipynb**) that maps each major results section to the corresponding deposited datasets and example commands, to support transparent and reproducible inspection of the analyses.

---

## Repository contents

| Content | Location |
|:--------|:---------|
| Supplementary Tables (complete set) | `data/supplementary_tables/` |
| Genome accession lists and GTDB taxonomy for each GS | `data/genome_sets/` |
| Taxonomic counts after hierarchical balancing (phylum / class / order) | `data/taxonomic_counts/` |
| Four independently curated phylogenetic marker sets; composition and overlap | `data/PMS/` |
| Concatenated amino-acid supermatrices | `data/alignments/` |
| Maximum-likelihood, PMSF, CAT-GTR and AU-test outputs | `data/trees/` |
| Contamination assessment tables and primary decontamination / post-hoc audit summaries | `data/decontamination/` |
| ESP / iESP detection counts before and after decontamination | `data/ESP/` |
| Viral-detection comparison summaries | `data/viral_detection_comparison/` |
| Example analysis scripts (phylogenomics, decontamination, balancing, ESP, independent audit) | `scripts/` |
| Reproducible workflow notebook | `Reproducible_Workflow.ipynb` |
| Figure-panel production notes | `scripts/figure_reproduction/figure_reproduction_README.md` |

Overview of the `data/` layout: `data/data_README.md`.  
Index of Supplementary Tables: `data/supplementary_tables/README.md`.

---

## External sequence data

Public isolate genomes and metagenome-assembled genomes (MAGs) were obtained from NCBI RefSeq/GenBank and from the additional public sources listed in the genome-list tables. Accession numbers and GTDB taxonomic assignments are provided in `data/genome_sets/` and in Supplementary Tables 1–5.

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

Example commands and workflows are provided under `scripts/` to document the analytical pipeline. Paths inside scripts are placeholders and should be adapted to local computing environments. Software used for the primary analyses is listed in the Methods section of the manuscript and in the repository root `README.md`.

A structured notebook (**Reproducible_Workflow.ipynb**) maps each major results section to the corresponding deposited datasets, trees and example commands, and is available in the project repository to support transparent and reproducible inspection of the analyses:

[https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

---

## Key deposited result

Under simultaneous control of both genome contamination and taxonomic sampling imbalance, all 12 genome-set × marker-set analyses recovered eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation. Alignments, trees and summary tables supporting this result are deposited as described above.
