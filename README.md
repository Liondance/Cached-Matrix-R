### Notes for the graders

This repository implements the functions required for the second programming
assignment of the "Programming in R" course, and more.

The example "Caching the mean of a vector", given in the assignment, uses a 
caching scheme that is prone to error. A better solution involves the object 
in question (the matrix in our case) to implement its own caching logic, 
instead of relying on external functions to do so. The cachematrix.R file 
contains code impolementing two variations of the assignment: the first 
variation follows the same scheme suggested in the vector example. The 
other, which we consider superior, relies on the object to handle 
its own caching. This leads to better encapsulation.

A test harness is provided to test the functions. The test harness is a good 
example of the power of higher order functions. Thanks to such capability, 
only one test harness is required to test both versions of the assignment.

This solution here contains no malicious code, which is hopefully obvious
by inspection. It's been thoroughly tested. Please feel free to run it on
your own machine.

Testing instructions:

> source("cachematrix.R");
> cacheMatrixTest()
