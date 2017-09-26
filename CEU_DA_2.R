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

plot(df$height, df$weight)
hist(df$heightIn)
head(df)
