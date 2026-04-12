# 1. Define your variables
INPUT_DIR="/work/hs325/mollusk_synteny/results/Apr3_oysters/odp/step2-figures/synteny_coloredby_BCnS_LGs"
OUTPUT_DIR="/work/hs325/mollusk_synteny/results/Apr3_oysters/odp/step2-figures/synteny_BCnS_filtered"

# 2. Create the new directory
mkdir -p "$OUTPUT_DIR"

# 3. Loop through each RBH file
for file in "$INPUT_DIR"/*.rbh; do
    filename=$(basename "$file")
    echo "Processing $filename..."

    # Use awk to filter. 
    # $5 is typically the X_scaf column and $7 is the Y_scaf column in ODP RBH files.
    # Adjust the field numbers ($5, $7) if your column order is different.
    awk -F'\t' '
    NR==1 {print; next} 
    {
        # Define the regex for the allowed contigs
        allowed_ctg = "^(ctg1|ctg2|ctg3|ctg277|ctg278|ctg279)$"
        
        # Check X_scaf ($5) and Y_scaf ($7)
        # Skip if starts with NW
        if ($5 ~ /^NW/ || $7 ~ /^NW/) next;
        
        # Skip if starts with ctg but is NOT in the allowed list
        if (($5 ~ /^ctg/ && $5 !~ allowed_ctg) || ($7 ~ /^ctg/ && $7 !~ allowed_ctg)) next;
        
        # If it passed all checks, print the row
        print $0
    }' "$file" > "$OUTPUT_DIR/$filename"

done

echo "Filtering complete. Files are in $OUTPUT_DIR"