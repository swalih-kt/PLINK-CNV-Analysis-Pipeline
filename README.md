# PLINK CNV Analysis Pipeline

A PLINK-based workflow for Copy Number Variation (CNV) analysis using case–control genotype data. The pipeline covers CNV quality checks, deletion filtering, permutation-based burden testing, gene enrichment analysis, and genic CNV extraction.

---

## Requirements

- **PLINK v1.9 or later**
- Linux / HPC environment recommended

---

## Input Files

| File | Description |
|------|-------------|
| `merged.cnv` | CNV calls (chromosome, start, end, type, sample ID) |
| `merged.cnv.map` | Marker map file |
| `merged.fam` | Sample and family information |
| `gene.list` | Gene coordinates for burden testing (chr, start, end, name) |
| `genes.dat` | Gene-set definitions for enrichment testing |

---

## Pipeline Steps

### Step 1: Basic CNV File Validation

**Purpose**: Loads CNV files and reports basic summary statistics to verify the dataset is correctly formatted before any analysis.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam` |
| **Output** | Console summary (no output files) |

> **Important**: Run this first to catch any formatting issues early. `--allow-no-sex` is used throughout the pipeline to accommodate samples with missing sex information.

---

### Step 2: Check for Overlapping CNVs

**Purpose**: Identifies CNVs that overlap with each other across individuals. Used as a quality control step to detect redundant or problematic calls before downstream analysis.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam` |
| **Output** | Overlap report |

> **Important**: Overlapping CNVs can inflate burden statistics. Review and filter overlaps before proceeding to burden testing.

---

### Step 3: CNV Deletion Analysis

**Purpose**: Filters and analyzes deletion-type CNVs only (copy number loss). Duplications are excluded, allowing focused analysis on deletions which are typically more pathogenic in neurodevelopmental disorders.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam` |
| **Output** | Deletion-specific CNV summary |

---

### Step 4: CNV Burden Test (Individual-Level Permutation)

**Purpose**: Compares CNV burden between cases and controls at the individual level using permutation testing. Generates empirical p-values by randomly shuffling case/control labels across permutation replicates.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam` |
| **Output** | Permutation-based burden test results |
| **Permutations** | 10,000 |

> **Important**: 10,000 permutations provides a good balance between accuracy and compute time. Increase to 50,000 (Step 8) for final results requiring stronger empirical confidence.

---

### Step 5: Gene-Based CNV Burden Analysis

**Purpose**: Tests whether CNVs overlapping specific genes are enriched in cases compared to controls. Extends Step 4 by incorporating gene coordinates to quantify per-gene CNV counts.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam`, `gene.list` |
| **Output** | Gene-level burden test results |
| **Permutations** | 10,000 |

> **Important**: `gene.list` must be formatted with columns: chromosome, start position, end position, and gene name. Genes not present in this file will not be tested.

---

### Step 6: CNV Gene Enrichment Test

**Purpose**: Tests whether CNVs are statistically enriched within predefined gene sets (e.g., synaptic genes, ASD candidate genes, pathway gene lists). Useful for hypothesis-driven analyses.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam`, `genes.dat` |
| **Output** | Gene-set enrichment test results |

> **Important**: `genes.dat` defines the gene sets to be tested. Multiple gene sets can be included in one file. Enrichment is tested against a background of all CNV-overlapping genes.

---

### Step 7: Extract Genic CNVs

**Purpose**: Identifies and extracts all CNVs that overlap gene regions defined in `genes.dat`. Produces a filtered CNV dataset containing only genic CNVs for downstream annotation or visualization.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam`, `genes.dat` |
| **Output** | `my-genic-cnv.cnv`, `my-genic-cnv.cnv.map` |

> **Important**: Output prefix is set to `my-genic-cnv`. The resulting files can be used as input for further PLINK analyses or exported for manual review.

---

### Step 8: High-Permutation Association Test

**Purpose**: Re-runs the association analysis with 50,000 permutations for more robust and precise empirical p-values. Used for final reporting where statistical confidence is critical.

| | |
|---|---|
| **Input** | `merged.cnv`, `merged.cnv.map`, `merged.fam` |
| **Output** | High-confidence permutation-based association results |
| **Permutations** | 50,000 |

> **Important**: This step is computationally intensive. Run on an HPC node with sufficient memory and time allocation.

---

## Output Summary

| Step | Key Output |
|------|------------|
| 1 | File validation summary |
| 2 | CNV overlap report |
| 3 | Deletion CNV summary |
| 4 | Burden test results (10K permutations) |
| 5 | Gene-level burden results (10K permutations) |
| 6 | Gene-set enrichment results |
| 7 | `my-genic-cnv.cnv` / `.cnv.map` |
| 8 | Association results (50K permutations) |

---

## Notes

- `--allow-no-sex` is applied in all steps to prevent samples with missing sex from being excluded.
- All steps use `--cfile merged` which expects `merged.cnv`, `merged.cnv.map`, and `merged.fam` in the working directory.
- For large cohorts, Steps 4, 5, and 8 (permutation steps) will be the most time-consuming.

---

## References

- [PLINK CNV Analysis Documentation](https://zzz.bwh.harvard.edu/plink/cnv.shtml)
- [PLINK v1.9](https://www.cog-genomics.org/plink/)
