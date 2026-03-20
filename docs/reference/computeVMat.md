# Compute Variance Matrix Component

The `computeVMat` method calculates the V matrix for a given set of
model parameters. In the context of population modeling, V represents
the total variance of the data, integrating both the structural model
sensitivity to random effects and the residual error components.

## Usage

``` r
computeVMat(varParam1, varParam2, invCholV)
```

## Arguments

- varParam1:

  A numeric vector or matrix representing the first set of variance
  components (typically related to the linearized structural model).

- varParam2:

  A numeric vector or matrix representing the second set of variance
  components (typically the residual error terms).

- invCholV:

  A logical or numeric matrix used for the Inverse Cholesky
  decomposition of \\V\\, facilitating faster computation of the FIM and
  likelihood.

## Value

A square, symmetric matrix representing the total variance `V` for the
observations.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
