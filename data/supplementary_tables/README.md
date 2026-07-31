# Supplementary Tables

This directory contains the complete set of Supplementary Tables supporting the manuscript  
**Bias-controlled phylogenomics resolves conflicting archaeal placements of eukaryotes**.

Tables are provided as individual Excel (`.xlsx`) files. File names follow the pattern  
`Supplementary_Table_N_*.xlsx`.

---

## Table index

| Table | Title |
|-------|-------|
| **Supplementary Table 1** | Genome accessions and GTDB taxonomic classification of archaeal and eukaryotic genomes in dataset GS-Zhang2025 |
| **Supplementary Table 2** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Liu2021 |
| **Supplementary Table 3** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Zhang2025-B |
| **Supplementary Table 4** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Liu2021-B |
| **Supplementary Table 5** | Genome accessions and GTDB taxonomic classification of archaeal, bacterial and eukaryotic genomes in dataset GS-Present-B |
| **Supplementary Table 6** | Phylogenetic results across all genome-set and marker-set combinations |
| **Supplementary Table 7** | Contamination categories identified in the independent post hoc audit |
| **Supplementary Table 8** | MAG-level post hoc contamination audit |
| **Supplementary Table 9** | Retention of core phylogenetic markers before and after decontamination |
| **Supplementary Table 10** | ESPs identified in Asgard archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 11** | ESPs identified in TACK archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 12** | ESPs identified in Euryarchaeota before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 13** | ESPs identified in DPANN archaea before and after genome decontamination, with genome counts, functional annotations and experimental evidence levels |
| **Supplementary Table 14** | ESP short names in Asgard archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 15** | ESP short names in TACK archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 16** | ESP short names in Euryarchaeota: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 17** | ESP short names in DPANN archaea: aggregated genome detection counts before and after decontamination and corresponding loss rates |
| **Supplementary Table 18** | Final taxonomic counts of retained genomes in GS-Present-B at the phylum, class and order levels |
| **Supplementary Table 19** | Final taxonomic counts of retained genomes in GS-Zhang2025-B at the phylum, class and order levels |
| **Supplementary Table 20** | Final taxonomic counts of retained genomes in GS-Liu2021-B at the phylum, class and order levels |

---

## Content overview

### Genome collections (Tables 1–5)
Accession lists and full GTDB taxonomic classifications for the five genome collections used in the factorial phylogenomic design:

- **GS-Zhang2025** / **GS-Zhang2025-B** — benchmark collection derived from Zhang/Dong et al. (taxonomically imbalanced / balanced)
- **GS-Liu2021** / **GS-Liu2021-B** — benchmark collection derived from Liu et al. (2021) (taxonomically imbalanced / balanced)
- **GS-Present-B** — independently assembled, taxonomically balanced collection generated in this study

### Phylogenetic results (Table 6)
Summary of eukaryotic placement outcomes across all combinations of genome collections (raw versus clean × imbalanced versus balanced) and the four phylogenetic marker sets (PMS-Isolate, PMS-HighMAG1, PMS-HighMAG2, PMS-MediumMAG). Topology notation and bootstrap support values are reported for each genome-set–marker-set combination.

### Contamination audit (Tables 7–8)
Results of the independent post hoc multi-evidence contamination audit. Table 7 provides category-level summaries (bacterial-derived, free virus-derived and eukaryotic-derived contamination) across major archaeal groups. Table 8 reports MAG-level contig removal statistics for every audited genome.

### Marker retention (Table 9)
Genome counts for each core phylogenetic marker before and after primary decontamination, reported for every genome collection and marker set. Demonstrates that decontamination retained the vast majority of markers with only minimal losses.

### ESP inventories (Tables 10–17)
Presence–absence patterns of eukaryotic signature proteins (ESPs) and extended iESPs before versus after decontamination, analysed separately for Asgard, TACK, Euryarchaeota and DPANN archaea.  

- Tables 10–13 provide detailed functional annotations, experimental evidence levels and supporting literature.  
- Tables 14–17 provide aggregated genome detection counts and loss rates by protein short name.

### Taxonomic balancing counts (Tables 18–20)
Final genome counts at the phylum, class and order levels after hierarchical taxonomic balancing for the three balanced collections (GS-Present-B, GS-Zhang2025-B and GS-Liu2021-B). Each table contains separate sheets for Archaea, Bacteria and Eukaryota.

---

## Related scripts

These tables were generated by the analysis scripts deposited under `scripts/`:

| Script directory | Related tables |
|------------------|----------------|
| `scripts/balancing/` | Tables 1–5, 18–20 (genome lists and taxonomic counts) |
| `scripts/decontamination/` and `scripts/independent_audit/` | Tables 7–9 (contamination audit and marker retention) |
| `scripts/ESP/` | Tables 10–17 (ESP inventories and loss rates) |
| `scripts/phylogenomics/` | Table 6 (phylogenetic results across GS × PMS combinations) |

For reproduction of main-figure panels that draw on these tables, see  
`scripts/figure_reproduction/README.md`.

---

## Notes

- All accession lists use NCBI assembly accessions (GCA_/GCF_) where available.
- GTDB taxonomy follows GTDB release R220 (or the release used for the corresponding analysis).
- The suffix “-B” denotes taxonomically balanced genome collections.
- “raw” / “clean” designations refer to genome sets before and after primary decontamination, respectively.
- Percentages in the contamination audit tables are calculated on a contig-weighted basis.