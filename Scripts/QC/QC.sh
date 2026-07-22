#!/bin/bash

# ==========================================================
# Quality Control
# Performs FastQC on raw sequencing reads and summarizes
# the reports using MultiQC.
# ==========================================================

INPUT_DIR="/home/believe/projects/multistrain_stress/raw_data/ecoli"
OUTPUT_DIR="/home/believe/projects/multistrain_stress/result/QC/ecoli"

mkdir -p "$OUTPUT_DIR"

fastqc "$INPUT_DIR"/*.fastq* --outdir "$OUTPUT_DIR"

multiqc "$OUTPUT_DIR" --outdir "$OUTPUT_DIR"

echo "Quality control completed successfully"
