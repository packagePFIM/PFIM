# plotEvaluation

Generates graphical representations of model responses based on the
design and parameters defined in the PFIM project.

## Usage

``` r
plotEvaluation(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments.

## Value

A named list of plots per design.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# Plot the model responses from evaluationPopulationFIMResults
plotEvaluation(evaluationPopulationFIMResults, plotOptions = plotOptions)
} # }
```
