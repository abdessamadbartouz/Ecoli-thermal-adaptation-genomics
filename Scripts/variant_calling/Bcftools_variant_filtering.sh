#!/bin/bash
set -e

# ==========================================================
# Variant Filtering
# Filters BCFtools VCF files based on:
#   - Minimum depth (DP >= 10)
#   - Minimum variant quality (QUAL >= 40)
# ==========================================================

# Input and output directories
INPUT_DIR=~/projects/multistrain_stress/result/variants/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/filtered/ecoli

mkdir -p "$OUTPUT_DIR"

SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Filtering variants for $SAMPLE..."

    bcftools filter \
        -i 'INFO/DP>=10 && QUAL>=40' \
        "$INPUT_DIR/${SAMPLE}.vcf" \
        -Ov \
        -o "$OUTPUT_DIR/${SAMPLE}_filtered.vcf"

    echo "Finished $SAMPLE"
done

echo "Variant filtering completed successfully"
