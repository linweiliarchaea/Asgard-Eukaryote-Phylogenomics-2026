# Figure reproduction notes

This folder documents how main-figure panels were produced for:

**Contamination and taxon sampling explain conflicting eukaryote placements**

**Numerical results are defined by the deposited tables and tree files.**  
Display-only steps (iTOL, Adobe Illustrator, GraphPad Prism, BioRender) are described so that each panel can be matched to its source data. Pixel-identical layout is not required for verification.

Paths below are relative to the repository root unless noted.

---

## Scripted panels (Python / R)

| Panel | Script | Primary data source |
| --- | --- | --- |
| Fig. 1a | `fig1a_contamination_frequency.py` | `data/decontamination/assessment/` (lineage-level contamination frequencies; isolate vs MAG) |
| Fig. 1c | `fig1c_contamination_derived_eukaryote_like_proteins.py` | `data/decontamination/assessment/` (contamination-derived eukaryote-like protein frequencies by group) |
| Fig. 3d | `fig3d_au_topology_test.py` | `data/trees/AU_tests/` (IQ-TREE AU output; *P*-values used in the panel) |
| Extended Data (viral call overlap) | `plot_extended_data_fig1_venn.R` | `data/viral_detection_comparison/summary_venn_counts.xlsx` |

**Python dependencies**

```bash
pip install matplotlib numpy
```

**R dependency (Euler diagrams)**

```r
install.packages("eulerr")
```

**Run** (from this directory, or adjust paths):

```bash
python fig1a_contamination_frequency.py
python fig1c_contamination_derived_eukaryote_like_proteins.py
python fig3d_au_topology_test.py
Rscript plot_extended_data_fig1_venn.R
```

Scripts may embed summary percentages for layout; values must match the deposited assessment tables.

---

## Manually assembled panels

### Fig. 1b

- **Software:** GraphPad Prism  
- **Data:** `data/decontamination/assessment/` (Asgard class- or order-level contamination frequencies)  
- **Note:** Summary frequencies plotted in Prism. No custom analysis script. Candidate closest-relative lineages (e.g. Hodarchaeales, Njordarchaeales) are among those with elevated contamination.

### Fig. 2 (topology panels)

- **Topology source:** `data/trees/maximum_likelihood/*.contree`  
- **Display:** iTOL, then finalized in Adobe Illustrator (colours, labels, layout)  
- **Note:** Branching order and ultrafast bootstrap support are defined by the deposited `.contree` files. No topological editing beyond graphical presentation.

**Panel–dataset correspondence** (factorial design: contamination × sampling balance × four PMSs):

| Panels | Content |
| --- | --- |
| Fig. 2a–d | GS-Zhang2025-raw × each PMS (contamination present; sampling imbalanced) |
| Fig. 2e–h | GS-Zhang2025-B-raw × each PMS (contamination present; sampling balanced) |
| Fig. 2i–l | GS-Zhang2025-clean × each PMS (decontaminated; sampling imbalanced) |
| Fig. 2m–p | GS-Zhang2025-B-clean × each PMS (full control: decontaminated and sampling balanced) |

File names follow `GS-*-raw|clean_*_PMS-*.contree` under `data/trees/maximum_likelihood/`.  
Only under simultaneous control of both biases (Fig. 2m–p) do all four PMSs converge on eukaryotes as sister to a monophyletic TACK–Asgard clade.

### Fig. 3a–c

#### Fig. 3a

- **Content:** Maximum-likelihood robustness using an independently audited ultra-clean genome collection.  
- **Topology source:** IQ-TREE consensus trees from the post-hoc audited (ultra-clean) dataset under `data/trees/maximum_likelihood/` (files matching `*ultra-clean*` and the GS × PMS combination shown).  
- **Supporting tables:** `data/trees/robustness_analyses.xlsx`; post-hoc audit summaries under `data/decontamination/` when deposited.  
- **Display:** iTOL → Adobe Illustrator.  
- **Note:** Additional contig removal at the audit stage was <0.8% per archaeal group and did not alter the main topology.

#### Fig. 3b

- **Content:** Maximum-likelihood analyses under expanded archaeal taxon sampling.  
- **Topology source:** IQ-TREE consensus trees from expanded-sampling collections (corresponding alignments under `data/alignments/` and `.contree` under `data/trees/maximum_likelihood/`).  
- **Display:** iTOL → Adobe Illustrator.

