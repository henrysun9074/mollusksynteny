library(ape)

t <- read.tree("mollusk_phylogeny.treefile")
t_rooted <- root(t, outgroup = "Octopus_vulgaris", resolve.root = TRUE)
write.tree(t_rooted, file = "mollusk_phylogeny_rooted.treefile")