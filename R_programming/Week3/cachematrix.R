## R function to calculate Inverse Matrix with result cached for time-consuming computations.
## Result will be return if in the cache rather than recomputed.

## Function to calculate inverse Matrix.
makeCacheMatrix <- function(x = matrix()) {
  #Set matrix, m is result matrix, x is source matrix
  m<- NULL
  set <- function(y) { 
    x <<- y
    m <<- NULL
  }
  #Get matrix
  get <- function() x
  #set Inverse matrix
  setInverse <- function(data) {
    m<<- data
    m
  }
  #Get Inverse matrix
  getInverse <- function() m 
  list( set = set, get= get,
          setInverse = setInverse,
          getInverse = getInverse)
}


## The function calculates the inverse of the special "Matrix" created from above function.
## It first try return from cache result. If not cache yet, it calculate the inverse matrix and
## store cache result and return
cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  m <- x$getInverse()
  if(!is.null(m)) {
    message("return cached data")
    return(m)
  }
  data <- x$get() #get source matrix
  #find the inverse, call makeCacheMatrix to calculate
  m<- solve(data)
  x$setInverse(m) #add to cache and return
  m
}
