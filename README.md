# fquad

Computes points and weights of Gaussian quadrature in Fortran.

Supported quadrature types: **Laguerre**, **Legendre**, and **Hermite**.

Tested up to 128 points. After this convergence is not guaranteed.

For background, see: [Gaussian quadrature on Wikipedia](https://en.wikipedia.org/wiki/Gaussian_quadrature)

The root-finding algorithm is based on:

> **A. Glaser, X. Liu, and V. Rokhlin**  
> *A Fast Algorithm for the Calculation of the Roots of Special Functions*  
> SIAM J. Sci. Comput. 29, 1420 (2007)

---

## Compiling the Program

To compile, simply run:

```bash
make
```

This builds the executable at:

```
app/fquad
```

---

## Running the Program

Use the following syntax:

```bash
app/fquad <type> <nquad>
```

Where:

- `<type>`: Type of quadrature — one of `lag`, `leg`, or `her`
- `<nquad>`: Number of Gaussian quadrature points

This generates an output file named:

```
<type>quad_<nquad>.dat
```

The file contains:

| Column | Description        |
|--------|--------------------|
| 1      | Quadrature nodes   |
| 2      | Quadrature weights |

Example:

```bash
app/fquad lag 128
# Output: lagquad_128.dat
```

---

## Runtime Benchmarks

| Type     | N     | Runtime (s) |
|----------|-------|-------------|
| Laguerre | 128   | 0.049       |
| Legendre | 128   | 0.014       |
| Hermite  | 128   | 0.108       |
---

## Precision

Default precision is 128 bit real numbers (quad precision). Edit parameter r_kind in quad.f90 to change precision.
Roots are found to within 16 times machine precision.
