pi
1+3
1 + 3 
3*2
3^2
?str()

month.abb
month.name
pi.
?pi
letters
LETTERS
apropos('month')

x <- 4
x


x ^ (1 / 2)
sqrt(x)

f <- function(x) 2 * x + 1

f <- function(x , y) {
  
  x * y
  
}

f(2 , 3)


?c

x <- c(1,2,3)
y <- c(4,4,4)

f(x , y)

x <- c(1, 2, 3, 4, 5)
plot(x, f(x))


plot(x, f(x), type='l')
warnings()

apropos('period')

?sin

z <- c(0.00:pi)
?c

z <- seq(from = 0, to = 2 * pi, by = 0.01)
z
plot(z, sin(z), type = 'l')


curve(sin, from = 0, to = 8 * pi)

x <- 0

#generate random numbers -1 and 1
runif(5, min = 0, max = 1)

round(runif(5, min = 0, max = 1))

x <- (round(runif(100, min = 0, max = 1)) - 0.5 )* 2
x
cumsum(x)

plot(0:99, cumsum(x), type = 's')

#same thing with sample
sample(c(1, -1), size = 100, replace = TRUE)
