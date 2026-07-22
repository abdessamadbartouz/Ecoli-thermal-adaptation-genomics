#!/bin/bash
set -e

# ==========================================================
# Variant Calling with iVar
# Calls variants from mapped BAM files and filters variants
# based on minimum depth and allele frequency.
# ==========================================================

# Reference files
REF=~/projects/multistrain_stress/reference/ecoli/ecoli_DH10B_reference.fna
GFF=~/projects/multistrain_stress/reference/ecoli/ecoli_DH10B.gff

# Input and output directories
INPUT_DIR=~/projects/multistrain_stress/result/mapping/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/variants/ivar

mkdir -p "$OUTPUT_DIR"

SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Calling variants for $SAMPLE..."

    samtools mpileup \
        -aa \
        -A \
        -d 9000 \
        -B \
        -Q 0 \
        -f "$REF" \
        "$INPUT_DIR/${SAMPLE}.sorted.bam" \
    | ivar variants \
        -p "$OUTPUT_DIR/$SAMPLE" \
        -q 20 \
        -t 0.03 \
        -r "$REF" \
        -g "$GFF"

    awk 'NR==1 || ($8 >= 3 && $11 >= 0.05)' \
        "$OUTPUT_DIR/${SAMPLE}.tsv" \
        > "$OUTPUT_DIR/filtered_${SAMPLE}.tsv"

    echo -n "$SAMPLE: "
    wc -l "$OUTPUT_DIR/filtered_${SAMPLE}.tsv"

done

echo "iVar variant calling completed."
