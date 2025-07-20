# fquad

Computes points and weights of Gaussian quadrature in Fortran.

Supported quadrature types: **Hermite**, **Laguerre**, and **Legendre**.

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
app/main.exe
```

---

## ▶️ Running the Program

Use the following syntax:

```bash
app/main.exe <type> <nquad>
```

Where:

- `<type>`: Type of quadrature — one of `her`, `lag`, or `leg`
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
app/main.exe lag 128
# Output: lagquad_128.dat
```

---

## ⏱️ Runtime Benchmarks

| Type     | N     | Runtime (s) |
|----------|-------|-------------|
| Laguerre | 128   | 0.2         |
| Laguerre | 1000  | 3.4         |
| Legendre | 128   | 0.06        |
| Legendre | 1000  | 1.4         |
| Hermite  | 128   | 22          |
| Hermite  | 1000  | N/A         |

> ⚠️ Hermite quadrature uses Newton's method and converges very slowly for large `N`.  
> Above `N = 128`, convergence is **not guaranteed** and has not been tested.

---
