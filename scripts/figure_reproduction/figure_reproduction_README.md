# Figure reproduction notes

This folder documents how main-figure panels were produced.

**Numerical results are defined by the deposited tables and tree files.**  
Display-only steps (iTOL, Adobe Illustrator, GraphPad Prism, BioRender) are described so that each panel can be matched to its source data. Pixel-identical layout is not required for verification.

Paths below are relative to the repository root unless noted.

---

## Scripted panels (Python)

| Panel | Script | Primary data source |
| --- | --- | --- |
| Fig. 1a | `fig1a_contamination_frequency.py` | `data/decontamination/assessment/` (lineage-level contamination frequencies) |
| Fig. 1c | `fig1c_contamination_derived_eukaryote_like_proteins.py` | `data/decontamination/assessment/contamination_derived_eukaryotic_like_proteins_by_Asgard_lineage.csv` (or equivalent `.xlsx`) |
| Fig. 3d | `fig3d_au_topology_test.py` | `data/trees/AU_tests/` (AU test output; *P*-values used in the panel) |

**Dependencies**

```bash
pip install matplotlib numpy
```

**Run** (from this directory, or adjust output paths):

```bash
python fig1a_contamination_frequency.py
python fig1c_contamination_derived_eukaryote_like_proteins.py
python fig3d_au_topology_test.py
```

Scripts may embed summary percentages for convenience; values should match the deposited assessment tables.

---

## Manually assembled panels

### Fig. 1b

- **Software:** GraphPad Prism  
- **Data:** `data/decontamination/assessment/` (Asgard lineage-level contamination frequencies, e.g. `contamination_by_Asgard_MAG_lineage` tables)  
- **Note:** Summary frequencies plotted in Prism. No custom analysis script.

### Fig. 2 (topology panels)

- **Topology source:** `data/trees/maximum_likelihood/*.contree`  
- **Display:** iTOL, then finalized in Adobe Illustrator (colours, labels, layout)  
- **Note:** Branching order and ultrafast bootstrap support are defined by the deposited `.contree` files. No topological editing beyond graphical presentation.

**Suggested panel–dataset correspondence** (aligned with the factorial design in the manuscript):

| Panels | Content |
| --- | --- |
| Fig. 2a–d | GS-Zhang2025-raw × each PMS (contamination present; sampling imbalanced) |
| Fig. 2e–h | GS-Zhang2025-B-raw × each PMS (contamination present; sampling balanced) |
| Fig. 2i–l | GS-Zhang2025-clean × each PMS (decontaminated; sampling imbalanced) |
| Fig. 2m–p | GS-Zhang2025-B-clean × each PMS (full control: decontaminated and sampling balanced) |

Exact file names follow the `GS-*-raw|clean_*_PMS-*.contree` convention under `data/trees/maximum_likelihood/`.

### Fig. 3a–c

#### Fig. 3a

- **Content:** Maximum-likelihood robustness using an independently audited ultra-clean genome collection.  
- **Topology source:** IQ-TREE consensus trees from the post-hoc audited (ultra-clean) dataset, e.g.  
  `data/trees/maximum_likelihood/` files matching `*ultra-clean*` and the GS × PMS combination shown in the panel.  
- **Supporting tables:** `data/trees/robustness_analyses.xlsx`; post-hoc audit summaries under `data/decontamination/phylogenomic_sets/` when deposited.  
- **Display:** iTOL → Adobe Illustrator.  
- **Note:** Branching order and support values are defined by the deposited `.contree` files.

#### Fig. 3b

- **Content:** Maximum-likelihood analyses under expanded archaeal taxon sampling.  
- **Topology source:** IQ-TREE consensus trees from expanded-sampling collections, e.g.  
  `data/alignments/GS-Zhang2025-B-clean_PMS-MediumMAG_expanded.faa` and the corresponding `.contree` under `data/trees/maximum_likelihood/`.  
- **Display:** iTOL → Adobe Illustrator.  
- **Note:** Topology is read from deposited tree files, not from the illustration.

#### Fig. 3c

- **Content:** Maximum-likelihood analysis under the alternative site-heterogeneous PMSF model.  
- **Topology source:** `data/trees/PMSF/` (files matching the GS × PMS combination shown in the panel).  
- **Display:** iTOL → Adobe Illustrator.

**Note (Fig. 3a–c):** Deposited `.contree` files are authoritative for branching order and nodal support. Illustrator was used only for schematic simplification, labelling and layout.

### Fig. 3e

- **Software:** GraphPad Prism  
- **Data:** Bayesian chain-level topology summaries (`data/trees/robustness_analyses.xlsx`; trees under `data/trees/CAT-GTR/`)  
- **Note:** Plotted in Prism from deposited summary counts (e.g. fraction of independent chains recovering a given placement). No custom script.

### Fig. 4a

- **Software:** GraphPad Prism  
- **Data:** `data/ESP/ESP_*_before_after_decontamination.xlsx`  
- **Note:** Counts of contamination-sensitive ESPs by archaeal group plotted in Prism.

### Fig. 4b–c

- **Software:** GraphPad Prism (quantitative elements); BioRender where schematic icons are used  
- **Data:** `data/ESP/` before/after tables  
- **Note:** Numerical values from deposited ESP tables; schematic elements from BioRender where applicable; panels assembled for publication layout.

---

## Extended Data and Supplementary figures (selected)

| Figure | Software | Data / notes |
| --- | --- | --- |
| Extended Data Fig. 6 (PMS construction workflow) | BioRender | Conceptual schematic; marker counts and overlap in `data/PMS/PMS_composition_and_overlap.xlsx` |
| Supplementary Fig. 1 (contamination vs assembly/quality metrics) | GraphPad Prism | Point-level and regression summaries intended for `data/decontamination/assessment/` (e.g. MAG contamination vs N50, CheckM metrics) |
| Extended Data figures on Asgard order/class contamination or contamination-derived eukaryotic-like proteins | GraphPad Prism | `data/decontamination/assessment/` (lineage-level tables, including `contamination_derived_eukaryotic_like_proteins_by_Asgard_lineage`) |
| Set overlaps for viral detection | R (`plot_extended_data_fig1_venn.R`) or Prism | `data/viral_detection_comparison/summary_venn_counts.xlsx` |

BioRender is used for schematic illustration only; it is not required to regenerate numerical panels. A journal-style attribution (e.g. “Created with BioRender.com”) may be placed in Acknowledgements or Methods if required by the publisher.

---

## General principles

1. **Trees:** Always prefer deposited `.contree` / PhyloBayes tree files over illustrated topologies.  
2. **Contamination and ESP counts:** Prefer tables under `data/decontamination/assessment/` and `data/ESP/`.  
3. **Scripts in this folder** reproduce selected bar/scatter-style panels; multi-panel phylogenies and most Prism figures are documented rather than fully scripted.  
4. File names in the table above may use `.xlsx` or `.csv` interchangeably if both formats are deposited; column meanings are described in `data/data_README.md`.
```

