# read data from command line
data <- read.table(commandArgs()[6], comment.char='', header=TRUE)

# initialize strings to turn into formulas for fitting
# convoluted, but necessary since we have a variable number of types
# y_str will look like cbind(mu_1, mu_2, ...)
# x_str will look like x_1 + x_2 + ...
y_str <- 'cbind('
x_str <- ''

# append to strings
for(i in 1:(dim(data)[2] %/% 2)) {
    y_str <- sprintf("%smu_%s, ", y_str, as.character(i))
    x_str <- sprintf("%sx_%s + ", x_str, as.character(i))
}

# remove last character, replace second to last character with a )
y_str <- substr(y_str, 1, nchar(y_str) - 1)
y_str <- sub('.$', ')', y_str)

# remove last 3 characters
x_str <- substr(x_str, 1, nchar(x_str) - 3)

# write fitting equation as string
eqn <- sprintf("%s ~ %s", y_str, x_str)

# perform fitting, print out model info
mod <- lm(formula(eqn), data=data)
mod