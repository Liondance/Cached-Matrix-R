#
# Caching in R
#

#
# Matrix that caches its own inverse
#

#
# makeCacheMatrix
#
# Creates a matrix object that caches its inverse (well, if used correctly ...)
#
# x: assumed to be an NxN non-singular matrix (2D vector)
#
# Note: this first version follows the pattern of the 'cached vector' implementation
# We argue that there is a better way to implement objects with caching capabilities
# A better version is provided via the 'aBetterMatrix' function below.
#
makeCacheMatrix <- function(x = matrix()) {
    
    # Initialize cached inverse to NULL (i.e. not computed)
    inv <- NULL;
    
    # Set (i.e. assign) new matrix value
    set <- function(y) {
        inv <<- NULL; # reset cached inverse (i.e. "invalidate cache")
        x <<- y;      # change matrix value
    }
    
    # Return matrix value
    get <- function() x;
    
    # Set cached inverse matrix
    #
    # arguments:
    # solved: _must_ be the result of inverting the matrix itself!
    #
    # Warning:
    # Note that 'cacheSolve' (below) uses the object correctly.
    # However, there is no guarantee that other code will do so.
    # It is possible for buggy or malicious code to set an inconsistent inverse.
    # This problem can be avoided
    # The object should handle it's own caching, as done in the better version below.
    setInverse <- function(solved) inv <<- solved;
    
    # Get cached inverse matrix
    #
    # Warning:
    # This method may return null for a valid matrix with invalidated cache.
    # The situation arises right after matrix creation or resetting its value via 'set'.
    # Users must remember to call 'setInverse' before calling 'getInverse'.
    # Note that 'cacheSolve' (below) uses the object correctly.
    # However, there is no guarantee that other code will do so.
    # Again: this problem can be avoided
    # The object should handle it's own caching, as done in the better version below.
    getInverse <- function() inv;
    
    # Return object created by this constructor function, as a list
    list(
        set = set,
        get = get,
        setInv = setInverse,
        getInv = getInverse
    )
}

#
# cacheSolve
#
# Returns the inverse of a matrix created by 'makeCacheMatrix'
# Assumes the matrix is not singular (NO error handling)
# Uses the 'solve' function to compute the matrix inverse (parameter b is omitted)
#
# arguments:
# x: a matrix object created by 'makeCacheMatrix'
# ...: optional arguments passed to the 'solve' function
# refer to the documentation for the 'solve' function for optional arguments
#
cacheSolve <- function(x, ...) {
    inverse <- x$getInv();
    if (is.null(inverse)) {
        # The cached value is null: recompute and set cached value
        # message("computing inverse"); # uncomment this line for "educational" purposes
        data <- x$get();
        inverse <- solve(data, ...); # pass optional arguments to 'solve' function
        x$setInv(inverse);
    }
    inverse
}

#
# Here is the better version ...
#

#
# aBetterMatrix
#
# Creates a matrix object that caches its inverse (now for real)
#
# x: assumed to be an NxN non-singular matrix (2D vector)
#
aBetterMatrix <- function(x = numeric()) {
    
    # Initialize cached inverse to NULL (i.e. not computed)
    inv <- NULL;
    
    # Set (i.e. assign) new matrix value
    set <- function(y) {
        inv <<- NULL; # reset cached inverse (i.e. "invalidate cache")
        x <<- y;      # change matrix value
    }
    
    # Return matrix value
    get <- function() x;
    
    # Get inverse matrix
    # Returns the inverse of this matrix
    # Assumes the matrix is not singular (NO error handling)
    # Uses the 'solve' function to compute the matrix inverse (parameter b is omitted)
    #
    # arguments:
    # ...: optional arguments passed to the 'solve' function
    # refer to the documentation for the 'solve' function for optional arguments
    #
    getInverse <- function(...) {
        if (is.null(inv)) {
            # message("computing inverse"); # uncomment this line for "educational" purposes
            inv <- solve(x, ...); # pass optional arguments to 'solve' function
        }
        inv
    }
    
    # Return object created by this constructor function, as a list
    list(
        set = set,
        get = get,
        getInv = getInverse
    )
}

#
# betterMatrixSolve
#
# Returns the inverse of a matrix created by 'aBetterMatrix'
# (now just a simple wrapper function for the 'getInv' method)
#
# arguments:
# x: a matrix object created by 'aBetterMatrix'
# ...: optional arguments passed to getInv
#
betterMatrixSolve <- function(x, ...) {
    x$getInv(...);
}

#
# General (indeed polymorphic!) testing function
#
# Exploits R's support for higher order functions to test both versions!
#
# makeMatrix: function that constructs the matrix given a numerical vector
# solveMatrix: function that computes the matrix inverse
#
matrixTest <- function(makeMatrix, solveMatrix) {
    
    # Test Suite 1
    # these tests multiply each matrix by its inverse, to generate an identity matrix
    # the computed identity matrices are exact (avoid rounding errors, using powers of 2)
    for (K in c(2, 4, 8, 16)) {
        m <- makeMatrix(rbind(c(1, -1/K), c(-1/K, 1)));
        # Compute and test 3 times.
        # Only the first iteration computes the inverse.
        # The second and third iteration use the cached value
        for (i in 1:3) {
            inv <- solveMatrix(m);
            idL <- inv %*% m$get();
            idR <- m$get() %*% inv;
            print(idL); print(idR);
        }
    }
    
    # Test Suite 2
    # these tests create NxN matrices with random values
    # each matrix is multiplied by its inverse, to generate an identity matrix
    # the resulting identity matrices are not exact: note the rounding errors
    # we also test proper pass-through of optional arguments (e.g. tol = eps)
    # per assignment: we assume (and pray) that no singular matrix is generated!
    N <- 6;
    for (i in 1:4) {
        eps <- 0.0001; # set tolerance for detecting matrix singularity
        m <- makeMatrix(matrix(rnorm(N * N), N, N));
        idL <- solveMatrix(m, tol = eps) %*% m$get(); # computes inverse
        idR <- m$get() %*% solveMatrix(m, tol = eps); # uses cached value
        print(idL); print(idR);
    }
}

#
# Test driver
#
cacheMatrixTest <- function() {
    print("**** Test canonical (makeCacheMatrix) version ***");
    matrixTest(makeCacheMatrix, cacheSolve);
    print("**** Test alternative (aBetterMatrix) version ***");
    matrixTest(aBetterMatrix, betterMatrixSolve);
}
