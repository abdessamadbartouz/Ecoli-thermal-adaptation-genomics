#!/bin/bash
set -e

# ==========================================================
# Variant Calling with BCFtools
# Calls genomic variants from mapped BAM files using
# bcftools mpileup and bcftools call.
# ==========================================================

# Reference genome
REF=~/projects/multistrain_stress/reference/ecoli/ecoli_DH10B_reference.fna

# Input and output directories
INPUT_DIR=~/projects/multistrain_stress/result/mapping/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/variants/ecoli

mkdir -p "$OUTPUT_DIR"

SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Calling variants for $SAMPLE..."

    bcftools mpileup \
        --threads 8 \
        -f "$REF" \
        "$INPUT_DIR/${SAMPLE}.sorted.bam" \
        -Q 20 \
        -q 20 \
        -Ou \
    | bcftools call \
        --threads 8 \
        --ploidy 1 \
        -mv \
        -Ov \
        -o "$OUTPUT_DIR/${SAMPLE}.vcf"

done

echo "BCFtools variant calling completed."
