chemical_potentials <- read.table(commandArgs()[6], comment.char='', header=TRUE)

num_types <- dim(chemical_potentials)[2] %/% 2

for (i in 1:num_types) {
    compositions_str <- ''

    for (j in 1:num_types) {
        if (i == j) next
        compositions_str <- sprintf("%sx_%s + ", compositions_str, as.character(j))
    }

    compositions_str <- substr(compositions_str, 1, nchar(compositions_str) - 3)

    eqn <- sprintf("mu_%s ~ %s", as.character(i), compositions_str)
    mod <- lm(formula(eqn), data=chemical_potentials)
    cat(sprintf("************** FIT FOR mu_%s **************", as.character(i)))
    print(summary(mod))
}