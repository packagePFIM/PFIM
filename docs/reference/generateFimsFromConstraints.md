# Generate Fisher Information Matrices (FIM) from Design Constraints

This method explores the design space defined by the project constraints
and computes the Fisher Information Matrix (FIM) for every candidate
elementary design arm. These matrices are then stored as a library to be
used by the optimization algorithms.

## Usage

``` r
generateFimsFromConstraints(optimization, ...)
```

## Arguments

- optimization:

  An object of class `Optimization` containing the model definitions,
  parameter values, and design constraints.

- ...:

  Additional arguments.

## Value

The updated `optimization` object, where the slot `fisherMatrices`
contains the list of matrices calculated for each candidate arm.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
