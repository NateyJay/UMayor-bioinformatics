



mum.df <- read.delim("mummer.1to1.txt", skip=1, header=F, sep='')
head(mum.df)
dim(mum.df)

names(mum.df) <- c("GenA", "GenB", "Len")
head(mum.df)

plot(mum.df$GenA, mum.df$GenBf, pch=".")



genA = 'AE016958'
genB = 'CP010333'

plot_mummer <- function(genA, genB) {
  
  file_name = paste("mummer.", genA, "_", genB, ".txt", sep='')
  
  mum.df <- read.delim(file_name, skip=1, header=F, sep='')
  
  names(mum.df) <- c("GenA", "GenB", "Len")
  
  plot(mum.df$GenA, mum.df$GenB, pch=".", xlab=genA, ylab=genB)
  
}

plot_mummer('AE016958', 'CP010333')
plot_mummer('AE016958', 'CP013741')
plot_mummer('AE016958', 'FR878060')


plot_mummer('CP010333', 'CP013741')
plot_mummer('CP010333', 'FR878060')
