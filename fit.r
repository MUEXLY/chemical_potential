data <- read.table(commandArgs()[6], comment.char='', header=TRUE)

y_str <- 'cbind('
x_str <- ''

for(i in 1:(dim(data)[2] %/% 2)) {
    y_str <- sprintf("%smu_%s, ", y_str, as.character(i))
    x_str <- sprintf("%sx_%s + ", x_str, as.character(i))
}

y_str <- substr(y_str, 1, nchar(y_str) - 1)
y_str <- sub('.$', ')', y_str)
x_str <- substr(x_str, 1, nchar(x_str) - 3)

eqn <- sprintf("%s ~ %s", y_str, x_str)
mod <- lm(formula(eqn), data=data)

mod