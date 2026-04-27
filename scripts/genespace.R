######### install + test GENESPACE
# if (!requireNamespace("devtools", quietly = TRUE))
#   install.packages("devtools")
# devtools::install_github("jtlovell/GENESPACE")
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(c("Biostrings", "rtracklayer"))

## manual install mvtnorm & vctrs
# srun --mem=16G --pty bash -i
# mamba install -c conda-forge r-vctrs r-mvtnorm -y
# library(vctrs)
# library(mvtnorm)

library(GENESPACE)

########## gnomes visualization o.O
library(gggenomes)

solida <- "/work/hs325/mollusk_synteny/ref/solida/genes.gff3"
solidissima <- "/work/hs325/mollusk_synteny/ref/solidissima/SSo_feature.gff3"

# p<-gggenomes(solida) + geom_gene() 
# ggsave("/work/hs325/mollusk_synteny/solida.jpg",p, width=30,height=12,units="in")
# gggenomes(solidissima) + geom_gene() 