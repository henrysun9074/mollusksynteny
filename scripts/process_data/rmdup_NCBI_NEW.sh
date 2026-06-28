###########################################
# NEW - keep only protein coding genes from NCBI assembly using cds

# change into reference directory
cd /work/hs325/cvpan/pangenome/analysis/assemblies/orthofinder/ref

# define file paths
CDS_FASTA="pecten/data/GCF_902652985.1/cds_from_genomic.fna"
RAW_PROTEIN="pecten/data/GCF_902652985.1/protein.faa"
INTERMEDIATE_LOCUS="pecten/data/GCF_902652985.1/protein_to_locus_map.txt"
FINAL_PROTEIN="pecten/data/GCF_902652985.1/Pmaximus.faa"

# create a clean mapping file of Protein_ID -> Parent_LOC_ID directly from the CDS headers
grep "^>" "$CDS_FASTA" | awk '{
    prot = ""
    gene = ""
    if (match($0, /protein_id=([^\] ]+)/)) {
        prot = substr($0, RSTART+11, RLENGTH-11)
    }
    if (match($0, /gene=(LOC[0-9]+)/)) {
        gene = substr($0, RSTART+5, RLENGTH-5)
    }
    if (prot != "" && gene != "") {
        print prot "\t" gene
    }
}' | sort -u > "$INTERMEDIATE_LOCUS"

# parse the raw protein file, map alternative transcripts to genes, and keep the longest
awk -F'\t' '
# Load the mapping file into memory
NR==FNR { prot_to_gene[$1] = $2; next }

# Parse the protein FASTA file records
/^>/ {
    # Process and save the previous record if it belongs to a valid protein-coding locus
    if (current_gene != "") {
        if (seq_len[current_gene] == 0 || current_len > seq_len[current_gene]) {
            seq_header[current_gene] = current_header
            seq_data[current_gene] = current_seq
            seq_len[current_gene] = current_len
        }
    }
    
    current_header = $0
    current_seq = ""
    current_len = 0
    
    # Strip the leading ">" and isolate the raw accession number (e.g., XP_078320203.1)
    split(substr($1, 2), arr, " ")
    clean_accession = arr[1]
    
    # Map the accession number to its parent gene group
    if (clean_accession in prot_to_gene) {
        current_gene = prot_to_gene[clean_accession]
    } else {
        current_gene = "" # Skips non-coding transcripts or anomalies absent from the CDS file
    }
    next
}
{
    if (current_gene != "") {
        current_seq = current_seq $0 "\n"
        current_len += length($0)
    }
}
END {
    # Process the final record in the file
    if (current_gene != "" && (seq_len[current_gene] == 0 || current_len > seq_len[current_gene])) {
        seq_header[current_gene] = current_header
        seq_data[current_gene] = current_seq
    }
    # Output exactly one longest protein sequence per unique coding locus group
    for (g in seq_header) {
        printf "%s\n%s", seq_header[g], seq_data[g]
    }
}' "$INTERMEDIATE_LOCUS" "$RAW_PROTEIN" > "$FINAL_PROTEIN"
grep -c ">" $FINAL_PROTEIN

grep "^Target" $FINAL_PROTEIN || grep "^>" $FINAL_PROTEIN | \
awk '{ if (match($0, /LOC[0-9]+/)) { print substr($0, RSTART, RLENGTH) } else { print $1 } }' | \
sort | uniq -c | sort -nr | head -n 5