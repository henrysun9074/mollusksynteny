#!/bin/bash
#SBATCH --job-name=GFF2chrom
#SBATCH --output=/work/hs325/mollusk_synteny/logs/GFF2chrom.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/GFF2chrom.err
#SBATCH --partition=schultzlab
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu

source ~/.bashrc
mamba activate odp_env
cd /work/hs325/mollusk_synteny/odp/scripts

##################################################################################
echo "starting gff2chrom for each species"

# this script handles gzipped files 

## gastropods
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/gastropods/limpet/ncbi_dataset/data/GCF_932274485.2/genomic.gff \
   > /work/hs325/mollusk_synteny/ref/gastropods/limpet/ncbi_dataset/data/GCF_932274485.2/limpet.chrom

python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/gastropods/littorina/ncbi_dataset/data/GCF_037325665.1/genomic.gff \
   > /work/hs325/mollusk_synteny/ref/gastropods/littorina/ncbi_dataset/data/GCF_037325665.1/littorina.chrom


# giant clam
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/genes.gff3.gz \
    > /work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam.chrom

# gigas
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas.chrom

# mercenaria
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria.chrom

# manila
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/manila/ncbi_dataset/data/GCF_026571515.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/manila/ncbi_dataset/data/GCF_026571515.1/manila.chrom

# saxidomus
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/saxidomus/ncbi_dataset/data/GCA_022818135.2/genes.gff3.gz \
    > /work/hs325/mollusk_synteny/ref/saxidomus/ncbi_dataset/data/GCA_022818135.2/venus.chrom

# mytilus ed.
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/mytilus/ncbi_dataset/data/GCF_963676685.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/mytilus/ncbi_dataset/data/GCF_963676685.1/mytilus.chrom

# softshell
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/softshell/ncbi_dataset/data/GCF_026914265.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/softshell/ncbi_dataset/data/GCF_026914265.1/softshell.chrom

# solida
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/solida/genes.gff3 \
    > /work/hs325/mollusk_synteny/ref/solida/solida.chrom

# solidissima
python3 NCBIgff2chrom_custom.py /work/hs325/mollusk_synteny/ref/solidissima/SSo_feature.gff3 \
    > /work/hs325/mollusk_synteny/ref/solidissima/solidissima.chrom

# yesso scallop
python3 NCBIgff2chrom_custom.py /work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/yesso_scallop.chrom

# pearl oyster
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/pinctada/pfuV4.1HapA_ref_genemodels.gff.gz \
    > /work/hs325/mollusk_synteny/ref/pinctada/pinctada.chrom

# pecten
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/pecten/ncbi_dataset/data/GCF_902652985.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/pecten/ncbi_dataset/data/GCF_902652985.1/pecten.chrom

# virginica 2017
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/virginica/xg2017asm/data/GCF_002022765.2/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/virginica/xg2017asm/data/virginica2017.chrom 

# virginica Yale 2025
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/virginica/yale2025asm/data/GCF_053477285.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/virginica/yale2025asm/data/GCF_053477285.1/virginica2025yale.chrom 

# virginica XG 2025 
python3 /work/hs325/mollusk_synteny/scripts/NCBIgff2chrom_custom.py /work/hs325/mollusk_synteny/ref/virginica/ru2025asm/Cvi_RU25.gff3 \
    > /work/hs325/mollusk_synteny/ref/virginica/ru2025asm/virginica2025XG.chrom

# Ostrea edulis
python3 NCBIgff2chrom.py /work/hs325/mollusk_synteny/ref/edulis/ncbi_dataset/data/GCF_947568905.1/genomic.gff \
    > /work/hs325/mollusk_synteny/ref/edulis/ncbi_dataset/data/GCF_947568905.1/edulis.chrom