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
