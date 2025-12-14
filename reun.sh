#!/bin/bash
# ==========================================================
# PLINK CNV Analysis Pipeline
# ==========================================================
# Input:
#   merged.cnn / merged.cnv / merged.map / merged.fam
#   Gene annotation files (gene.list / genes.dat)
#
# Purpose:
#   Perform CNV quality checks, deletion analysis,
#   permutation-based burden testing, gene enrichment,
#   and genic CNV extraction using PLINK.
#
# Software:
#   PLINK v1.9+
# ==========================================================


# ----------------------------------------------------------
# 1. Basic CNV file validation
# ----------------------------------------------------------
# Checks whether CNV files load correctly
# --allow-no-sex allows samples with missing sex information
plink --cfile merged --allow-no-sex


# ----------------------------------------------------------
# 2. Check for overlapping CNVs
# ----------------------------------------------------------
# Identifies overlapping CNVs across individuals
# Useful for quality control and filtering
plink --cfile merged \
      --cnv-check-no-overlap \
      --allow-no-sex


# ----------------------------------------------------------
# 3. CNV deletion analysis
# ----------------------------------------------------------
# Extracts and analyzes deletion-type CNVs only
plink --cfile merged \
      --cnv-del \
      --allow-no-sex


# ----------------------------------------------------------
# 4. CNV burden test (individual-level permutation)
# ----------------------------------------------------------
# Performs permutation-based CNV burden analysis
# --mperm 10000 = 10,000 permutations for empirical p-values
plink --cfile merged \
      --cnv-indiv-perm \
      --mperm 10000 \
      --allow-no-sex


# ----------------------------------------------------------
# 5. Gene-based CNV burden analysis
# ----------------------------------------------------------
# Tests whether CNVs overlapping genes are enriched
# gene.list contains gene coordinates
plink --cfile merged \
      --cnv-indiv-perm \
      --mperm 10000 \
      --cnv-count gene.list \
      --allow-no-sex


# ----------------------------------------------------------
# 6. CNV gene enrichment test
# ----------------------------------------------------------
# Tests whether CNVs are enriched in predefined gene sets
# genes.dat contains gene-set definitions
plink --cfile merged \
      --cnv-count genes.dat \
      --cnv-enrichment-test \
      --allow-no-sex


# ----------------------------------------------------------
# 7. Extract genic CNVs
# ----------------------------------------------------------
# Identifies CNVs overlapping gene regions
# Output files will be prefixed as "my-genic-cnv"
plink --cfile merged \
      --cnv-intersect genes.dat \
      --cnv-write my-genic-cnv \
      --allow-no-sex


# ----------------------------------------------------------
# 8. High-permutation association test
# ----------------------------------------------------------
# Runs association analysis with higher permutation count
# Useful for robust empirical significance estimation
plink --cfile merged \
      --mperm 50000 \
      --allow-no-sex


# ==========================================================
# End of PLINK CNV Pipeline
# ==========================================================
