# Data availability statement

All data and code supporting the findings of this study are available as follows.

---

## Primary deposits

| Resource | Link | Access |
|:---------|:-----|:-------|
| **Zenodo** | [10.5281/zenodo.21798197](https://doi.org/10.5281/zenodo.21798197) | Open access |
| **GitHub** | [https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026) | Open access |

The Zenodo deposit archives genome collections, phylogenetic marker sets, concatenated alignments, phylogenetic trees, decontamination assessment tables, taxonomic count tables, ESP inventories, Supplementary Tables and example analysis scripts. The GitHub repository hosts the same materials together with a structured notebook (**Reproducible_Workflow.ipynb**) that maps each major results section to the corresponding deposited datasets and the complete example scripts used in the study, to support transparent and reproducible inspection of the analyses.

---

## Repository contents

| Content | Location |
|:--------|:---------|
| Supplementary Tables (complete set) | `data/supplementary_tables/` |
| Genome accession lists and GTDB taxonomy for each genome set (GS) | `data/genome_sets/` |
| Taxonomic counts after hierarchical balancing (phylum / class / order) | `data/taxonomic_counts/` |
| Four independently curated phylogenetic marker sets (PMS-Isolate, PMS-HighMAG1, PMS-HighMAG2, PMS-MediumMAG); composition and overlap | `data/PMS/` |
| Concatenated amino-acid supermatrices | `data/alignments/` |
| Maximum-likelihood (LG+C60+F+G), PMSF, CAT-GTR and AU-test outputs | `data/trees/` |
| Contamination assessment tables; primary decontamination and post-hoc audit summaries | `data/decontamination/` |
| ESP / iESP detection counts before and after decontamination | `data/ESP/` |
| Viral-detection comparison summaries (geNomad vs Phager) | `data/viral_detection_comparison/` |
| Example analysis scripts (decontamination, hierarchical balancing, phylogenomics, independent audit, ESP detection, figure reproduction) | `scripts/` |
| Reproducible workflow notebook (full scripts embedded with study logic) | `Reproducible_Workflow.ipynb` |
| Figure-panel production notes | `scripts/figure_reproduction/figure_reproduction_README.md` |

Overview of the `data/` layout: `data/data_README.md`.  
Index of Supplementary Tables: `data/supplementary_tables/README.md`.

Genome sets analysed in the manuscript comprise:

- **GS-Zhang2025** / **GS-Zhang2025-B** — Zhang et al. (2025) collection and its taxonomically balanced version  
- **GS-Liu2021** / **GS-Liu2021-B** — Liu et al. (2021) collection and its taxonomically balanced version  
- **GS-Present-B** — independently assembled, taxonomically balanced collection (this study)

Raw and decontaminated (clean) versions of each collection were analysed in parallel. Accession numbers and GTDB assignments are provided in Supplementary Tables 1–5 and under `data/genome_sets/`.

---

## External sequence data

Public isolate genomes and metagenome-assembled genomes (MAGs) were obtained from NCBI RefSeq/GenBank and from the additional public sources listed in the genome-list tables. Accession numbers and GTDB taxonomic assignments are provided in `data/genome_sets/` and in Supplementary Tables 1–5. Full raw FASTA assemblies are not re-hosted in this repository; they can be retrieved from the public databases using the deposited accession lists.

---

## Source data for figures

Summary statistics underlying main and Extended Data figures are included in:

- `data/decontamination/assessment/` — lineage-level contamination frequencies and contaminant-derived eukaryote-like protein counts (**Fig. 1**; Extended Data contamination figures)
- `data/viral_detection_comparison/` — geNomad vs Phager call overlap (**Extended Data Fig. 1**)
- `data/trees/` — maximum-likelihood, PMSF, CAT-GTR and AU-test outputs (**Fig. 2–3**; Extended Data Tables 2–3)
- `data/ESP/` — ESP / iESP counts before and after decontamination (**Fig. 4**)

Panel-level notes on scripted versus manually assembled displays (GraphPad Prism, iTOL, Adobe Illustrator, BioRender) are given in:

`scripts/figure_reproduction/figure_reproduction_README.md`

---

## Code availability

Example commands and complete workflow scripts are provided under `scripts/` to document the analytical pipeline, including:

- primary decontamination (CAT + geNomad) and companion R utilities  
- hierarchical taxonomic balancing  
- maximum-likelihood phylogenomics (MAFFT → BMGE → IQ-TREE 3)  
- approximately unbiased (AU) topology tests  
- Bayesian CAT-GTR sensitivity analysis (PhyloBayes MPI; ten independent chains)  
- independent post-hoc contamination audit (GUNC, VirSorter2, CheckV, Whokaryote)  
- ESP / iESP detection (DIAMOND + HMMER)  
- figure-reproduction scripts for selected panels  

Paths inside scripts are placeholders and should be adapted to local computing environments. Software used for the primary analyses is listed in the Methods section of the manuscript and in the repository root `README.md`.

A structured notebook (**Reproducible_Workflow.ipynb**) embeds the complete example scripts in study order (contamination landscape → phylogenomics → ESP inventories) and maps each major results section to the corresponding deposited datasets and trees:

[https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

---

## Key deposited result

Under simultaneous control of genome contamination and taxonomic sampling imbalance, all 12 genome-set × marker-set analyses recovered eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation, outside currently sampled Asgard subgroups. Alignments, trees and summary tables supporting this result—including contigs-removed percentages for primary decontamination (Extended Data Table 2), AU test statistics (Extended Data Table 3) and chain-level CAT-GTR summaries—are deposited as described above.
