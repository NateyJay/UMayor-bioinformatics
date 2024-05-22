## Use this file to load in common data for your project


require(stringr)
# require(phylogram)
# require(dendextend)
require(ape)





# importing trees ---------------------------------------------------------


ml.dend <- read.tree("../Source_paper/ML_tree.nwk")

nj.dend <- read.tree("../Source_paper/Newick Export.nwk")

# my.ml.dend <- read.tree('../cli/RAxML_bestTree.T2')




# Making a species annotation table ---------------------------------------

## This I did somewhat manually - basically googling classifications for the ones I did not know. 
## Names are not well-curated, making it difficult


## here we start a data.frame using the tip.labels as the starting point
tree.df <- data.frame(gene=ml.dend$tip.label)

tree.df$classification[grepl("Arath|Thepa|Carpa|Theca|Poptr|Frave|Glyma|Medtr|Vitvi|Utrgi|Sesamum_indicum", tree.df$gene)] <- "Asterids"
tree.df$classification[grepl("Solly|Soltu|Mimgu", tree.df$gene)] <- "Rosids"
tree.df$classification[grepl("Nelnu|Aquco", tree.df$gene)] <- "Basal Eudicots"
tree.df$classification[grepl("Lindenbergia|Triphysaria|Phelipanche|Striga|Orobanche|Stras|LaSa", tree.df$gene)] <- "Rosids"
tree.df$classification[grepl("Orysa|Bradi|Sorbi|Musac|Phoda", tree.df$gene)] <- "Monocots"
tree.df$classification[grepl("Ambtr", tree.df$gene)] <- "Basal Angiosperm"

tree.df <- tree.df[order(tree.df$classification),]

class_colors = setNames(c('red','blue','purple','orange','green'), unique(tree.df$classification))
class_colors


tree.df$color <- class_colors[tree.df$classification]
tree.df

tree.df$parasite <- F
tree.df$parasite[grepl("Triphysaria|Phelipanche|Striga|Orobanche|Stras", tree.df$gene)] <-T
tree.df




