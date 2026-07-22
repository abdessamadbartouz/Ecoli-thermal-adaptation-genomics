#!/bin/bash
set -e

# ==========================================================
# Read Mapping
# Maps paired-end Illumina reads against the E. coli DH10B
# reference genome using BWA-MEM, sorts and indexes the BAM
# files, and generates mapping statistics.
# ==========================================================

# Reference genome
REF=~/projects/multistrain_stress/reference/ecoli/ecoli_DH10B_reference.fna

# Input and output directories
INPUT_DIR=~/projects/multistrain_stress/raw_data/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/mapping/ecoli

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Move to input directory
cd "$INPUT_DIR"

echo "========== Mapping E. coli Heat Stress Samples ==========" | tee "$OUTPUT_DIR/mapping.txt"

# Samples to process
SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Processing $SAMPLE..."

    bwa mem \
        -t 8 \
        -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:ILLUMINA" \
        "$REF" \
        "${SAMPLE}_1.fastq.gz" \
        "${SAMPLE}_2.fastq.gz" \
    | samtools sort \
        -o "$OUTPUT_DIR/${SAMPLE}.sorted.bam"

    samtools index "$OUTPUT_DIR/${SAMPLE}.sorted.bam"

    echo "========== Sample: $SAMPLE ==========" | tee -a "$OUTPUT_DIR/mapping.txt"

    samtools flagstat \
        "$OUTPUT_DIR/${SAMPLE}.sorted.bam" \
        | tee -a "$OUTPUT_DIR/mapping.txt"

done

echo "Mapping completed successfully."
