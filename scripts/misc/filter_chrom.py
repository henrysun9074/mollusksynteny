import os

# Define your file mapping: { "Input_Raw_Chrom": "Output_Filtered_Chrom" }
file_map = {
    # "/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria.chrom": 
    # "/work/hs325/mollusk_synteny/ref/hardclam/ncbi_dataset/data/GCF_021730395.1/mercenaria_unique.chrom",
    
    # "/work/hs325/mollusk_synteny/ref/solidissima/solidissima.chrom": 
    # "/work/hs325/mollusk_synteny/ref/solidissima/solidissima_unique.chrom",

    # "/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/yesso_scallop.chrom":
    # "/work/hs325/mollusk_synteny/ref/yesso_scallop/ncbi_dataset/data/GCF_002113885.1/yesso_scallop_unique.chrom"

    "/work/hs325/mollusk_synteny/ref/pinctada/pinctada.chrom":
    "/work/hs325/mollusk_synteny/ref/pinctada/pinctada_unique.chrom",

    "/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam.chrom": 
    "/work/hs325/mollusk_synteny/ref/giantclam/ncbi_dataset/data/GCA_945859785.2/giantclam_unique.chrom",

    "/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas.chrom": 
    "/work/hs325/mollusk_synteny/ref/gigas/ncbi_dataset/data/GCF_963853765.1/gigas_unique.chrom"
}

for input_path, output_path in file_map.items():
    if not os.path.exists(input_path):
        print(f"Skipping: {input_path} (File not found)")
        continue

    print(f"Processing: {os.path.basename(input_path)}...")
    
    seen_coords = {}  # Key: (scaffold, start, stop), Value: full_line
    total_lines = 0

    with open(input_path, 'r') as f_in:
        for line in f_in:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            total_lines += 1
            parts = line.split('\t')
            
            # Based on ODP specs: 
            # index 0: protein_id, 1: scaffold, 2: strand, 3: start, 4: stop
            try:
                scaffold = parts[1]
                start = parts[3]
                stop = parts[4]
                
                coord_key = (scaffold, start, stop)
                
                # Only keep the first isoform found at these coordinates
                if coord_key not in seen_coords:
                    seen_coords[coord_key] = line
            except IndexError:
                continue

    # Write the unique lines to the new file
    with open(output_path, 'w') as f_out:
        for unique_line in seen_coords.values():
            f_out.write(unique_line + '\n')

    removed = total_lines - len(seen_coords)
    print(f"  Done. Kept {len(seen_coords)} unique loci (Removed {removed} isoforms).\n")

print("All files processed.")