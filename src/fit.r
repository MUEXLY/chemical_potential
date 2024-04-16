library(car)
library(dplyr)

chemical_potentials <- commandArgs()[6] %>%
    read.table(comment.char='', header=TRUE)

num_types <- dim(chemical_potentials)[2] %/% 2

# add free energies to table

chemical_potentials <- chemical_potentials %>%
    rowwise() %>%
    mutate(g = sum(c_across(starts_with("x")) * c_across(starts_with("mu")))) %>%
    ungroup() %>%
    select(-starts_with("mu"))

# next, build formula for linear regression including combinations

# add linear terms
eqn <- "g ~ 0"
for (i in 1:num_types) {
    eqn <- " %s + x_%s" %>%
        sprintf(eqn, as.character(i))
}

# add quadratic terms

for (i in 1:num_types) {
    for (j in i:num_types) {
        if (i == j) next
        eqn <- "%s + x_%s * x_%s" %>%
            sprintf(eqn, as.character(i), as.character(j))
    }
}

model <- lm(formula(eqn), data=chemical_potentials)

# compute and print RMSE, better measure than r^2 for 0-intercept fitting
rmse <- model$residuals^2 %>%
    sqrt() %>%
    mean()

"RMSE: %s\n" %>%
    sprintf(rmse) %>%
    cat()

# next, do statistical tests

cat("TEST FOR CONSTANT VARIANCE\n")
model %>%
    ncvTest() %>%
    print()

cat("TEST FOR NORMALLY DISTRIBUTED ERRORS\n")
model$residuals %>%
    shapiro.test() %>%
    print()

cat("TEST FOR INDEPENDENCE OF ERRORS\n")
model %>%
    durbinWatsonTest() %>%
    print()

cat("\n")

cat("COEFFICIENTS\n")
model$coefficients %>%
    print()
