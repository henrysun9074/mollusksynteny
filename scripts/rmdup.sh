#!/bin/bash
#SBATCH --job-name=remove_duplicates
#SBATCH --output=/work/hs325/mollusk_synteny/logs/rmdup.out
#SBATCH --error=/work/hs325/mollusk_synteny/logs/rmdup.err
#SBATCH --partition=common
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hs325@duke.edu

# run this script to remove duplicates from protein file

# test later on
# agat_sp_keep_longest_isoform.pl -fasta input.faa -gff input.gff3 -o longest_proteins.faa

################## GENERATE DEDUPLICATED FAA FILE
root="/work/hs325/mollusk_synteny/ref/edulis/ncbi_dataset/data/GCF_947568905.1"
cd $root
find . -type f -name "*.faa" -exec sh -c 'seqkit rmdup -s "$1" > "${1%.faa}_dedup.faa"' _ {} \;

################## GENERATE CORRESPONDING CHROM FILE FROM FAA FILE ENTRIES
python3 - <<'PY'
import os
import glob
import gzip

# adjust this for folders if you don't want to rerun it on entire base directory 
root = "/work/hs325/mollusk_synteny/ref/edulis"

def open_maybe_gzip(path):
    return gzip.open(path, "rt") if path.endswith(".gz") else open(path, "r")

def fasta_headers(path):
    headers = set()
    with open_maybe_gzip(path) as fh:
        for line in fh:
            if line.startswith(">"):
                h = line[1:].strip()
                headers.add(h)                 # full header
                headers.add(h.split()[0])      # first token
    return headers

chrom_files = []
for dirpath, _, filenames in os.walk(root):
    for fn in filenames:
        if fn.endswith(".chrom"):
            chrom_files.append(os.path.join(dirpath, fn))

for chrom in sorted(chrom_files):
    d = os.path.dirname(chrom)

    protein_candidates = sorted(set(
        glob.glob(os.path.join(d, "*dedup*.faa")) +
        glob.glob(os.path.join(d, "*dedup*.fasta.gz")) +
        glob.glob(os.path.join(d, "*deduplicated*.faa")) +
        glob.glob(os.path.join(d, "*deduplicated*.fasta.gz")) + 
        glob.glob(os.path.join(d, "*rmdup*.fasta.gz"))
    ))

    if not protein_candidates:
        print(f"[WARN] No dedup protein file found for: {chrom}")
        continue

    if len(protein_candidates) > 1:
        print(f"[WARN] Multiple dedup protein files found for: {chrom}")
        for p in protein_candidates:
            print(f"       {p}")
        print(f"       Using: {protein_candidates[0]}")

    protein_file = protein_candidates[0]
    keep = fasta_headers(protein_file)

    out = chrom[:-6] + "_dedup.chrom"   # replace .chrom with _dedup.chrom

    total = 0
    kept = 0
    with open(chrom, "r") as fin, open(out, "w") as fout:
        for line in fin:
            if not line.strip():
                continue
            total += 1
            protein_id = line.rstrip("\n").split("\t")[0]
            if protein_id in keep:
                fout.write(line)
                kept += 1

    removed = total - kept
    print(f"[OK] {chrom}")
    print(f"     protein file: {protein_file}")
    print(f"     kept: {kept}  removed: {removed}  output: {out}")
PY

