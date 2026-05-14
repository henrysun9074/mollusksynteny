#!/bin/bash
#SBATCH --job-name=jcvi
#SBATCH --output=/work/hs325/mollusk_synteny/logs/jcvi.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/jcvi.err
#SBATCH --partition=schultzlab
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu  

# conda init
conda activate jcvi

# ######XG2017
# cd /work/hs325/mollusk_synteny/ref/virginica/xg2017asm/data/GCF_002022765.2
# python3 -m jcvi.formats.gff bed --type=mRNA --key=Name genomic.gff -o cv2017xg.bed
# python3 -m jcvi.formats.fasta format cds_from_genomic.fna cv2017xg.cds

# ######XG2025
# cd /work/hs325/mollusk_synteny/ref/virginica/ru2025asm
# python3 -m jcvi.formats.gff bed --type=mRNA --key=Name Cvi_RU25.gff3 -o cv2025ru.bed
# python3 -m jcvi.formats.fasta format Cvi_RU25.cds cv2025ru.cds

# ######YALE2025
# cd /work/hs325/mollusk_synteny/ref/virginica/yale2025asm/data/GCF_053477285.1
# python3 -m jcvi.formats.gff bed --type=mRNA --key=Name genomic.gff -o cv2025yale.bed
# python3 -m jcvi.formats.fasta format cds_from_genomic.fna cv2025yale.cds

# ## if isoforms are excessive add --primary_only flag to bed file generation
# ###$ python -m jcvi.formats.gff bed --type=mRNA --key=Name --primary_only Vvinifera_145_Genoscope.12X.gene.gff3.gz -o grape.bed

# ## move all bed and cds files to directory in results for orthology analysis
# cd /work/hs325/moll*/results/Apr3_oysters_jcvi

# cp /work/hs325/mollusk_synteny/ref/virginica/yale2025asm/data/GCF_053477285.1/cv2025yale.bed cv2025yale.bed
# cp /work/hs325/mollusk_synteny/ref/virginica/yale2025asm/data/GCF_053477285.1/cv2025yale.cds cv2025yale.cds

# cp /work/hs325/mollusk_synteny/ref/virginica/ru2025asm/cv2025ru.bed cv2025ru.bed
# cp /work/hs325/mollusk_synteny/ref/virginica/ru2025asm/cv2025ru.cds cv2025ru.cds

# cp /work/hs325/mollusk_synteny/ref/virginica/xg2017asm/data/GCF_002022765.2/cv2017xg.bed cv2017xg.bed
# cp /work/hs325/mollusk_synteny/ref/virginica/xg2017asm/data/GCF_002022765.2/cv2017xg.cds cv2017xg.cds

#################################################################################################################
cd /work/hs325/moll*/results/Apr3_oysters_jcvi

## all pairwise runs

# for error lastal: can't open file cv2025yale.ssp: No such file or directory    
# run rm cv2025yale.prj to recreate index files

python3 -m jcvi.compara.catalog ortholog cv2025ru cv2025yale --no_strip_names
python3 -m jcvi.compara.catalog ortholog cv2017xg cv2025yale --no_strip_names 
python3 -m jcvi.compara.catalog ortholog cv2017xg cv2025ru --no_strip_names

## dotplots and synteny depth 
# python -m jcvi.compara.catalog ortholog grape peach --cscore=.99 --no_strip_names
# python -m jcvi.graphics.dotplot grape.peach.anchors
# python -m jcvi.compara.synteny depth --histogram grape.peach.anchors

## ribbon diagram