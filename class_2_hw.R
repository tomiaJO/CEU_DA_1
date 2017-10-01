library(data.table)

mtd <- data.table(mtcars)
head(mtd)

mtd[, .N]

nrow(mtd)

mtd[gear == 5, .N]

mtd[gear < 5 & hp > 200, .N]

avg_hp <- mtd[, mean(hp)]
avg_hp

mtd[hp > avg_hp, .N]

mtdgear <- mtd[ , list(
                      cars = .N,
                      avg_hp = mean(hp)), 
              by = gear]
mtdgear[][order(cars)]
