#!/bin/bash
set -e

# ==========================================================
# Binary SNP Matrix Construction
#
# Builds a binary mutation matrix where:
#
# 1 = mutation present
# 0 = mutation absent
#
# Rows   : mutations
# Columns: isolates
# ==========================================================

INPUT_DIR=~/projects/multistrain_stress/result/mutation_matrix

cd "$INPUT_DIR"

echo -e "Mutation\tDH10B\tHE50\tHE100\tHE150" > snp_matrix.tsv

SAMPLES=("DH10B" "HE_50" "HE_100" "HE_150")

while read -r MUTATION
do
    ROW="$MUTATION"

    for SAMPLE in "${SAMPLES[@]}"
    do
        if grep -q "^${MUTATION}" "${SAMPLE}.mutations.id.tsv"
        then
            ROW="${ROW}\t1"
        else
            ROW="${ROW}\t0"
        fi
    done

    echo -e "$ROW"

done < all_mutations.txt >> snp_matrix.tsv

echo "Binary SNP matrix generated successfully"
