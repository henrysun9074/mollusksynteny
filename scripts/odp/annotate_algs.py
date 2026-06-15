import pandas as pd

# Load the groupby file
f = "/work/hs325/mollusk_synteny/results/odp/odp_groupby_filter/output/PatellaVulgata_BathyacmaeaLactea_BerghiaStephanieae_GigantopeltaAegis_HaliotisAsinina_LittorinaSaxatilis_PectenMaximus_reciprocal_best_hits.rbh.filt.groupby"

df = pd.read_csv(f, sep='\t')

# Sort by count descending, assign names
df = df.sort_values('count', ascending=False).reset_index(drop=True)
df['gene_group'] = ['GC' + str(i+1) for i in range(len(df))]

# Save
df.to_csv(f.replace('.filt.groupby', '.filt.annotated.groupby'), sep='\t', index=False)
print(df[['gene_group', 'count']])