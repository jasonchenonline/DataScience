## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

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


## Write a short comment describing this function
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
