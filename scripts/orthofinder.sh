#!/bin/bash
#SBATCH --job-name=genespace
#SBATCH --output=/work/hs325/mollusk_synteny/logs/genespace.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/genespace.err
#SBATCH --partition=common
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu

source ~/.bashrc

# remove previous empty directory if exists
rm -rf /work/hs325/mollusk_synteny/results/genespace/orthofinder/

source /hpc/group/schultzlab/hs325/miniconda3/etc/profile.d/conda.sh
conda activate orthofinder
orthofinder -f /work/hs325/mollusk_synteny/results/genespace/tmp -t 16 -a 1 -X -o /work/hs325/mollusk_synteny/results/genespace/orthofinder

# module load R/4.4.0
# module load GLPK
# export R_LIBS_USER=/hpc/home/hs325/R/4.4
# Rscript genespace.R