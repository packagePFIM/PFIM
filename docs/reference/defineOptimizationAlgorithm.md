# Define Optimization Algorithm

This method initializes the selected optimization algorithm using the
specific hyperparameters (such as lambda, delta, iterations) extracted
from the project options. It prepares the algorithmic object for
subsequent use by the `optimizeDesign` function.

## Usage

``` r
defineOptimizationAlgorithm(optimization, ...)
```

## Arguments

- optimization:

  An object of class `Optimization` containing the optimization settings
  and design parameters.

- ...:

  Additional arguments.

## Value

An object of class `OptimizationAlgorithm`

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
