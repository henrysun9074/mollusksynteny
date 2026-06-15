library(macrosyntR)
library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)
library(paletteer)
library(tidyr)

setwd("/work/hs325/mollusk_synteny")

# ── 1. Prepare single-copy orthologs ─────────────────────────────────────────
# Run in bash first:
# cd /work/hs325/mollusk_synteny/results

# {
#   head -n 1 orthofinder_gastropods/Results_May14/Orthogroups/Orthogroups.tsv
#   grep -Ff orthofinder_gastropods/Results_May14/Orthogroups/Orthogroups_SingleCopyOrthologues.txt \
#     orthofinder_gastropods/Results_May14/Orthogroups/Orthogroups.tsv
# } > orthofinder_gastropods/Results_May14/Orthogroups/Single_copy_orthologs.tsv

ortho_raw <- read.table(
  "results/orthofinder_gastropods/Results_May14/Orthogroups/Single_copy_orthologs.tsv",
  header = TRUE,
  sep = "\t",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

ortho_ready <- ortho_raw[, c(
  "Patella_vulgata",
  "Bathyacmaea_lactea",
  "Berghia_stephanieae",
  "Gigantopelta_aegis",
  "Haliotis_asinina",
  "Littorina_saxatilis",
  "Pecten_maximus"
)]

write.table(
  ortho_ready,
  "results/orthofinder_gastropods/Results_May14/Orthogroups/temp_ortho_for_macrosyntR.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = TRUE
)

# ── 2. Bed file paths (must match column order above) ────────────────────────
my_bed_paths <- c(
  "ref/beds_macrosyntr/Patella_vulgata.bed",
  "ref/beds_macrosyntr/Bathyacmaea_lactea.bed",
  "ref/beds_macrosyntr/Berghia_stephanieae.bed",
  "ref/beds_macrosyntr/Gigantopelta_aegis.bed",
  "ref/beds_macrosyntr/Haliotis_asinina.bed",
  "ref/beds_macrosyntr/Littorina_saxatilis.bed",
  "ref/beds_macrosyntr/Pecten_maximus.bed"
)

# ── 3. Load orthologs ─────────────────────────────────────────────────────────
my_orthologs_table <- load_orthologs(
  orthologs_table = "results/orthofinder_gastropods/Results_May14/Orthogroups/temp_ortho_for_macrosyntR.tsv",
  bedfiles = my_bed_paths
)

# ── 4. Clean up chromosome names ─────────────────────────────────────────────
my_orthologs_cleaned <- my_orthologs_table %>%

  # sp1: Patella vulgata — NC_065879.2-NC_065887.2 = chr 1-9, remove NW_
  filter(!str_detect(sp1.Chr, "^NW")) %>%
  mutate(sp1.Chr = case_when(
    sp1.Chr == "NC_065879.2" ~ "1",
    sp1.Chr == "NC_065880.2" ~ "2",
    sp1.Chr == "NC_065881.2" ~ "3",
    sp1.Chr == "NC_065882.2" ~ "4",
    sp1.Chr == "NC_065883.2" ~ "5",
    sp1.Chr == "NC_065884.2" ~ "6",
    sp1.Chr == "NC_065885.2" ~ "7",
    sp1.Chr == "NC_065886.2" ~ "8",
    sp1.Chr == "NC_065887.2" ~ "9",
    TRUE ~ sp1.Chr
  )) %>%

  # sp2: Bathyacmaea — chr1-chr10, strip "chr" prefix
  mutate(sp2.Chr = str_remove(sp2.Chr, "^chr")) %>%
  filter(sp2.Chr %in% as.character(1:10)) %>%

  # sp3: Berghia — NC_088360.1-NC_088374.1 = chr 1-15, remove NW_
  filter(!str_detect(sp3.Chr, "^NW")) %>%
  mutate(sp3.Chr = case_when(
    sp3.Chr == "NC_088360.1" ~ "1",
    sp3.Chr == "NC_088361.1" ~ "2",
    sp3.Chr == "NC_088362.1" ~ "3",
    sp3.Chr == "NC_088363.1" ~ "4",
    sp3.Chr == "NC_088364.1" ~ "5",
    sp3.Chr == "NC_088365.1" ~ "6",
    sp3.Chr == "NC_088366.1" ~ "7",
    sp3.Chr == "NC_088367.1" ~ "8",
    sp3.Chr == "NC_088368.1" ~ "9",
    sp3.Chr == "NC_088369.1" ~ "10",
    sp3.Chr == "NC_088370.1" ~ "11",
    sp3.Chr == "NC_088371.1" ~ "12",
    sp3.Chr == "NC_088372.1" ~ "13",
    sp3.Chr == "NC_088373.1" ~ "14",
    sp3.Chr == "NC_088374.1" ~ "15",
    TRUE ~ sp3.Chr
  )) %>%

  # sp4: Gigantopelta — NC_054699.1-NC_054713.1 = chr 1-15, remove NW_
  filter(!str_detect(sp4.Chr, "^NW")) %>%
  mutate(sp4.Chr = case_when(
    sp4.Chr == "NC_054699.1" ~ "1",
    sp4.Chr == "NC_054700.1" ~ "2",
    sp4.Chr == "NC_054701.1" ~ "3",
    sp4.Chr == "NC_054702.1" ~ "4",
    sp4.Chr == "NC_054703.1" ~ "5",
    sp4.Chr == "NC_054704.1" ~ "6",
    sp4.Chr == "NC_054705.1" ~ "7",
    sp4.Chr == "NC_054706.1" ~ "8",
    sp4.Chr == "NC_054707.1" ~ "9",
    sp4.Chr == "NC_054708.1" ~ "10",
    sp4.Chr == "NC_054709.1" ~ "11",
    sp4.Chr == "NC_054710.1" ~ "12",
    sp4.Chr == "NC_054711.1" ~ "13",
    sp4.Chr == "NC_054712.1" ~ "14",
    sp4.Chr == "NC_054713.1" ~ "15",
    TRUE ~ sp4.Chr
  )) %>%

  # sp5: Haliotis — NC_090280.1-NC_090295.1 = chr 1-16, remove NW_
  filter(!str_detect(sp5.Chr, "^NW")) %>%
  mutate(sp5.Chr = case_when(
    sp5.Chr == "NC_090280.1" ~ "1",
    sp5.Chr == "NC_090281.1" ~ "2",
    sp5.Chr == "NC_090282.1" ~ "3",
    sp5.Chr == "NC_090283.1" ~ "4",
    sp5.Chr == "NC_090284.1" ~ "5",
    sp5.Chr == "NC_090285.1" ~ "6",
    sp5.Chr == "NC_090286.1" ~ "7",
    sp5.Chr == "NC_090287.1" ~ "8",
    sp5.Chr == "NC_090288.1" ~ "9",
    sp5.Chr == "NC_090289.1" ~ "10",
    sp5.Chr == "NC_090290.1" ~ "11",
    sp5.Chr == "NC_090291.1" ~ "12",
    sp5.Chr == "NC_090292.1" ~ "13",
    sp5.Chr == "NC_090293.1" ~ "14",
    sp5.Chr == "NC_090294.1" ~ "15",
    sp5.Chr == "NC_090295.1" ~ "16",
    TRUE ~ sp5.Chr
  )) %>%

  # sp6: Littorina — NC_090245.1-NC_090261.1 = chr 1-17, remove NW_ and mitochondrial NC_030595.1
  filter(!str_detect(sp6.Chr, "^NW")) %>%
  filter(sp6.Chr != "NC_030595.1") %>%
  mutate(sp6.Chr = case_when(
    sp6.Chr == "NC_090245.1" ~ "1",
    sp6.Chr == "NC_090246.1" ~ "2",
    sp6.Chr == "NC_090247.1" ~ "3",
    sp6.Chr == "NC_090248.1" ~ "4",
    sp6.Chr == "NC_090249.1" ~ "5",
    sp6.Chr == "NC_090250.1" ~ "6",
    sp6.Chr == "NC_090251.1" ~ "7",
    sp6.Chr == "NC_090252.1" ~ "8",
    sp6.Chr == "NC_090253.1" ~ "9",
    sp6.Chr == "NC_090254.1" ~ "10",
    sp6.Chr == "NC_090255.1" ~ "11",
    sp6.Chr == "NC_090256.1" ~ "12",
    sp6.Chr == "NC_090257.1" ~ "13",
    sp6.Chr == "NC_090258.1" ~ "14",
    sp6.Chr == "NC_090259.1" ~ "15",
    sp6.Chr == "NC_090260.1" ~ "16",
    sp6.Chr == "NC_090261.1" ~ "17",
    TRUE ~ sp6.Chr
  )) %>%

  # sp7: Pecten — NC_047015.1-NC_047033.1 = chr 1-19, remove NW_
  filter(!str_detect(sp7.Chr, "^NW")) %>%
  mutate(sp7.Chr = case_when(
    sp7.Chr == "NC_047015.1" ~ "1",
    sp7.Chr == "NC_047016.1" ~ "2",
    sp7.Chr == "NC_047017.1" ~ "3",
    sp7.Chr == "NC_047018.1" ~ "4",
    sp7.Chr == "NC_047019.1" ~ "5",
    sp7.Chr == "NC_047020.1" ~ "6",
    sp7.Chr == "NC_047021.1" ~ "7",
    sp7.Chr == "NC_047022.1" ~ "8",
    sp7.Chr == "NC_047023.1" ~ "9",
    sp7.Chr == "NC_047024.1" ~ "10",
    sp7.Chr == "NC_047025.1" ~ "11",
    sp7.Chr == "NC_047026.1" ~ "12",
    sp7.Chr == "NC_047027.1" ~ "13",
    sp7.Chr == "NC_047028.1" ~ "14",
    sp7.Chr == "NC_047029.1" ~ "15",
    sp7.Chr == "NC_047030.1" ~ "16",
    sp7.Chr == "NC_047031.1" ~ "17",
    sp7.Chr == "NC_047032.1" ~ "18",
    sp7.Chr == "NC_047033.1" ~ "19",
    TRUE ~ sp7.Chr
  ))

# ── 5. Set factor levels ──────────────────────────────────────────────────────
my_orthologs_cleaned <- my_orthologs_cleaned %>%
  mutate(
    sp1.Chr = factor(sp1.Chr, levels = as.character(1:9)),
    sp2.Chr = factor(sp2.Chr, levels = as.character(1:10)),
    sp3.Chr = factor(sp3.Chr, levels = as.character(1:15)),
    sp4.Chr = factor(sp4.Chr, levels = as.character(1:15)),
    sp5.Chr = factor(sp5.Chr, levels = as.character(1:16)),
    sp6.Chr = factor(sp6.Chr, levels = as.character(1:17)),
    sp7.Chr = factor(sp7.Chr, levels = as.character(1:19))
  )

library(tidyr)

# load annotated groupby
groupby <- read.table(
  "/work/hs325/mollusk_synteny/results/odp/odp_groupby_filter/output/PatellaVulgata_BathyacmaeaLactea_BerghiaStephanieae_GigantopeltaAegis_HaliotisAsinina_LittorinaSaxatilis_PectenMaximus_reciprocal_best_hits.rbh.filt.annotated.groupby",
  header = TRUE, sep = "\t", stringsAsFactors = FALSE
)

# load the rbh file to get gene IDs per rbh
rbh <- read.table(
  "results/odp/PatellaVulgata_BathyacmaeaLactea_BerghiaStephanieae_GigantopeltaAegis_HaliotisAsinina_LittorinaSaxatilis_PectenMaximus_reciprocal_best_hits.rbh",
  header = TRUE, sep = "\t", stringsAsFactors = FALSE
)

# parse rbh lists from groupby and explode to one rbh per row
groupby_long <- groupby %>%
  mutate(rbh_list = str_extract_all(rbh, "rbh\\d+")) %>%
  unnest(rbh_list) %>%
  select(rbh_id = rbh_list, gene_group)

# join gene IDs from rbh file
rbh_genes <- rbh %>%
  select(rbh = rbh, PatellaVulgata_gene, PectenMaximus_gene) %>%
  inner_join(groupby_long, by = c("rbh" = "rbh_id"))

# now join GC group onto orthologs table by Patella gene ID
my_orthologs_cleaned <- my_orthologs_cleaned %>%
  left_join(rbh_genes %>% select(PatellaVulgata_gene, gene_group),
            by = c("sp1.ID" = "PatellaVulgata_gene"))

# ── 6. Chord / ribbon diagram ─────────────────────────────────────────────────
my_labels <- c("P. vulgata", "B. lactea", "B. stephanieae", "G. aegis",
                "H. asinina", "L. saxatilis", "P. maximus")

pal <- paletteer_d("ggthemes::Tableau_20")

ribbon <- plot_chord_diagram(
  my_orthologs_cleaned,
  species_labels = my_labels,
  color_by = "gene_group"
) +
  scale_color_manual(values = pal) +
  scale_x_continuous(expand = expansion(mult = c(0.15, 0.02))) +
  theme_cowplot() +
    theme(
    legend.position = "none",
    axis.line    = element_blank(),
    axis.text.x  = element_blank(),
    axis.text.y  = element_blank(),
    axis.ticks   = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  )

jpeg("results/figs/gastropod_ancestor_ribbon.jpg", width = 10, height = 6, 
     units = "in", res = 300)
print(ribbon)
dev.off()