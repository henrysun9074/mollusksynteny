#!/bin/bash
#SBATCH --job-name=iqtree
#SBATCH --output=/work/hs325/mollusk_synteny/logs/iqtree.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/iqtree.err
#SBATCH --partition=common
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=30:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rrw34@duke.edu

mkdir -p /work/hs325/mollusk_synteny/results/iqtree/mollusk_phylo_rustica

iqtree \
  -s /work/hs325/mollusk_synteny/results/orthofinder_phylo2/Results_Jun14/MultipleSequenceAlignments/SpeciesTreeAlignment.fa \
  -m MFP \
  -B 1000 \
  --alrt 1000 \
  -T AUTO \
  --prefix /work/hs325/mollusk_synteny/results/iqtree/mollusk_phylo_rustica/mollusk_phylo_rustica