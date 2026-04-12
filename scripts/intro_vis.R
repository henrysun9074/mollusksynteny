library(gggenomes)

solida <- "/work/hs325/mollusk_synteny/ref/solida/genes.gff3"
solidissima <- "/work/hs325/mollusk_synteny/ref/solidissima/SSo_feature.gff3"

p<-gggenomes(solida) + geom_gene() 
ggsave("/work/hs325/mollusk_synteny/solida.jpg",p, width=30,height=12,units="in")
gggenomes(solidissima) + geom_gene() 