# Rcpp Multiplicative Algorithm for Optimal Design

Executes the high-performance C++ implementation of the multiplicative
algorithm. This function serves as the computational engine for the
`MultiplicativeAlgorithm` class, processing Fisher Information Matrices
(FIM) from multiple arms to determine the optimal weight distribution.

## Usage

``` r
MultiplicativeAlgorithm_Rcpp(
  fisherMatrices_input,
  numberOfFisherMatrices_input,
  weights_input,
  numberOfParameters_input,
  dim_input,
  lambda_input,
  delta_input,
  iterationInit_input
)
```

## Arguments

- fisherMatrices_input:

  A `list` or `vector` of flattened Fisher Information Matrices for each
  candidate elementary design arm.

- numberOfFisherMatrices_input:

  An `integer` specifying the total number of candidate arms.

- weights_input:

  A `numeric` vector of initial weights (must sum to 1).

- numberOfParameters_input:

  The number of fixed parameters in the model.

- dim_input:

  The dimension of the matrices (typically equal to
  `numberOfParameters_input`).

- lambda_input:

  Relaxation parameter for weight updates (step size).

- delta_input:

  Convergence threshold for the optimality criterion.

- iterationInit_input:

  Maximum number of iterations allowed for the C++ solver.

## Value

A `list` containing:

- `weights`: The vector of optimized design weights.

- `criterion`: The final value of the optimality criterion.

- `iterations`: The number of iterations performed.

- `convergence`: A `logical` indicating if the convergence criterion was
  met.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
