
## Functions to create a special matrix object and computes the inverse of this special matrix.

## Create a sepcial "matrix" for cache.
makeCacheMatrix <- function(x = matrix()) {
  inverse <- NULL
  set <- function(y) {
    x <<- y
    inverse <<- NULL
  }
  get <- function() x
  setInverse <- function(inv) inverse <<- inv
  getInverse <-  function() inverse
  list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}

## Compute the inverse of the special "matrix" returned by 'makeCacheMatrix'.
cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  if (!is.null(x$getInverse())) {
    message("retrieving from the cache")
    x$getInverse()
  } else {
    message("solving the inverse")
    x$setInverse(solve(x$get()))
  }
}
