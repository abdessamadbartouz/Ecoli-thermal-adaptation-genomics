#!/bin/bash
set -e

# ==========================================================
# Mutation Extraction
# Extracts unique mutation identifiers from annotated VCF files.
# Each mutation is represented as:
#
# CHROM_POS_REF_ALT
#
# A global list containing all unique mutations detected across
# all isolates is also generated.
# ==========================================================

INPUT_DIR=~/projects/multistrain_stress/result/renamed/ecoli
OUTPUT_DIR=~/projects/multistrain_stress/result/mutation_matrix

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

cp "$INPUT_DIR"/*_filtered_renamed.vcf .

echo "Extracting mutations..."

for VCF in *_filtered_renamed.vcf
do
    SAMPLE=$(basename "$VCF" _filtered_renamed.vcf)

    bcftools query \
        -f '%CHROM\t%POS\t%REF\t%ALT\n' \
        "$VCF" \
        > "${SAMPLE}.mutations.tsv"

    awk 'BEGIN{OFS="\t"}{
        ID=$1"_"$2"_"$3"_"$4
        print ID,$0
    }' "${SAMPLE}.mutations.tsv" \
        > "${SAMPLE}.mutations.id.tsv"

    echo "✓ $SAMPLE processed"

done

cat *.mutations.id.tsv \
| cut -f1 \
| sort \
| uniq \
> all_mutations.txt

echo "Global mutation list generated."
