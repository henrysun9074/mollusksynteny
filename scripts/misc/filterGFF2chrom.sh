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

# source ~/.bashrc
mamba activate odp_env
cd /work/hs325/mollusk_synteny/odp/scripts

# Define log directory
LOG_DIR="/work/hs325/mollusk_synteny/logs/agat"
mkdir -p "$LOG_DIR"

process_species() {
    local GFF=$1
    local OUT_CHROM=$2
    local CUSTOM_SCRIPT=$3 # Optional: specify if using _custom.py
    
    local SP_NAME=$(basename "$OUT_CHROM" .chrom)
    local DIR=$(dirname "$GFF")
    local FILTERED_GFF="${GFF%.*}_longest.gff"
    
    # Adjust naming for .gz files
    if [[ "$GFF" == *.gz ]]; then
        FILTERED_GFF="${GFF%.*.*}_longest.gff"
    fi

    echo "--- Processing: $SP_NAME ---"
    
    echo "Filtering longest isoforms (Logs: $LOG_DIR/${SP_NAME}_agat.log)..."
    # Redirecting both stdout and stderr to the log file
    agat_sp_keep_longest_isoform.pl --gff "$GFF" -o "$FILTERED_GFF" > "$LOG_DIR/${SP_NAME}_agat.log" 2>&1

    echo "Generating .chrom file..."
    if [ -n "$CUSTOM_SCRIPT" ]; then
        python3 "$CUSTOM_SCRIPT" "$FILTERED_GFF" > "$OUT_CHROM"
    else
        python3 NCBIgff2chrom.py "$FILTERED_GFF" > "$OUT_CHROM"
    fi
}

echo "Starting workflow..."

# Giant Clam
process_species "/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/genes.gff3.gz" \
                "/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam.chrom"

# Gigas
process_species "/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/genomic.gff" \
                "/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas.chrom"

# Mercenaria
process_species "/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/genomic.gff" \
                "/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria.chrom"

# # Manila
# process_species "/work/hs325/mollusk_synteny/ref/manila/ncbi_dataset/data/GCF_026571515.1/genomic.gff" \
#                 "/work/hs325/mollusk_synteny/ref/manila/ncbi_dataset/data/GCF_026571515.1/manila.chrom"

# # Saxidomus
# process_species "/work/hs325/mollusk_synteny/ref/saxidomus/ncbi_dataset/data/GCA_022818135.2/genes.gff3.gz" \
#                 "/work/hs325/mollusk_synteny/ref/saxidomus/ncbi_dataset/data/GCA_022818135.2/venus.chrom"

# Mytilus
process_species "/work/hs325/mollusk_synteny/ref/mytilus/ncbi_dataset/data/GCF_963676685.1/genomic.gff" \
                "/work/hs325/mollusk_synteny/ref/mytilus/ncbi_dataset/data/GCF_963676685.1/mytilus.chrom"

# Softshell
process_species "/work/hs325/mollusk_synteny/ref/softshell/ncbi_dataset/data/GCF_026914265.1/genomic.gff" \
                "/work/hs325/mollusk_synteny/ref/softshell/ncbi_dataset/data/GCF_026914265.1/softshell.gff"

# Solida
process_species "/work/hs325/mollusk_synteny/ref/solida/genes.gff3" \
                "/work/hs325/mollusk_synteny/ref/solida/solida.chrom"

# Scallop
process_species "/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/genomic.gff" \
                "/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/scallop.chrom"

# Solidissima (Using Custom Script)
# process_species "/work/hs325/mollusk_synteny/ref/solidissima/SSo_feature.gff3" \
#                 "/work/hs325/mollusk_synteny/ref/solidissima/solidissima.chrom" \
#                 "/work/hs325/mollusk_synteny/scripts/NCBIgff2chrom_custom.py"

# Pearl Oyster (Using Custom Script)
# process_species "/work/hs325/mollusk_synteny/ref/pinctada/pfuV4.1HapA_ref_genemodels.gff.gz" \
#                 "/work/hs325/mollusk_synteny/ref/pinctada/pinctada.chrom" \
#                 "/work/hs325/mollusk_synteny/scripts/NCBIgff2chrom_custom.py"

echo "All species finished."


