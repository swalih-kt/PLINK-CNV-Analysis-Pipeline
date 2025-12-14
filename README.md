# PLINK CNV Analysis Pipeline

This repository contains a **PLINK-based workflow for Copy Number Variation (CNV) analysis**
using case–control genotype data.

The pipeline performs:
- CNV quality checks
- CNV type–specific filtering (deletions)
- Individual-level permutation tests
- Gene-based CNV burden and enrichment analysis
- CNV–gene intersection analysis

---

## 📌 Overview

**Tool:** PLINK  
**Data type:** CNV data (`.cnv`, `.cnv.map`, `.fam`)  
**Analysis focus:** CNV burden, gene enrichment, and permutation testing  

The pipeline assumes a **merged CNV dataset** prepared using PLINK.

---

## 📦 Requirements

- **PLINK v1.9 or later**
- Linux / HPC environment recommended

Check PLINK installation:
```bash
plink --version
