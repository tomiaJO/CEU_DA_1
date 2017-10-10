library(data.table)
hotels <- fread('http://bit.ly/CEU-R-hotels-2017-v2')
str(hotels)

hotels[, .N, by = city]


x <- 'Budapest, Hungary'
strsplit(x, ', ')
str(strsplit(x, ', '))

strsplit(x, ', ')[[1]][2] ##outcome is a list -- double brackets

str(list(a = 1:3))
list(a = 1:3)[[1]][2] ## filtering for 2 in the list
