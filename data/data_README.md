# Data directory

| Subfolder | Contents |
| --- | --- |
| `genome_sets/` | Accession lists and GTDB taxonomy for each GS (imbalanced and balanced) |
| `taxonomic_counts/` | Counts at phylum, class and order levels after hierarchical balancing |
| `PMS/` | Marker membership and overlap among the four PMSs |
| `alignments/` | Concatenated amino-acid alignments (IQ-TREE input) |
| `trees/maximum_likelihood/` | IQ-TREE consensus trees (`.contree`) for GS × PMS combinations |
| `trees/PMSF/` | PMSF analyses |
| `trees/CAT-GTR/` | PhyloBayes consensus trees per chain |
| `trees/AU_tests/` | Constraint topologies and AU test output |
| `decontamination/assessment/` | Contamination frequency tables (Figs. 1a–c) |
| `decontamination/phylogenomic_sets/` | Contigs removed during primary cleaning; post-hoc audit |
| `ESP/` | ESP/iESP detection before vs after decontamination by archaeal group |

## File name conventions

- `GS-*-raw_*` — before primary decontamination
- `GS-*-clean_*` — after primary decontamination
- `*-B-*` — taxonomically balanced genome collection
