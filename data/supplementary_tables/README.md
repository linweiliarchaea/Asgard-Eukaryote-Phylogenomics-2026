# Supplementary Tables

This directory contains the complete set of Supplementary Tables supporting the manuscript  
**Contamination and taxon sampling explain conflicting eukaryote placements**.

Tables are provided as individual Excel (`.xlsx`) files. File names follow the pattern  
`Supplementary_Table_N_*.xlsx`.

---

## Table index

| Table | Title |
| --- | --- |
| **Supplementary Table 1** | Composition and overlap of the four independently curated phylogenetic marker sets (PMS-Isolate, PMS-HighMAG1, PMS-HighMAG2 and PMS-MediumMAG) |
| **Supplementary Table 2** | Genome accessions and GTDB taxonomic classification of archaeal and eukaryotic genomes in dataset GS-Zhang2025 |
| **Supplementary Table 3** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Liu2021 |
| **Supplementary Table 4** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Zhang2025-B |
| **Supplementary Table 5** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Liu2021-B |
| **Supplementary Table 6** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Present-B |
| **Supplementary Table 7** | Comprehensive phylogenetic results across all genome-set and marker-set combinations |
| **Supplementary Table 8** | Retention of core phylogenetic markers before and after primary decontamination |
| **Supplementary Table 9** | Breakdown of contamination categories identified during the independent post-hoc audit |
| **Supplementary Table 10** | MAG-level post-hoc contamination audit |
| **Supplementary Table 11** | ESPs identified in Asgard archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 12** | ESPs identified in TACK archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 13** | ESPs identified in Euryarchaeota before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 14** | ESPs identified in DPANN archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 15** | ESP short names in Asgard archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 16** | ESP short names in TACK archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 17** | ESP short names in Euryarchaeota: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 18** | ESP short names in DPANN archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 19** | Final taxonomic counts of retained genomes in GS-Present-B at the phylum, class and order levels |
| **Supplementary Table 20** | Final taxonomic counts of retained genomes in GS-Zhang2025-B at the phylum, class and order levels |
| **Supplementary Table 21** | Final taxonomic counts of retained genomes in GS-Liu2021-B at the phylum, class and order levels |

---

## Content overview

### Phylogenetic marker sets (Table 1)
Composition of the four independently curated PMSs constructed after decontamination and single-protein-tree screening. PMS-Isolate (35 proteins), PMS-HighMAG1 (34), PMS-HighMAG2 (32) and PMS-MediumMAG (30) share a core of 28 markers but are not strictly nested.

### Genome collections (Tables 2–6)
Accession lists and full GTDB taxonomic classifications for the five genome collections used in the factorial phylogenomic design:
- **GS-Zhang2025** / **GS-Zhang2025-B** — benchmark set based on Zhang et al. 2025 (imbalanced / balanced)
- **GS-Liu2021** / **GS-Liu2021-B** — benchmark set based on Liu et al. 2021 (imbalanced / balanced)
- **GS-Present-B** — independently assembled, taxonomically balanced collection (this study)

### Phylogenetic results (Table 7)
Summary of eukaryotic placement outcomes across all combinations of genome collections (raw/clean × imbalanced/balanced) and the four phylogenetic marker sets (PMS-Isolate, PMS-HighMAG1, PMS-HighMAG2, PMS-MediumMAG).

### Marker retention (Table 8)
Counts of the core phylogenetic markers retained in each genome collection before and after primary decontamination. Across the union of 35 markers used by the four PMSs, most genome-level marker counts decreased by zero or one after decontamination.

### Contamination audit (Tables 9–10)
Results of the independent post-hoc multi-evidence contamination audit performed on GS-Zhang2025-B-clean, including category-level breakdowns (bacterial-derived, free virus-derived, eukaryotic-derived) and MAG-level contig removal statistics. Additional candidate contamination accounted for <0.8% of contigs in each audited archaeal group.

### ESP inventories (Tables 11–18)
Presence–absence of eukaryotic signature proteins (ESPs) and extended iESPs before versus after decontamination, reported separately for Asgard, TACK, Euryarchaeota and DPANN. Tables 11–14 provide detailed annotations and experimental evidence levels; Tables 15–18 provide aggregated genome detection counts and loss rates by short name.

### Taxonomic balancing counts (Tables 19–21)
Final genome counts at the phylum, class and order levels after hierarchical taxonomic balancing for the three balanced collections (GS-Present-B, GS-Zhang2025-B, GS-Liu2021-B). Each table contains separate sheets for Archaea, Bacteria and Eukaryota.

---

## Related scripts

These tables were generated by the analysis scripts deposited under `scripts/`:

| Script directory | Related tables |
| --- | --- |
| `scripts/balancing/` | Tables 2–6, 19–21 (genome lists and taxonomic counts) |
| `scripts/decontamination/` and `scripts/independent_audit/` | Tables 8–10 (marker retention and contamination audit) |
| `scripts/ESP/` | Tables 11–18 (ESP inventories and loss rates) |
| `scripts/phylogenomics/` | Tables 1 and 7 (marker composition and phylogenetic results across GS × PMS combinations) |

For reproduction of main-figure panels that draw on these tables, see  
`scripts/figure_reproduction/README.md`.

---

## Notes

- All accession lists use NCBI assembly accessions (GCA_/GCF_) where available.
- GTDB taxonomy follows GTDB release R220 (or the release used for the corresponding analysis).
- “B” suffix denotes taxonomically balanced genome collections.
- “raw” / “clean” designations in related data files refer to genome sets before and after primary decontamination, respectively.
- Primary decontamination removed approximately 4–5% of contigs from the balanced collections (GS-Zhang2025-B 4.91%; GS-Liu2021-B 4.22%; GS-Present-B 5.11%).
