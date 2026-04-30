######### install + test GENESPACE
# if (!requireNamespace("devtools", quietly = TRUE))
#   install.packages("devtools")
# devtools::install_github("jtlovell/GENESPACE")
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(c("Biostrings", "rtracklayer"))

## manual install mvtnorm & vctrs if needed
# mamba install -c conda-forge r-vctrs r-mvtnorm -y
# library(vctrs)
# library(mvtnorm)

setwd("/work/hs325/mollusk_synteny")
library(GENESPACE)
library(ggplot2)
library(dichromat)

# Define reference genome directory
ref_dir <- "/work/hs325/mollusk_synteny/ref"
genomeRepo <- "/work/hs325/mollusk_synteny/ref/genespace_refs"
wd <- "/work/hs325/mollusk_synteny/results/genespace"
path2mcscanx <- "/work/hs325/mollusk_synteny/MCScanX"

# Define your target genomes and their specific paths relative to ref_dir
genome_map <- list(
  limpet = list(
    gff = "gastropods/limpet/ncbi_dataset/data/GCF_932274485.2/genomic.gff",
    faa = "gastropods/limpet/ncbi_dataset/data/GCF_932274485.2/protein_dedup.faa"
  ), 
  scallop = list(
    gff = "pecten/ncbi_dataset/data/GCF_902652985.1/genomic.gff",
    faa = "pecten/ncbi_dataset/data/GCF_902652985.1/protein_dedup.faa"
  ), 
  solidissima = list(
    gff = "solidissima/SSo_feature.gff3",
    faa = "solidissima/solidissima_dedup.faa"
  ),
  edulis = list(
    gff = "mytilus/ncbi_dataset/data/GCF_963676685.1/genomic.gff",
    faa = "mytilus/ncbi_dataset/data/GCF_963676685.1/protein_dedup.faa"
  ),
  virginica = list(
    gff = "virginica/ru2025asm/Cvi_RU25.gff3",
    faa = "virginica/ru2025asm/Cvi_RU25.pep_dedup.faa"
  )
)

#symlink
genomes2run <- names(genome_map)

for(g in genomes2run){
  dest_dir <- file.path(genomeRepo, g)
  if(!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
  
  # Construct full source paths
  src_gff <- file.path(ref_dir, genome_map[[g]]$gff)
  src_faa <- file.path(ref_dir, genome_map[[g]]$faa)
  
  # Standardize names for the parser (e.g., g.gff and g.faa)
  file.symlink(src_gff, file.path(dest_dir, paste0(g, ".gff")))
  file.symlink(src_faa, file.path(dest_dir, paste0(g, ".faa")))
}

parsedPaths <- parse_annotations(
  rawGenomeRepo = genomeRepo,
  genomeDirs = genomes2run,
  genomeIDs = genomes2run,
  genespaceWd = wd,
  presets = "none",
  gffString = "gff",    # Looks for files ending in .gff
  faString = "faa",     # Looks for files ending in .faa
  headerEntryIndex = 1,   
  gffIdColumn = "protein_id",
  headerSep = " "
  )

# GENESPACE init
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

# start interactive session
# srun --mem=50G --pty bash -i
# run orthofinder here from shell 
# orthofinder -f /work/hs325/mollusk_synteny/results/genespace/tmp -t 16 -a 1 -X -o /work/hs325/mollusk_synteny/results/genespace/orthofinder

# Sys.setenv(PATH = paste("/hpc/group/schultzlab/hs325/miniconda3/envs/orthofinder/bin/orthofinder", Sys.getenv("PATH"), sep = ":"))
# Sys.which("orthofinder")
# run the below with sbatch
out <- run_genespace(gpar, overwrite = T)
save.image(file = "scripts/genespace_output_Apr29.RData")

#### modify below to plot
load("scripts/genespace_output_Apr29.RData")

# default plot
ripDat <- plot_riparian(
  gsParam = out,
  refGenome = "solidissima",
  genomeIDs = c("limpet", "scallop", "solidissima", "edulis", "virginica"),
  forceRecalcBlocks = FALSE)

# plot with chromosomes in order, no synteny
# ripDat2 <- plot_riparian(
#   gsParam = out, 
#   #reorderBySynteny = FALSE,
#   syntenyWeight = 0,
#   refGenome = "solidissima")

# identify inversions between clam and scallop
# ripDat <- plot_riparian(
#   gsParam = out, 
#   genomeIDs = c("solidissima", "scallop"), 
#   refGenome = "solidissima", 
#   inversionColor = "green")

# change color palette and theme
ggthemes <- ggplot2::theme(
  panel.background = ggplot2::element_rect(fill = "white"))
customPal <- colorRampPalette(
  c("darkorange", "skyblue", "dodgerblue4", "mediumpurple4", "mediumseagreen", "mistyrose3"))
ripDat <- plot_riparian(
  gsParam = out, 
  palette = customPal,
  braidAlpha = .75,
  chrFill = "lightgrey",
  addThemes = ggthemes,
  refGenome = "human")

## plot custom region
roi <- data.frame(
  genome = c("solidissima", "scallop"), 
  chr = c("11", "13"), 
  color = c("#FAAA1D", "#17B5C5"))
ripDat <- plot_riparian(
  gsParam = out, 
  highlightBed = roi,
  # backgroundColor = NULL, # turn this on to not plot the rest of the LGs besides the ROI
  refGenome = "solidissima",
  genomeIDs = c("limpet", "scallop", "solidissima", "edulis", "virginica"),
  customRefChrOrder = c(1:19))

# OTHER PARAMETERS
# see section 6 
# file:///Users/henrysun_1/Desktop/Duke/PhD/synteny/tutorials/genespace/riparianGuide.html

########## gnomes visualization o.O
# library(gggenomes)

# solida <- "/work/hs325/mollusk_synteny/ref/solida/genes.gff3"
# solidissima <- "/work/hs325/mollusk_synteny/ref/solidissima/SSo_feature.gff3"

# p<-gggenomes(solida) + geom_gene() 
# ggsave("/work/hs325/mollusk_synteny/solida.jpg",p, width=30,height=12,units="in")
# gggenomes(solidissima) + geom_gene() 