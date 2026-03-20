# getSE

Retrieves the Standard Errors (SE) from the Fisher Information Matrix.

## Usage

``` r
getSE(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A numeric vector of SE values for each model parameter.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# Extract Standard Errors from evaluationPopulationFIMResults
se = getSE(evaluationPopulationFIMResults)
print(se)
} # }
```
