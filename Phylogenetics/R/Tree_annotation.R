## Use this file to run a particular line of analysis


# base functions ----------------------------------------------------------

basic.dend <- chronos(ml.dend) ## This function is required to convert an 'ape' phylogram to r-base dendrograms. It requires estimation.


plot(ml.dend, type='cladogram')


plot(as.dendrogram(basic.dend), horiz=T)
plot(as.hclust(basic.dend), horiz=T)

str(basic.dend)
# str(as.dendrogram(basic.dend))


?plot.hclust
plot(as.hclust(basic.dend), hang=3)


?plot.dendrogram
par(mar=c(3,3,3,14))
plot(as.dendrogram(basic.dend), horiz=T)






# making a well annotated tree --------------------------------------------


dend <- ml.dend

# ?plot.phylo
# class(dend)
# graphics.off()

# since plot() is being run on a "phylo" object, it automatically calls plot.phylo()
plot(dend, 
     tip.color=tree.df$color[match(dend$tip.label, tree.df$gene)],
     cex=0.5,
     label.offset=0.03)


tiplabels(pch=19, col=tree.df$color[match(dend$tip.label, tree.df$gene)])
nodelabels(dend$node.label, frame='none', cex=0.5, adj=c(1.2,-0.2))
axisPhylo(1)





# Trying different types --------------------------------------------------

# making this multi-line plot into a function, where I can modify the "type" variable



function_to_plot <- function(type='phyl') {
  
  type = match.arg(type, c("phylogram", "cladogram", "fan", "unrooted", "radial", "tidy")) ## this function allows us to have partial matches with the words we use
  
  plot(ml.dend, type=type, tip.color=tree.df$color[match(ml.dend$tip.label, tree.df$gene)],
       cex=0.5,
       label.offset=0.03)
  
  
  tiplabels(pch=19, col=tree.df$color[match(ml.dend$tip.label, tree.df$gene)])
  nodelabels(ml.dend$node.label, frame='none', cex=0.5, adj=c(1.2,-0.2))
  axisPhylo(1)
}

function_to_plot()
function_to_plot('clad')
function_to_plot('fan')
function_to_plot('unrooted')
function_to_plot('radial')
function_to_plot('tidy')



# Long arms? --------------------------------------------------------------

plotBreakLongEdges(ml.dend, tip.color=tree.df$color[match(ml.dend$tip.label, tree.df$gene)],
                        cex=0.5,
                        label.offset=0.03,
                   n=3) ## notice, this function takes the same inputs as plot.phylo()

tiplabels(pch=19, col=tree.df$color[match(py$tip.label, tree.df$gene)])
nodelabels(ml.dend$node.label, frame='none', cex=0.5, adj=c(1.2,-0.2))
axisPhylo(1)



