library(macrosyntR)
library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)
library(paletteer)

setwd("/work/hs325/mollusk_synteny")

# run in bash
# fgrep -f /work/hs325/mollusk_synteny/results/genespace/orthofinder/Results_Apr29/Orthogroups/Orthogroups_SingleCopyOrthologues.txt \
# /work/hs325/mollusk_synteny/results/genespace/orthofinder/Results_Apr29/Orthogroups/Orthogroups.tsv > Single_copy_orthologs.tab

# change format of file to match
# tr  '\015\012/' '\n' < Single_copy_orthologs.tab | awk '($0 != "") {print}' > Single_copy_orthologs.tsv

my_ortho_file <- "/work/hs325/mollusk_synteny/results/genespace/orthofinder/Results_Apr29/Orthogroups/Single_copy_orthologs.tsv"
ortho_test <- read.table(my_ortho_file, header = TRUE, sep = "\t", check.names = FALSE)
colnames(ortho_test)
ortho_ready <- ortho_test[, -1]
colnames(ortho_ready)

write.table(ortho_ready, "/work/hs325/mollusk_synteny/results/genespace/orthofinder/Results_Apr29/Orthogroups/temp_ortho_for_macrosyntR.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)


# DOUBLE CHECK: Ensure the order below matches column order in Single_copy_orthologs.tsv!
#1 edulis #2 limpet #3 scallop 4 ssol, 5 cvir
my_bed_paths <- c(
  "ref/genespace_refs/edulis.bed",
  "ref/genespace_refs/limpet.bed",
  "ref/genespace_refs/scallop.bed",
  "ref/genespace_refs/solidissima.bed",
  "ref/genespace_refs/virginica.bed"
)

# order
my_orthologs_table <- load_orthologs(
  orthologs_table = "/work/hs325/mollusk_synteny/results/genespace/orthofinder/Results_Apr29/Orthogroups/temp_ortho_for_macrosyntR.tsv",
  bedfiles = my_bed_paths
)


# It is best to do this cleanup species by species to ensure accuracy
my_orthologs_cleaned <- my_orthologs_table %>%
  # --- Mytilus (NC_092344.1-14 -> 1-14, Remove NW) ---
  filter(!str_detect(sp1.Chr, "^NW")) %>%
  mutate(sp1.Chr = case_when(
    sp1.Chr == "NC_092344.1" ~ "1",
    sp1.Chr == "NC_092345.1" ~ "2",
    sp1.Chr == "NC_092346.1" ~ "3",
    sp1.Chr == "NC_092347.1" ~ "4",
    sp1.Chr == "NC_092348.1" ~ "5",
    sp1.Chr == "NC_092349.1" ~ "6",
    sp1.Chr == "NC_092350.1" ~ "7",
    sp1.Chr == "NC_092351.1" ~ "8",
    sp1.Chr == "NC_092352.1" ~ "9",
    sp1.Chr == "NC_092353.1" ~ "10",
    sp1.Chr == "NC_092354.1" ~ "11",
    sp1.Chr == "NC_092355.1" ~ "12",
    sp1.Chr == "NC_092356.1" ~ "13",
    sp1.Chr == "NC_092357.1" ~ "14",
    TRUE ~ sp1.Chr
  )) %>%
  
  # --- Limpet (NC_065879.2-87.2 -> 1-9) ---
  mutate(sp2.Chr = case_when(
    sp2.Chr == "NC_065879.2" ~ "1",
    sp2.Chr == "NC_065880.2" ~ "2",
    sp2.Chr == "NC_065881.2" ~ "3",
    sp2.Chr == "NC_065882.2" ~ "4",
    sp2.Chr == "NC_065883.2" ~ "5",
    sp2.Chr == "NC_065884.2" ~ "6",
    sp2.Chr == "NC_065885.2" ~ "7",
    sp2.Chr == "NC_065886.2" ~ "8",
    sp2.Chr == "NC_065887.2" ~ "9",
    TRUE ~ sp2.Chr
  )) %>%
  
  # --- Scallop (NC_047015.1-33.1 -> 1-19, Remove NW) ---
  filter(!str_detect(sp3.Chr, "^NW")) %>%
  mutate(sp3.Chr = case_when(
    sp3.Chr == "NC_047015.1" ~ "1",
    sp3.Chr == "NC_047016.1" ~ "2",
    sp3.Chr == "NC_047017.1" ~ "3",
    sp3.Chr == "NC_047018.1" ~ "4",
    sp3.Chr == "NC_047019.1" ~ "5",
    sp3.Chr == "NC_047020.1" ~ "6",
    sp3.Chr == "NC_047021.1" ~ "7",
    sp3.Chr == "NC_047022.1" ~ "8",
    sp3.Chr == "NC_047023.1" ~ "9",
    sp3.Chr == "NC_047024.1" ~ "10",
    sp3.Chr == "NC_047025.1" ~ "11",
    sp3.Chr == "NC_047026.1" ~ "12",
    sp3.Chr == "NC_047027.1" ~ "13",
    sp3.Chr == "NC_047028.1" ~ "14",
    sp3.Chr == "NC_047029.1" ~ "15",
    sp3.Chr == "NC_047030.1" ~ "16",
    sp3.Chr == "NC_047031.1" ~ "17",
    sp3.Chr == "NC_047032.1" ~ "18",
    sp3.Chr == "NC_047033.1" ~ "19",
    TRUE ~ sp3.Chr
  )) %>%
  
  # --- Surfclam (Chr01-Chr19 -> 1-19) ---
  mutate(sp4.Chr = str_remove(sp4.Chr, "^Chr0?")) %>%
  
  # --- Oyster (Chr01-Chr10 -> 1-10, Remove ctg) ---
  filter(!str_detect(sp5.Chr, "^ctg")) %>%
  mutate(sp5.Chr = str_remove(sp5.Chr, "^Chr0?"))

# --- Final Cleanup ---
main_chrs_sp1 <- as.character(1:14)
my_orthologs_cleaned <- my_orthologs_cleaned %>%
  filter(sp1.Chr %in% main_chrs_sp1)

my_orthologs_cleaned <- my_orthologs_cleaned %>%
  mutate(
    sp1.Chr = factor(sp1.Chr, levels = as.character(1:14)),
    sp2.Chr = factor(sp2.Chr, levels = as.character(1:9)),
    sp3.Chr = factor(sp3.Chr, levels = as.character(1:19)),
    sp4.Chr = factor(sp4.Chr, levels = as.character(1:19)),
    sp5.Chr = factor(sp5.Chr, levels = as.character(1:10))
  )

# Calculate macrosynteny
macrosynteny_df <- compute_macrosynteny(my_orthologs_cleaned)
head(macrosynteny_df)

# plot odp
pal_mytilus <- c("#A52A2A", "#FFD39B", "#66CDAA", "#8EE5EE", "#7FFF00", "#FFD700", 
                 "#FF7F00", "#474747", "#6495ED", "#FF3030", "#0000EE", "#FF1493", 
                 "#8A2BE2", "#080808")
p <- plot_oxford_grid(my_orthologs_cleaned,
                 sp1_label = "Mussel",
                 sp2_label = "Limpet",
                 color_by = "sp1.Chr", 
                 color_palette = pal_mytilus)
ggsave("results/figs/edulis_limpet.jpg", p, width = 8, height = 8, dpi = 300)

# plot macrosynteny
plot_macrosynteny(macrosynteny_df,
                  sp1_label = "Mussel",
                  sp2_label = "Limpet") + theme_cowplot()

# plot chord diagram
my_labels <- c("Mussel", "Limpet", "Scallop", "Surfclam", "Oyster")
plot_chord_diagram(
  my_orthologs_cleaned, 
  species_labels = my_labels,
  color_by = "LGs"
) +
  theme_cowplot() +
  theme(
    legend.position = "none",
    axis.line        = element_blank(),
    axis.text.x      = element_blank(),
    axis.text.y      = element_blank(),
    axis.ticks       = element_blank(),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank()
  )

### reorder plot
my_orthologs_reordered <- my_orthologs_cleaned %>%
  select(
    sp1.ID = sp2.ID, sp1.Chr = sp2.Chr, sp1.Start = sp2.Start, sp1.End = sp2.End, sp1.Index = sp2.Index,
    sp2.ID = sp3.ID, sp2.Chr = sp3.Chr, sp2.Start = sp3.Start, sp2.End = sp3.End, sp2.Index = sp3.Index,
    sp3.ID = sp4.ID, sp3.Chr = sp4.Chr, sp3.Start = sp4.Start, sp3.End = sp4.End, sp3.Index = sp4.Index,
    sp4.ID = sp1.ID, sp4.Chr = sp1.Chr, sp4.Start = sp1.Start, sp4.End = sp1.End, sp4.Index = sp1.Index,
    sp5.ID = sp5.ID, sp5.Chr = sp5.Chr, sp5.Start = sp5.Start, sp5.End = sp5.End, sp5.Index = sp5.Index
  )

my_new_labels <- c("P. vul", "P. max", "S. sol", "M. edu", "C. vir")
# pal_19 <- paletteer_d("ggsci::category20b_d3")
pal_19 <- paletteer_d("ggthemes::Tableau_20")

ribbon <- plot_chord_diagram(
  my_orthologs_reordered, 
  species_labels = my_new_labels,
  color_by = "LGs"
) +
  scale_color_manual(values = pal_19) +
  theme_cowplot() +
  theme(
    legend.position = "none",
    axis.line        = element_blank(),
    axis.text.x      = element_blank(),
    axis.text.y      = element_blank(),
    axis.ticks       = element_blank(),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank()
  )
ribbon
ggsave("results/figs/ribbon.jpg", ribbon, width = 7, height = 5, dpi = 300)
