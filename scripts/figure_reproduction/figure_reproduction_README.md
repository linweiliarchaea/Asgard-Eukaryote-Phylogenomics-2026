# Figure reproduction notes

This folder documents how main-figure and selected Extended Data panels were produced for:

**Contamination and taxon sampling explain conflicting eukaryote placements**

**Numerical results are defined by the deposited tables, alignments and tree files.**  
Display-only steps (iTOL, Adobe Illustrator, GraphPad Prism, BioRender) are described so that each panel can be matched to its source data. Pixel-identical layout is not required for verification.

Paths below are relative to the repository root unless noted.  
Archived materials: [https://doi.org/10.5281/zenodo.21798441](https://doi.org/10.5281/zenodo.21798441) · [GitHub repository](https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026).

---

## Scripted panels (Python / R)

| Panel | Script | Primary data source |
| --- | --- | --- |
| Fig. 1a | `fig1a_contamination_frequency.py` | `data/decontamination/assessment/contamination_by_lineage.xlsx` (isolate vs MAG frequencies by group and contaminant category) |
| Fig. 1c | `fig1c_contamination_derived_eukaryote_like_proteins.py` | `data/decontamination/assessment/` (frequencies of MAGs harbouring contaminant-derived proteins with apparent similarity to eukaryotic homologues) |
| Fig. 3d | `fig3d_au_topology_test.py` | `data/trees/AU_tests/` (IQ-TREE AU output; *P*-values used in the panel) |
| Extended Data Fig. 1 (viral call overlap) | `plot_extended_data_fig1_venn.R` | `data/viral_detection_comparison/summary_venn_counts.xlsx` |

**Python dependencies**

```bash
pip install matplotlib numpy
```

**R dependencies (Euler diagrams)**

```r
install.packages(c("eulerr", "readxl"))
```

**Run** (from this directory, or adjust relative paths):

```bash
python fig1a_contamination_frequency.py
python fig1c_contamination_derived_eukaryote_like_proteins.py
python fig3d_au_topology_test.py
Rscript plot_extended_data_fig1_venn.R
```

Scripts may embed summary percentages for layout; values must match the deposited assessment tables and AU outputs.

---

## Manually assembled panels

### Fig. 1b

- **Software:** GraphPad Prism  
- **Data:** `data/decontamination/assessment/` (Asgard order-level contamination frequencies; only lineages with ≥10 MAGs)  
- **Note:** Summary frequencies plotted in Prism. No custom analysis script. Stars mark lineages previously proposed as candidate closest relatives of eukaryotes (e.g. Hodarchaeales, Njordarchaeales), which exhibit elevated contamination across multiple categories.

### Fig. 2 (topology panels)

- **Topology source:** `data/trees/maximum_likelihood/*.contree`  
- **Display:** iTOL, then finalized in Adobe Illustrator (colours, labels, layout)  
- **Inference:** IQ-TREE 3 under LG+C60+F+G; black dots indicate ultrafast bootstrap support ≥80%  
- **Note:** Branching order and support values are defined by the deposited `.contree` files. Illustrator was used only for graphical presentation.

**Panel–dataset correspondence** (factorial design: contamination × sampling balance × four independently curated PMSs):

| Panels | Genome set × condition | Interpretation in manuscript |
| --- | --- | --- |
| Fig. 2a–d | GS-Zhang2025-raw × each PMS | Contamination present; sampling imbalanced — marker-set disagreement |
| Fig. 2e–h | GS-Zhang2025-B-raw × each PMS | Contamination present; sampling balanced — marker-set disagreement persists |
| Fig. 2i–l | GS-Zhang2025-clean × each PMS | Decontaminated; sampling imbalanced — directional attraction (e.g. Korarchaeia) |
| Fig. 2m–p | GS-Zhang2025-B-clean × each PMS | Full control (decontaminated and balanced) — all four PMSs converge |

File names follow `GS-*-raw|clean_*_PMS-*.contree` under `data/trees/maximum_likelihood/`.  
Only under simultaneous control of both biases (Fig. 2m–p) do all four PMSs recover eukaryotes as sister to a monophyletic TACK–Asgard archaeal radiation.

### Fig. 3a–c

#### Fig. 3a

- **Content:** Maximum-likelihood robustness on an independently audited ultra-clean genome collection  
- **Topology source:** IQ-TREE consensus trees from the post-hoc audited (ultra-clean) dataset under `data/trees/maximum_likelihood/` (files matching `*ultra-clean*` and the GS × PMS combination shown)  
- **Supporting tables:** post-hoc audit summaries under `data/decontamination/`; robustness summaries under `data/trees/` when deposited  
- **Display:** iTOL → Adobe Illustrator  
- **Note:** Additional contig removal at the audit stage was <0.8% per archaeal group and did not alter the main topology (eukaryotes sister to the monophyletic TACK–Asgard radiation).

#### Fig. 3b

- **Content:** Maximum-likelihood analyses under expanded archaeal taxon sampling  
- **Topology source:** IQ-TREE consensus trees from expanded-sampling collections (alignments under `data/alignments/`; `.contree` under `data/trees/maximum_likelihood/`)  
- **Display:** iTOL → Adobe Illustrator  

#### Fig. 3c

- **Content:** Maximum-likelihood analysis under the alternative site-heterogeneous PMSF approximation (LG+C60+F+G+PMSF)  
- **Topology source:** `data/trees/PMSF/` (files matching the GS × PMS combination shown)  
- **Display:** iTOL → Adobe Illustrator  

**Note (Fig. 3a–c):** Deposited `.contree` files are authoritative for branching order and nodal support. Illustrator was used only for labelling and layout.

### Fig. 3d

- **Script:** `fig3d_au_topology_test.py` (see table above)  
- **Content:** Approximately unbiased (AU) tests of alternative eukaryotic placements relative to ((TACK, Asgard), Eukaryotes)  
- **Data:** IQ-TREE AU output under `data/trees/AU_tests/`  
- **Note:** Alternative placements (e.g. sister to Heimdallarchaeia, Njordarchaeia, Hodarchaeales, or TACK alone) receive low AU *P*-values and are rejected at α = 0.05 under full-control conditions.

### Fig. 3e

- **Software:** GraphPad Prism  
- **Data:** Bayesian chain-level topology summaries (`data/trees/CAT-GTR/`; robustness summary tables when deposited)  
- **Note:** Ten independent PhyloBayes CAT-GTR chains. Plotted from deposited summary counts (e.g. majority of chains recovering TACK–Asgard + eukaryotes). Because full convergence was not achieved, chain-level topologies are descriptive only and are not interpreted as posterior consensus support. No custom plotting script is required beyond the deposited counts.

### Fig. 4a

- **Software:** GraphPad Prism  
- **Data:** `data/ESP/` before/after decontamination tables (e.g. ESP counts by archaeal group)  
- **Note:** Counts of contamination-sensitive ESPs (lost or reduced after decontamination) by major archaeal group. Asgard contributes the largest number of affected ESPs.

### Fig. 4b–c

- **Software:** GraphPad Prism (quantitative elements); BioRender where schematic icons are used  
- **Data:** `data/ESP/` before/after tables  
- **Note:** Numerical values are taken from deposited ESP tables. Schematic elements (e.g. functional icons) may use BioRender. Panels illustrate inventory-level contamination sensitivity and are **not** used to infer ancestral gain–loss histories.

---

## Extended Data and Supplementary figures (selected)

| Figure | Software | Data / notes |
| --- | --- | --- |
| Extended Data Fig. 1 | R (`plot_extended_data_fig1_venn.R`) | Viral-contig call overlap (geNomad vs Phager) across Asgard, TACK, Euryarchaeota and DPANN; `data/viral_detection_comparison/summary_venn_counts.xlsx` |
| Extended Data Fig. 2 | GraphPad Prism | Candidate exogenous sequence burden (>1% of sequences) in isolate genomes vs MAGs; `data/decontamination/assessment/` |
| Extended Data Figs. 3–4 | GraphPad Prism | Contamination frequency vs N50, quality score, CheckM completeness/contamination; exploratory regressions |
| Extended Data Figs. 5–6 | GraphPad Prism | Asgard class/order contamination frequencies and contaminant-derived eukaryote-like proteins (lineages with ≥10 MAGs) |
| Extended Data Fig. 7 | BioRender (workflow schematic) | Single-protein-tree screening and construction of four independently curated PMSs; marker counts and overlap in `data/PMS/` |

BioRender is used for schematic illustration only; it is not required to regenerate numerical panels. A journal-style attribution (e.g. “Created with BioRender.com”) may be placed in Acknowledgements or Methods if required by the publisher.

---

## Related analysis scripts (repository)

| Script | Role |
| --- | --- |
| `scripts/decontamination/run_decontamination.sh` | Primary decontamination (CAT + geNomad) |
| `scripts/decontamination/run_CAT_for_eukaryote_assigned_proteins.sh` | CAT contigs mode to generate ORF2LCA files for eukaryote-assigned proteins on candidate exogenous contigs |
| `scripts/decontamination/count_eukaryote_like_proteins_from_CAT.R` | Count Eukaryota-classified proteins on contigs previously flagged as bacterial, eukaryotic, viral or chimeric |
| `scripts/independent_audit/independent_audit.sh` | Post-hoc multi-evidence audit (GUNC, VirSorter2, CheckV, Whokaryote) |
| `scripts/phylogenomics/run_iqtree_ml.sh` | MAFFT → BMGE → IQ-TREE 3 (LG+C60+F+G, UFBoot) |
| `scripts/phylogenomics/run_au_topology_tests.sh` | AU tests of competing eukaryotic placements |
| `scripts/phylogenomics/run_phylobayes.sh` | CAT-GTR sensitivity analysis (10 independent chains) |
| `scripts/ESP/run_ESP_pipeline.sh` | DIAMOND + HMMER ESP/iESP detection before and after decontamination |

---

## General principles

1. **Trees:** Always prefer deposited `.contree` / PhyloBayes tree files over illustrated topologies.  
2. **Contamination and ESP counts:** Prefer tables under `data/decontamination/assessment/` and `data/ESP/`.  
3. **Scripts in this folder** reproduce selected bar/lollipop-style panels; multi-panel phylogenies and most Prism figures are documented rather than fully scripted.  
4. File names may use `.xlsx` or `.csv` interchangeably if both formats are deposited; column meanings are described in `data/data_README.md` where provided.  
5. **Primary phylogenetic inference** is contamination-controlled maximum-likelihood analysis plus topology tests. Bayesian CAT-GTR results are supportive sensitivity analyses and are summarized at the chain level only because full convergence was not achieved.  
6. Marker-set agreement across the four independently curated PMSs is used as a robustness criterion under factorial control of contamination and taxonomic sampling imbalance; it is not assumed a priori to guarantee correctness.
