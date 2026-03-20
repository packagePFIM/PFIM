# Compute the Amoeba (Nelder-Mead) Simplex Search

`fun.amoeba` is an internal numerical routine that performs the
Nelder-Mead simplex search. It iteratively updates the simplex vertices
to find the optimal experimental design parameters.

## Usage

``` r
fun.amoeba(p, y, ftol, itmax, funk, outcomes, data, showProcess)
```

## Arguments

- p:

  A matrix where each row represents a vertex of the simplex.

- y:

  A vector containing the function values (FIM criteria) at each vertex.

- ftol:

  A numeric value specifying the fractional convergence tolerance.

- itmax:

  An integer specifying the maximum number of iterations.

- funk:

  The objective function to be minimized (e.g., the D-optimality
  criterion).

- outcomes:

  The model outcomes used for FIM evaluation.

- data:

  Additional data or design constraints.

- showProcess:

  A logical value; if `TRUE`, logs the progress of the simplex.

## Value

A list containing the optimized parameters, the function value, and the
number of iterations performed.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