#### Fig. 3c

- **Content:** Maximum-likelihood analysis under the alternative site-heterogeneous PMSF approximation.  
- **Topology source:** `data/trees/PMSF/` (files matching the GS × PMS combination shown).  
- **Display:** iTOL → Adobe Illustrator.

**Note (Fig. 3a–c):** Deposited `.contree` files are authoritative for branching order and nodal support. Illustrator was used only for labelling and layout.

### Fig. 3e

- **Software:** GraphPad Prism  
- **Data:** Bayesian chain-level topology summaries (`data/trees/robustness_analyses.xlsx`; trees under `data/trees/CAT-GTR/`)  
- **Note:** Ten independent PhyloBayes CAT-GTR chains; plotted from deposited summary counts (e.g. 7/10 recovering TACK–Asgard + eukaryotes). Chain-level topologies are descriptive only because full convergence was not achieved. No custom script.

### Fig. 4a

- **Software:** GraphPad Prism  
- **Data:** `data/ESP/ESP_*_before_after_decontamination.xlsx`  
- **Note:** Counts of contamination-sensitive ESPs (lost or reduced after decontamination) by archaeal group. Asgard contributes the largest number of affected ESPs.

### Fig. 4b–c

- **Software:** GraphPad Prism (quantitative elements); BioRender where schematic icons are used  
- **Data:** `data/ESP/` before/after tables  
- **Note:** Numerical values from deposited ESP tables; schematic elements from BioRender where applicable. Panels illustrate inventory-level contamination sensitivity and are not used to infer ancestral gain–loss histories.

---

## Extended Data and Supplementary figures (selected)

| Figure | Software | Data / notes |
| --- | --- | --- |
| PMS construction workflow | BioRender | Conceptual schematic; marker counts and overlap in `data/PMS/` (e.g. PMS composition tables) |
| Contamination vs assembly/quality metrics | GraphPad Prism | `data/decontamination/assessment/` (e.g. contamination vs N50, CheckM metrics) |
| Asgard class/order contamination or contamination-derived eukaryote-like proteins | GraphPad Prism | `data/decontamination/assessment/` (lineage-level tables) |
| Viral detection set overlaps (geNomad vs Phager) | R (`plot_extended_data_fig1_venn.R`) | `data/viral_detection_comparison/summary_venn_counts.xlsx` |

BioRender is used for schematic illustration only; it is not required to regenerate numerical panels. A journal-style attribution (e.g. "Created with BioRender.com") may be placed in Acknowledgements or Methods if required by the publisher.

---

## Related analysis scripts (repository)

| Script | Role |
| --- | --- |
| `scripts/decontamination/run_decontamination.sh` | Primary decontamination (CAT + geNomad) |
| `scripts/independent_audit/independent_audit.sh` | Post-hoc multi-evidence audit (GUNC, VirSorter2, CheckV, Whokaryote) |
| `scripts/phylogenomics/run_iqtree_ml.sh` | MAFFT → BMGE → IQ-TREE 3 (LG+C60+F+G, UFBoot) |
| `scripts/phylogenomics/run_au_topology_tests.sh` | AU tests of competing eukaryotic placements |
| `scripts/phylogenomics/run_phylobayes.sh` | CAT-GTR sensitivity analysis (10 chains) |
| `scripts/ESP/run_ESP_pipeline.sh` | DIAMOND + HMMER ESP/iESP detection |

---

## General principles

1. **Trees:** Always prefer deposited `.contree` / PhyloBayes tree files over illustrated topologies.  
2. **Contamination and ESP counts:** Prefer tables under `data/decontamination/assessment/` and `data/ESP/`.  
3. **Scripts in this folder** reproduce selected bar/lollipop-style panels; multi-panel phylogenies and most Prism figures are documented rather than fully scripted.  
4. File names may use `.xlsx` or `.csv` interchangeably if both formats are deposited; column meanings are described in `data/data_README.md`.  
5. Primary phylogenetic inference is contamination-controlled maximum-likelihood analysis plus topology tests; Bayesian CAT-GTR results are supportive and summarized at the chain level only.
