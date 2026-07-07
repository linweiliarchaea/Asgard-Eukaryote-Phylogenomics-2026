# Data and Code for: Sampling imbalance and contamination explain conflicting archaeal placements of eukaryotes

**Manuscript under review at *Nature***  
**Last updated**: 2026-07-07

## Overview

This repository contains data and scripts supporting the manuscript:

> **Sampling imbalance and contamination explain conflicting archaeal placements of eukaryotes**

We provide a contamination-aware and sampling-balanced phylogenomic framework to resolve long-standing conflicts in the placement of eukaryotes relative to Asgard archaea. All analyses converge on a stable topology in which eukaryotes are recovered as sister to a monophyletic Asgard–TACK radiation when both genome contamination and taxonomic sampling imbalance are rigorously controlled.

## Repository Structure
Asgard_Eukaryote_Data/
├── README.md
├── data/
│   ├── alignments/          # Supermatrix alignments
│   └── trees/               # Maximum-likelihood phylogenetic trees (.contree)
├── scripts/
│   ├── phylogenomics/
│   │   ├── run_iqtree_ml.sh         # Maximum-likelihood inference (IQ-TREE 3)
│   │   ├── run_phylobayes.sh        # Bayesian inference (PhyloBayes MPI, CAT-GTR)
│   │   └── run_au_topology_tests.sh # Approximately Unbiased (AU) topology tests
│   ├── decontamination/
│   │   └── run_decontamination.sh   # Main decontamination workflow
│   └── independent_audit/
│       └── independent_audit.sh     # Independent post-hoc contamination audit
└── docs/
└── Data_Availability_Statement.md

## Contents

- **`data/alignments/`** and **`data/trees/`**: Supermatrix alignments and resulting phylogenetic trees from the factorial phylogenomic design (5 genome collections × 4 marker sets).
- **`scripts/phylogenomics/`**: Core analysis scripts for maximum-likelihood, Bayesian, and topology testing analyses.
- **`scripts/decontamination/`** and **`scripts/independent_audit/`**: Scripts documenting the contamination control procedures described in the Methods.

## Usage

Example workflows are provided in the `scripts/` directory. Detailed parameter settings and justifications are described in the Methods section of the manuscript.

This repository is **publicly available**.

## Citation

If you use any data or code from this repository, please cite the original manuscript (once published) and the corresponding Zenodo DOI (to be added upon release).

## Contact

For questions regarding the data or code, please contact the corresponding author.