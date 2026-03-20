# getShrinkage

Retrieves shrinkage values for the random effects (omega), measuring how
individual estimates are shrunk toward the population mean.

## Usage

``` r
getShrinkage(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A numeric vector of shrinkage values for each random effect.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Extract the shrinkage values from the Bayesian FIM evaluation results
shrinkage = getShrinkage(evaluationBayesianFIMResults)
print(shrinkage)

} # }
```
