# Figure reproduction notes

This folder documents how each main-figure panel was produced.

**Numerical results are fully determined by deposited tables and tree files.**
Display-only steps (iTOL, Adobe Illustrator, Prism, BioRender) are described so that panels can be matched to source data; identical pixel layout is not required for verification.

## Scripted panels (Python)

| Panel | Script | Data source |
| --- | --- | --- |
| Fig. 1a | `fig1a_contamination_frequency.py` | `data/decontamination/assessment/contamination_by_lineage.xlsx` (summary percentages embedded in script; match deposited tables) |
| Fig. 1c | `fig1c_contamination_derived_eukaryote_like_proteins.py` | `data/decontamination/assessment/contamination_derived_eukaryote_like_protein_frequency.xlsx` |
| Fig. 3d | `fig3d_au_topology_test.py` | `data/trees/AU_tests/AU_test_results.iqtree` (P-values embedded in script) |

Dependencies for Python panels:

```bash
pip install matplotlib numpy
```

Run from this directory (or adjust output paths):

```bash
python fig1a_contamination_frequency.py
python fig1c_contamination_derived_eukaryote_like_proteins.py
python fig3d_au_topology_test.py
```

## Manually assembled panels

### Fig. 1b

- **Software:** GraphPad Prism
- **Data:** `data/decontamination/assessment/contamination_by_Asgard_MAG_lineage.xlsx` (and related assessment tables)
- **Note:** Summary frequencies were plotted in Prism. No custom analysis script.

### Fig. 2 (all topology panels)

- **Topology source:** `data/trees/maximum_likelihood/*.contree`
- **Display:** iTOL, then finalized in Adobe Illustrator (colours, labels, layout)
- **Note:** Branching order and ultrafast bootstrap support are defined by the deposited `.contree` files. No topological editing beyond graphical presentation.

Suggested panel–file correspondence (update to match the published layout):

| Panel group | Content |
| --- | --- |
| Fig. 2a–d | GS-Zhang2025-raw × each PMS (contamination present; sampling imbalanced) |
| Fig. 2e–h | BGS-Zhang2025-B-raw × each PMS (contamination present; sampling balanced) |
| Fig. 2i–l | GS-Zhang2025-clean × each PMS (decontaminated; sampling imbalanced) |
| Fig. 2m–p | GS-Zhang2025-B-clean × each PMS (full control: decontaminated and sampling balanced) |

### Fig. 3a–c

#### Fig. 3a
- **Content:** Maximum-likelihood robustness analyses using an independently audited ultra-clean genome collection.
- **Topology source:** IQ-TREE consensus trees inferred from the post-hoc audited (ultra-clean) dataset, deposited under `data/trees/maximum_likelihood/GS-Zhang2025-B-ultra-clean_PMS-MediumMAG.contree` (file names matching the GS × PMS combinations shown in the panel).
- **Supporting tables:** `data/trees/robustness_analyses.xlsx`; post-hoc audit summaries in `data/decontamination/phylogenomic_sets/posthoc_audit_GS-Zhang2025-B.xlsx`.
- **Display:** Trees rendered in iTOL and finalized in Adobe Illustrator.
- **Note:** Branching order and support values are defined by the deposited `.contree` files. Illustrator was used only for schematic simplification, labelling and layout.

#### Fig. 3b
- **Content:** Maximum-likelihood analyses under expanded archaeal taxon sampling.
- **Topology source:** IQ-TREE consensus trees inferred from the expanded-sampling genome collection(s), deposited under `data/trees/maximum_likelihood/GS-Zhang2025-B-clean_PMS-MediumMAG_expanded.contree` (GS × PMS combinations shown in the panel; typically the larger balanced sets such as GS-Zhang2025-B).
- **Display:** Trees rendered in iTOL and finalized in Adobe Illustrator.
- **Note:** Branching order and support values are defined by the deposited `.contree` files. Expanded sampling does not change the requirement that topology is read from the tree files rather than from the illustration.

#### Fig. 3c
- **Content:** Maximum-likelihood analysis under the alternative site-heterogeneous PMSF model.
- **Topology source:** `data/trees/PMSF/GS-Zhang2025-B-clean_PMS-MediumMAG_PMSF.contree` 
- **Display:** iTOL → Adobe Illustrator.

**Note (Fig. 3a–c):** Deposited `.contree` files are authoritative for branching order and nodal support. Illustrator was used only for schematic simplification, labelling and layout.

### Fig. 3e

- **Software:** GraphPad Prism
- **Data:** Bayesian chain-level topology summary (see manuscript Extended Data Table 5 or data/trees/robustness_analyses.xlsx ; trees under `data/trees/CAT-GTR/`)
- **Note:** Plotted in Prism from deposited summary counts (for example, 7 of 10 chains). No custom script.

### Fig. 4a

- **Software:** GraphPad Prism
- **Data:** `data/ESP/ESP_*_before_after_decontamination.xlsx`
- **Note:** Counts of contamination-sensitive ESPs by archaeal group plotted in Prism.

### Fig. 4b

- **Software:** GraphPad Prism (quantitative elements) and BioRender (schematic icons/graphics)
- **Data:** `data/ESP/` before/after tables
- **Note:** Numerical values from deposited ESP tables; schematics from BioRender; panels assembled for publication layout.

