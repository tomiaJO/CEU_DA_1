#MDS

install.packages('readxl')

library('readxl')
cities <- read_excel('psoft-telepules-matrix-30000.xls')
mds <- cmdscale(as.dist(cities[-nrow(cities),-1]))
plot(mds)


