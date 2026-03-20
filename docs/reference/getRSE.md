# getRSE

Retrieves the Relative Standard Errors (RSE, %) from the FIM.

## Usage

``` r
getRSE(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A numeric vector of RSE (%) values for each model parameter.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# Extract RSE (%) for all model parameters for evaluationPopulationFIMResults
rse = getRSE(evaluationPopulationFIMResults)
# Display the RSE values
print(rse)
} # }
```
