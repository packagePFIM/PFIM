# getFim

Extract the Fisher Information Matrix from an `Evaluation` object.

## Usage

``` r
getFim(evaluation, ...)
```

## Arguments

- evaluation:

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
Fim = getFim( evaluationPopulationFIMResults )
print( Fim )
} # }
```
