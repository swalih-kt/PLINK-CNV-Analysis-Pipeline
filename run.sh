#!/bin/bash
# ==========================================================
# PLINK CNV Analysis Pipeline
# ==========================================================
#
# Input files:
#   merged.cnv       - CNV calls (chr, start, end, type, sample)
#   merged.cnv.map   - Marker map file
#   merged.fam       - Sample/family information
#   gene.list        - Gene coordinates for burden testing
#   genes.dat        - Gene-set definitions for enrichment testing
#
# Purpose:
#   Perform CNV quality checks, deletion analysis,
#   permutation-based burden testing, gene enrichment,
#   and genic CNV extraction using PLINK.
#
# Software:
#   PLINK v1.9+
#
# Usage:
#   bash plink_cnv_pipeline.sh
# ==========================================================


# ----------------------------------------------------------
# Step 1: Basic CNV file validation
# ----------------------------------------------------------
# Checks whether CNV files load correctly and reports
# basic summary statistics.
# --allow-no-sex : allows samples with missing sex information

plink --cfile merged \
      --allow-no-sex


# ----------------------------------------------------------
# Step 2: Check for overlapping CNVs
# ----------------------------------------------------------
# Identifies overlapping CNVs across individuals.
# Useful for quality control and filtering before analysis.

plink --cfile merged \
      --cnv-check-no-overlap \
      --allow-no-sex


# ----------------------------------------------------------
# Step 3: CNV deletion analysis
# ----------------------------------------------------------
# Extracts and analyzes deletion-type CNVs only (TYPE=1).
# Duplications are excluded from this analysis.

plink --cfile merged \
      --cnv-del \
      --allow-no-sex


# ----------------------------------------------------------
# Step 4: CNV burden test (individual-level permutation)
# ----------------------------------------------------------
# Performs permutation-based CNV burden analysis at the
# individual level to compare cases vs. controls.
# --mperm 10000 : 10,000 permutations for empirical p-values

plink --cfile merged \
      --cnv-indiv-perm \
      --mperm 10000 \
      --allow-no-sex


# ----------------------------------------------------------
# Step 5: Gene-based CNV burden analysis
# ----------------------------------------------------------
# Tests whether CNVs overlapping specific genes are enriched
# in cases compared to controls.
# gene.list : contains gene coordinates (chr, start, end, name)

plink --cfile merged \
      --cnv-indiv-perm \
      --mperm 10000 \
      --cnv-count gene.list \
      --allow-no-sex


# ----------------------------------------------------------
# Step 6: CNV gene enrichment test
# ----------------------------------------------------------
# Tests whether CNVs are enriched in predefined gene sets
# (e.g., pathway genes, disease gene lists).
# genes.dat : contains gene-set definitions

plink --cfile merged \
      --cnv-count genes.dat \
      --cnv-enrichment-test \
      --allow-no-sex


# ----------------------------------------------------------
# Step 7: Extract genic CNVs
# ----------------------------------------------------------
# Identifies and extracts CNVs that overlap gene regions.
# Output files will be prefixed as "my-genic-cnv".

plink --cfile merged \
      --cnv-intersect genes.dat \
      --cnv-write my-genic-cnv \
      --allow-no-sex


# ----------------------------------------------------------
# Step 8: High-permutation association test
# ----------------------------------------------------------
# Runs association analysis with a higher permutation count
# for more robust empirical significance estimation.
# --mperm 50000 : 50,000 permutations

plink --cfile merged \
      --mperm 50000 \
      --allow-no-sex


# ==========================================================
# End of PLINK CNV Pipeline
# ==========================================================
