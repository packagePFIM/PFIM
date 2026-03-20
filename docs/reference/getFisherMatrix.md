# getFisherMatrix

Extracts partitioned components of the FIM for an `Evaluation` object.

## Usage

``` r
getFisherMatrix(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `Evaluation`.

- ...:

  Additional arguments.

## Value

A `list` with `fisherMatrix`, `fixedEffects`, and `varianceEffects`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
fisherMatrixComponents = getFisherMatrix(evaluationPopulationFIMResults)
# Access specific matrices
FIM             = fisherMatrixComponents$fisherMatrix
fixedEffects    = fisherMatrixComponents$fixedEffects
varianceEffects = fisherMatrixComponents$varianceEffects
} # }
```
