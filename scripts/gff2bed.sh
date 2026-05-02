#!/bin/bash

cd /work/hs325/mollusk_synteny/ref

declare -A genome_map
genome_map=(
    ["limpet"]="gastropods/limpet/ncbi_dataset/data/GCF_932274485.2/genomic.gff"
    ["scallop"]="pecten/ncbi_dataset/data/GCF_902652985.1/genomic.gff"
    ["solidissima"]="solidissima/SSo_feature.gff3"
    ["edulis"]="mytilus/ncbi_dataset/data/GCF_963676685.1/genomic.gff"
    ["virginica"]="virginica/ru2025asm/Cvi_RU25.gff3"
)

for species in "${!genome_map[@]}"; do
    input_gff="${genome_map[$species]}"
    output_bed="genespace_refs/${species}.bed"
    
    echo "Processing $species..."

    if [[ "$input_gff" == *"ncbi_dataset"* ]]; then
        awk -F'\t' 'BEGIN{OFS="\t"} $3=="CDS" {
            split($9, a, ";"); 
            for(i in a) {
                if(a[i] ~ /^Name=/) {
                    sub(/^Name=/, "", a[i]);
                    print $1, $4, $5, a[i];
                    break;
                }
            }
        }' "$input_gff" | awk -F'\t' '!seen[$4]++' > "$output_bed"

    else
        # EVM/Custom Logic
        # 1. Grab Chrom, Start, End, and the ID attribute
        # 2. Use sed to extract the ID value from 'ID=...'
        awk -F'\t' '$3=="mRNA" {print $1"\t"$4"\t"$5"\t"$9}' "$input_gff" | \
        sed -E 's/ID=([^; ]+).*/\1/' | \
        awk -v OFS='\t' '{print $1, $2, $3, $4}' | \
        awk '!seen[$4]++' > "$output_bed"
    fi
    
    echo "Done: $output_bed"
done