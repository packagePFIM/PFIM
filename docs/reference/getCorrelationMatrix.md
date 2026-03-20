# getCorrelationMatrix

Returns the correlation matrix of parameter estimates derived from the
asymptotic variance-covariance matrix \\C = M^{-1}\\, where \\M\\ is the
FIM. Formally: \\R\_{ij} = C\_{ij} / \sqrt{C\_{ii} C\_{jj}}\\.

## Usage

``` r
getCorrelationMatrix(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A symmetric correlation matrix with values in \\\[-1, 1\]\\ and ones on
the diagonal.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Extract and print the correlation matrix from the FIM evaluation results
correlationMatrix = getCorrelationMatrix(evaluationPopulationFIMResults)

# Display the matrix
print(correlationMatrix)

} # }
```
