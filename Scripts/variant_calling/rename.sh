#!/bin/bash

for HE in DH10B HE_50 HE_100 HE_150
do
	bcftools annotate \
	--rename-chrs chrom_names.txt \
	${HE}_filtered.vcf -o ${HE}_filtered_renamed.vcf
echo "===== ${HE}_filtered_renamed.vcf ====="
done
