h <- c(174, 170, 160)
w <- c(90, 80, 70)
df <- data.frame(height = h, weight = w)
df

#df[rows, columns]

df[1, 1]
df[1,]
df[, 1]

df[1:2, ]
df[2:3, ]
df[c(2,3), ]

str(df)

df$height
df$weight[2]


##TODO

df$bmi <- df$weight / (df$height/100)^2 ##vector operation, 3 values vs 3 values
df$bmi

summary(df$bmi)

df <- read.csv('http://bit.ly/CEU-R-heights')
df
str(df)

##convert inch -> cm
##convert lb -> kg

df$height <- df$heightIn * 2.54
df$weight <- df$weightLb * 0.45359237

df$bmi <- df$weight / (df$height/100)^2
str(df)

# hist(df$bmi)

# plot(df$height, df$weight)
# hist(df$heightIn)
# head(df)

range(df$bmi)
diff(range(df$bmi))

nrow(df)
ncol(df)
dim(df)


hist(df$bmi)
abline(v = c(18.5, 25), col = 'red') ##add lines for normal BMI values


plot(density(df$bmi))

boxplot(df$bmi)
boxplot(bmi ~ round(ageYear), data = df)

#add package
install.packages('beanplot')
library(beanplot)

beanplot(df$bmi)

beanplot(bmi ~ sex, df)

table(df$sex)
table(round(df$ageYear))

##standard charts
pie(table(round(df$ageYear)))
pie(table(df$sex))


dotchart(table(df$sex))
dotchart(table(df$sex), xlim = c(0,150))

pairs(df)

##GGally example
install.packages('GGally')
library(GGally)

ggpairs(df)


##D3 example. no need to write JS code, R will auto-generate it
install.packages('pairsD3')
library(pairsD3)

pairsD3(df)


##h2o library -- try at home'
##install.packages('h2o')


## intro stats

t.test(bmi ~ sex, data = df) ##there is a difference, but it's not significant
?t.test ##compare average of two samples

t.test(height ~ sex, df)
t.test(weight ~ sex, df)

boxplot(weight ~  sex, df)

## ANOVA 
aov(height ~ sex, data = df)
summary(aov(height ~ sex, data = df))

## post hoc
TukeyHSD(aov(weight ~ sex, data = df))
TukeyHSD(aov(height ~ sex, data = df))


## hotels.csv

df <- read.csv('http://bit.ly/CEU-R-hotels-2017')
save(df)
head(df)
tail(df)

str(df)
summary(df)

##

boxplot(df$price_HUF ~ df$city)
hist(df$price_HUF)

?hist

corr(df$city, df$price_HUF)

aov(price_HUF ~ city, data = df)

names(df)

hotels <- df

hist(hotels$price_HUF)

summary(hotels$price_HUF)

hotels[which.max(hotels$price_HUF), ] ##return row with the largest price

##TODO find the cheapest hotel
hotels[which.min(hotels$price_HUF), ]


##TODO list all places with price > 100K HUF
rows_selected = hotels$price_HUF > 100000
head(hotels[rows_selected, ])

pricey <- hotels[which(hotels$price_HUF > 100000), ]
pricey


##TODO filter pricey rating < 4
pricey_and_low_rated = subset(pricey, rating < 4) 
nrow(pricey_and_low_rated) ##number of places with 100K+ price and rating below 4

hist(pricey_and_low_rated$rating)

##one way to create bins:
# pricey_and_low_rated$rate_cat <- 1
# 
# pricey_and_low_rated[rating > 1, ] ## -> 2
# pricey_and_low_rated[rating > 2, ] ## -> 3
# pricey_and_low_rated[rating > 3, ] ## -> 4

pricey_and_low_rated$rate_cat <- cut(pricey_and_low_rated$rating, 4)
table(pricey_and_low_rated$rate_cat)

pricey_and_low_rated$rate_cat <- cut(pricey_and_low_rated$rating, c(1, 2, 3, 4))
table(pricey_and_low_rated$rate_cat)

hist(pricey_and_low_rated$rate_cat)

pie(table(pricey_and_low_rated$rate_cat))


## TODO cut => price_cat
## cheap < 10K
## expensive > 100K
## average

hotels$price_cat <- cut(hotels$price_HUF, 
                        c(0, 10000, 100000, max(hotels$price_HUF)), 
                        labels = c('cheap', 'average', 'pricey'),
                        dig.lab = 8)
str(hotels)
table(hotels$price_cat)

hist(table(hotels$price_cat))

###################
## intro data.table

install.packages('data.table')
library(data.table)


hotels <- data.table(hotels)
str(hotels) ## Classes ‘data.table’ and 'data.frame'

## filtering
hotels[price_HUF > 100000]
hotels[price_HUF > 100000 & rating < 4] # and
hotels[price_HUF > 100000 | rating < 4] # or


## summaries
hotels[, .N] ## same as nrow(hotels)

## group by
hotels[, mean(price_HUF)] #same as mean(hotels$price_HUF)

hotels[, mean(price_HUF), by = stars] ## avg price by stars

## name expression, add more than one with 'list'
hotels_by_stars <- hotels[, list(price_avg = mean(price_HUF),
              price_min = min(price_HUF),
              price_max = max(price_HUF))
       , by = stars] 

## ordering
setorder(hotels_by_stars, stars, price_min)
hotels_by_stars

hotels[, list(price_avg = mean(price_HUF),
                                 price_min = min(price_HUF),
                                 price_max = max(price_HUF))
                          , by = stars] [order(stars)]

## dt[i, j, by]
## i - filtering for rows
## j - filtering for columns
## by - grouping
## ~ SELECT 'j' FROM table WHERE 'i' GROUP BY 'by' in SQL

## TODO identify the cheapest place with rating > 4
##hotels[rating > 4, min(price_HUF)]
hotels[rating > 4][order(price_HUF)][1] ## 3 separate data table calls


## TODO new column: price_EUR
hotels$price_EUR <- hotels$price_HUF / 311.26
hotels[, price_EUR := price_HUF / 311.26] ## define new column the data table way

## TODO visualize price_EUR
hist(hotels$price_EUR)
hotels[, hist(price_EUR)]
hotels[, table(city)] ##freq table for cities
hotels[, .N, by = city] ##data table way of doing the same as above. .N = nrow

# TODO avg rating, avg stars, avg price per city
hotels[, list(avg_rating = mean(rating),
              avg_stars = mean(stars),
              avg_price = mean(price_EUR))
       , by = city] ##one NA will result in NA for 'mean'

hotels_by_cities <- hotels[, list(avg_rating = round(mean(rating, na.rm = TRUE), 2),
              avg_stars = round(mean(stars, na.rm = TRUE), 2),
              avg_price = round(mean(price_EUR, na.rm = TRUE)))
       , by = city] ##na.rm = TRUE --> removes NAs from mean

str(hotels_by_cities)

plot(hotels_by_cities$avg_stars, hotels_by_cities$avg_rating)

plot(hotels_by_cities$avg_price, hotels_by_cities$avg_stars)

##merge GDP <- wiki (next class)

# TODO plot the distribution of prices in Hungary
# TODO % of highly rated hotels in Hungary
