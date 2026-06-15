# Create groupby file
snakemake --snakefile /work/hs325/mollusk_synteny/odp/scripts/odp_rbh_to_groupby \
    --configfile /work/hs325/mollusk_synteny/scripts/odp/config.yaml \
    --cores 4

#Filter groupby file
snakemake --snakefile /work/hs325/mollusk_synteny/odp/scripts/odp_groupby_filter \
    --configfile /work/hs325/mollusk_synteny/scripts/odp/config.yaml \
    --cores 4