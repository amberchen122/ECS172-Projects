load("Hwk1.RData")

ratingsCache <- function(inputDF) {
    structure(
        list(inputDF = inputDF, Aij = NULL),
        class = "ratingsCache"
    )
}

findRating <- function(obj, i, j) {
    UseMethod("findRating")
}

findRating.ratingsCache <- function(obj, i, j) {
    i <- as.character(i)
    j <- as.character(j)
    new_obj <- obj

    if (is.null(new_obj$Aij)) new_obj$Aij <- list()

    if (as.integer(i) > length(new_obj$Aij) | is.null(new_obj$Aij[i])) {
        new_obj$Aij[i] <- list(NULL)
    }

    ele_name <- j

    if (ele_name %in% names(new_obj$Aij[[i]])) {
        cat("Reading from cache...\n")
        return(unname(new_obj$Aij[[i]][j]))
    }

    df <- subset(new_obj$inputDF, user == i & item == j)
    rating <- NA
    if (nrow(df) != 0) {
        rating <- df[, "rating"][1]
    }

    new_ele <- rating
    names(new_ele) <- ele_name
    new_obj$Aij[[i]] <- append(new_obj$Aij[[i]], new_ele)
    eval.parent(substitute(obj <- new_obj))
    cat("Search rating from inputDF...\n")
    rating
}

inputDFHead <- function(x) head(x$inputDF)
cachedAijHead <- function(x) head(x$Aij)

print.ratingsCache <- function(x, ...) {
    eleNames <- names(x)
    cat("$", eleNames[1], "\n", "Head of stored inputDF: \n")
    print(inputDFHead(x))
    cat("\n")
    cat("$", eleNames[2], "\n", "Head of cached Aij: \n")
    print(cachedAijHead(x))
}

'[.ratingsCache' <- function(obj, i, j) {
    UseMethod("findRating")
}

cat("Below is the Demo for grading:\n\n")
ml <- ratingsCache(ml100)
cat("Created instance of ratingsCache.\n")
cat("Display the head of elements inside this instance:\n")
print(ml)

cat("\nSearch for user 196, item 242:\n")
print(ml[196, 242])

cat("\nSearch for user 244, item 51:\n")
print(ml[244, 51])

cat("\nDemo for reading from cache by searching user 196, item 242 again:\n")
print(ml[196, 242])
