#!/bin/bash
#SBATCH --job-name=odp
#SBATCH --output=/work/hs325/mollusk_synteny/logs/odp_synteny_%j.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/odp_synteny_%j.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu  

# activate environment and switch to directory with config file
source ~/.bashrc
mamba activate odp_env
cd /work/hs325/mollusk_synteny/results

## output directory - run this before you run the whole job, to move config file into there
run_name="Apr3_oysters"
mkdir -p $run_name
cd $run_name
pwd 

## edit config file 
# vim config.yaml

# run snakemake using --cores to match your cpus-per-task
snakemake -r -p \
    --snakefile /work/hs325/mollusk_synteny/odp/scripts/odp \
    --configfile /work/hs325/mollusk_synteny/scripts/config.yaml \
    --cores 10 \
    --rerun-incomplete