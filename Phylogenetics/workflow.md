

# What's the deal with this gene family??

## To install
• MEGA
• mafft
• raXml
• figtree
• R::ape
• R::dendextend


• We have a set of homologous genes (a family) coming from several species of plant.
• We suspect that this family may have an HGT event, but we need to show this concretely.

Data source:
https://doi.org/10.1073/pnas.1608765113
Orthogroup 3861

From this, we have a set of protein-sequences in FASTA format.

Gene families are derived based on incongruent species and gene phylogenies

## 1) Form a gene-family alignment

This will give us a sense of the relationship between these genes.

#### First, we will try using MAFFT.
1. install mafft
2. run mafft on your protein sequences and save the output.

#### Next, we can try using MEGA (muscle or clustalw).
1. open sequences in mega
2. perform an alignment (muscle or clustalw?)
3. save the output (don't close mega!)


## 2) make an tree.

#### In mega we can make some trees
1. Try a NJ tree - does it work? Need to curate any sequences?
2. Export this NJ tree.
3. ML tree?
4. can we load the MAFFT tree and make a phylogeny?

## 3) look at the tree
1. Lets look with figtree or with MEGA




## 4) Identify genes that are vertically- or horizontally-derived
Annotation of tree!


• We are going to do this totally in R, using the provided project.

