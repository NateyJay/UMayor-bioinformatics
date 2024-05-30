




blast.df <- read.delim('./blast_outputs/Mavium_Mmicro.txt', header=F)
head(blast.df)
names(blast.df) <- c('qseqid',
  'sseqid',
  'pident',
  'length',
  'mismatch',
  'gapopen',
  'qstart',
  'qend',
  'sstart',
  'send',
  'evalue',
  'bitscore')
head(blast.df)


plot(blast.df$qstart, blast.df$sstart, pch=19, cex=0.2)






# plotting all of them ----------------------------------------------------

blast_dot_plot <- function(a,b) {
  blast.df <- read.delim(str_glue('./blast_outputs/{a}_{b}.txt'), header=F)
  head(blast.df)
  names(blast.df) <- c('qseqid',
                       'sseqid',
                       'pident',
                       'length',
                       'mismatch',
                       'gapopen',
                       'qstart',
                       'qend',
                       'sstart',
                       'send',
                       'evalue',
                       'bitscore')
  head(blast.df)
  
  
  plot(blast.df$qstart, blast.df$sstart, pch=19, cex=0.1,
       xlab=a, ylab=b)
  
}


par(mfrow=c(5,5), mar=c(4,4,2,2))
for (b in species.df$abbv) {
  for (a in species.df$abbv) {
    blast_dot_plot(a,b)
  }
}



















