# plotRSE

Bar plot of Relative Standard Errors (RSE, %) for the model parameters.

## Usage

``` r
plotRSE(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A bar plot of RSE (%) values.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# Extract Relative Standard Errors from evaluationPopulationFIMResults
se = getSE(evaluationPopulationFIMResults)
print(se)
} # }
```
