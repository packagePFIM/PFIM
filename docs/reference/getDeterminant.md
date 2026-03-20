# getDeterminant

Returns the determinant of the Fisher Information Matrix (FIM), a global
measure of design information used for D-optimality.

## Usage

``` r
getDeterminant(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A numeric value representing the determinant of the FIM.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Extract the determinant of the Fisher Information Matrix (FIM)
determinant = getDeterminant(evaluationPopulationFIMResults)

# Display the determinant value
print(determinant)

} # }
```
