#!/bin/bash

for vcf in DH10B.vcf HE_100.vcf HE_150.vcf HE_50.vcf
do
    base=$(basename "$vcf" .vcf)

    (
    echo -e "CHROM\tPOS\tREF\tALT\tQUAL\tDP\tMQ"
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%DP\t%MQ\n' "$vcf"
    ) > "${base}.tsv"

    echo "Generated ${base}.tsv"
done
