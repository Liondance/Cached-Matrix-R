### Notes for the graders

This repository implements the functions required for the second
programming assignment of the "Programming in R" course, and more.

The example "Caching the mean of a vector" given in the assignment
uses a caching scheme that is prone to error. A better solution
involves the object in question (the matrix in our case) to implement
its own caching logic, instead of relying on an external function 
to do so. The cachematrix.R file contains code impolementing two 
variations of the assignment: one follows the scheme suggested 
in the vector example. The other, which we consider superior, 
relies on the object to handle its own caching.

A test harness is provided to test the functions. The test
harness is a good example of the power of higher order functions.
Thanks to such capability, only one test harness is required to
test both versions of the assignment.

This code (obvious by inspection) contains no malicious code.
It's been thoroughly tested. Feel free to try it on your own machine.
To test, all you have to do is run cacheMatrixTest()
