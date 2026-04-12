#!/bin/bash
#SBATCH --job-name=odp_master
#SBATCH --output=/work/hs325/mollusk_synteny/logs/GFF2chrom.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/GFF2chrom.err
#SBATCH --partition=schultzlab
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu

mamba activate odp_env

# this step filters chrom files to just keep 1 of the longest isoform per gene ID
python3 filter_chrom.py


# the following steps filters the amino acids to match the chrom files
# 1. Mercenaria
echo "Processing Mercenaria..."
CHROM="/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria_unique.chrom"
IN_FAA="/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/protein.faa"
OUT_FAA="/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria_unique.faa"

awk '{print $1}' "$CHROM" > mercenaria_ids.tmp
seqkit grep -f mercenaria_ids.tmp "$IN_FAA" -o "$OUT_FAA"
rm mercenaria_ids.tmp
echo "  Saved to: $OUT_FAA"

# 2. Solidissima
echo "Processing Solidissima..."
CHROM="/work/hs325/mollusk_synteny/ref/solidissima/solidissima_unique.chrom"
IN_PEP="/work/hs325/mollusk_synteny/ref/solidissima/SSo_protein.pep"
OUT_FAA="/work/hs325/mollusk_synteny/ref/solidissima/solidissima_unique.faa"

awk '{print $1}' "$CHROM" > solidissima_ids.tmp
seqkit grep -f solidissima_ids.tmp "$IN_PEP" -o "$OUT_FAA"
rm solidissima_ids.tmp
echo "  Saved to: $OUT_FAA"


# 3. Scallop
echo "Processing Scallop..."
CHROM="/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/yesso_scallop_unique.chrom"
IN_PEP="/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/protein.faa"
OUT_FAA="/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/scallop_unique.faa"

awk '{print $1}' "$CHROM" > scallop_ids.tmp
seqkit grep -f scallop_ids.tmp "$IN_PEP" -o "$OUT_FAA"
rm scallop_ids.tmp
echo "  Saved to: $OUT_FAA"


############### more to be done later

# # 4. Giant Clam
# echo "Processing Giant Clam..."
# CHROM="/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam_unique.chrom"
# IN_FAA="/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/protein.faa"
# OUT_FAA="/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam_unique.faa"

# awk '{print $1}' "$CHROM" > giantclam_ids.tmp
# seqkit grep -f giantclam_ids.tmp "$IN_FAA" -o "$OUT_FAA"
# rm giantclam_ids.tmp
# echo "  Saved to: $OUT_FAA"

# # 5. Gigas
# echo "Processing Gigas..."
# CHROM="/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas_unique.chrom"
# IN_FAA="/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/protein.faa"
# OUT_FAA="/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas_unique.faa"

# awk '{print $1}' "$CHROM" > gigas_ids.tmp
# seqkit grep -f gigas_ids.tmp "$IN_FAA" -o "$OUT_FAA"
# rm gigas_ids.tmp
# echo "  Saved to: $OUT_FAA"
