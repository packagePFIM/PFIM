# getDcriterion: Extract the D-optimality criterion

Returns the D-criterion derived from the determinant of the FIM,
normalized by the number of parameters for cross-design comparisons.

## Usage

``` r
getDcriterion(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A numeric value representing the D-criterion.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Examples from Vignette 1 and 2

# Extract the D-criterion from the FIM evaluation results
dCriterion = getDcriterion(evaluationPopulationFIMResults)

# Display the D-criterion value
print(dCriterion)

} # }
```
