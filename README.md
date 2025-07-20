# fquad
Computes points and weights of gaussian quadrature in fortran.
Quadrature implemented: Hermite, Laguerre and Legendre.
https://en.wikipedia.org/wiki/Gaussian_quadrature

The algorithm in
A. Glaser, X. Liu, and V. Rokhlin, A Fast Algorithm for the Calculation of the Roots of Special Functions, SIAM J. Sci. Comput. 29, 1420 (2007).
is used for computing the quadrature roots.

Compiling:
To compile the program, run the command make in the fquad directory.
This compiles the program into app/main.exe

To run the program, run the command app/main.exe \<type\> \<nquad\> with command line options 
\<type\>: Type of quadrature: her, lag, leg
\<nquad\>: Number of Gaussian quadrature points 

Legendre and laguerre quadrature computes fast.
The Newton method converges very slowly for Hermite quadrature.
