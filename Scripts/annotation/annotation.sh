#!/bin/bash
set -e

# ==========================================================
# Variant Annotation
# Annotates filtered variants using SnpEff with the
# Escherichia coli DH10B reference database.
# ==========================================================

# SnpEff database
DATABASE="Escherichia_coli_str_k_12_substr_dh10b"

# Input and output directories
INPUT_DIR=~/projects/multistrain_stress/result/renamed/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/annotation/ecoli

mkdir -p "$OUTPUT_DIR"

# Download the database if it is not already installed
if [ ! -d "$HOME/snpEff/data/$DATABASE" ]; then
    echo "Downloading SnpEff database..."
    snpEff download "$DATABASE"
fi

SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Annotating $SAMPLE..."

    snpEff \
        -v \
        "$DATABASE" \
        "$INPUT_DIR/${SAMPLE}_filtered_renamed.vcf" \
        > "$OUTPUT_DIR/${SAMPLE}_annotated.vcf"

done

echo "Annotation completed successfully."
