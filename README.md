# Contamination and taxon sampling explain conflicting eukaryote placements

Data and analysis templates supporting the manuscript:

**Contamination and taxon sampling explain conflicting eukaryote placements**

This repository archives genome-set definitions, phylogenetic marker sets, alignments, trees, contamination and ESP summary tables, and **example analysis scripts**. It is intended for transparent inspection of the workflow and deposited results, not as a one-click re-run of the full compute pipeline.

---

## Reproducible workflow (start here)

A step-by-step walkthrough of the study design, with **full example scripts** from `scripts/` expanded and explained:

**→ [Reproducible_Workflow.ipynb](./Reproducible_Workflow.ipynb)**

The notebook is organised as:

| Block | Focus | Main figures / data |
| --- | --- | --- |
| **Part A** | Contamination landscape across archaeal MAGs | Fig. 1 · `data/decontamination/assessment/` |
| **Part B** | Bias-controlled phylogenomics (genome sets, PMS, ML, AU, CAT-GTR, post-hoc audit) | Fig. 2–3 · `data/genome_sets/`, `data/PMS/`, `data/alignments/`, `data/trees/`, `data/decontamination/phylogenomic_sets/` |
| **Part C** | ESP inventories before vs after decontamination | Fig. 4 · `data/ESP/` |

> Scripts under `scripts/` are **example templates** (placeholder paths). Published numerical results are defined by the files under `data/`.

Optional rendered view:  
[nbviewer](https://nbviewer.org/github/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026/blob/main/Reproducible_Workflow.ipynb)

---

## Repository layout

```text
.
├── README.md
├── Reproducible_Workflow.ipynb
├── data/
│   ├── genome_sets/              # Accession lists + GTDB taxonomy (GS tables)
│   ├── taxonomic_counts/         # Counts after hierarchical balancing
│   ├── PMS/                      # Four marker sets and overlap
│   ├── alignments/               # Concatenated AA supermatrices
│   ├── trees/
│   │   ├── maximum_likelihood/   # IQ-TREE consensus trees
│   │   ├── PMSF/                 # PMSF sensitivity trees
│   │   ├── CAT-GTR/              # PhyloBayes chains
│   │   └── AU_tests/             # Topology tests
│   ├── decontamination/
│   │   ├── assessment/           # Part A: contamination frequencies (Fig. 1)
│   │   └── phylogenomic_sets/    # Part B: contigs removed %; post-hoc audit
│   ├── ESP/                      # ESP before/after decontamination (Fig. 4)
│   └── supplementary_tables/     # Publication tables (CSV/XLSX as deposited)
└── scripts/
    ├── decontamination/          # CAT + geNomad template
    ├── balancing/                # Hierarchical taxonomic balancing (R)
    ├── phylogenomics/            # IQ-TREE, AU tests, PhyloBayes
    ├── independent_audit/        # GUNC / VirSorter2 / CheckV / Whokaryote
    ├── ESP/                      # DIAMOND + HMMER ESP pipeline
    └── figure_reproduction/      # Notes and selected plotting scripts
```

---

## Genome sets

| Genome set | Description | Table |
| --- | --- | --- |
| GS-Zhang2025 | Imbalanced benchmark (Zhang et al. 2025) | Supplementary Table 1 |
| GS-Liu2021 | Imbalanced benchmark (Liu et al. 2021) | Supplementary Table 2 |
| GS-Zhang2025-B | Balanced version of GS-Zhang2025 | Supplementary Table 3 |
| GS-Liu2021-B | Balanced version of GS-Liu2021 | Supplementary Table 4 |
| GS-Present-B | Independently assembled balanced set (this study) | Supplementary Table 5 |

Assemblies are obtained from NCBI RefSeq/GenBank (and any additional public sources listed in those tables) using the deposited accessions. Full raw FASTA collections are not re-hosted here.

---

## Main result (full control)

When **both** genome contamination and taxonomic sampling imbalance are controlled, all **12** analyses (3 balanced genome sets × 4 phylogenetic marker sets) recover eukaryotes as **sister to a monophyletic TACK–Asgard radiation**, outside currently sampled Asgard subgroups.

---

## Citation

- **GitHub:** https://github.com/tjcadd2020/Asgard-Eukaryote-Phylogenomics-2026
- **Zenodo:** to be updated (DOI pending)

Please cite the accompanying manuscript when reusing data or scripts. A versioned Zenodo archive will be linked here once available.

---

## License

Data and scripts are provided for academic reuse consistent with the manuscript and the licenses of upstream databases (NCBI, GTDB, and tool-specific terms). See individual file headers for details.
