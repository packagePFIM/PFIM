# Visualize the distribution of optimal design weights

Generates a bar plot showing the weights assigned to each candidate arm
after the optimization process. This represents the proportion of the
total population that should be allocated to each specific design.

## Usage

``` r
plotWeights(optimization, ...)
```

## Arguments

- optimization:

  An object of class `Optimization` that has been optimized.

- ...:

  Additional arguments.

## Value

A `ggplot2` bar plot of the optimized weights.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# plot the weights from the optimizationMultiplicativePopulationFIMObject
weights = plotWeights( optimizationMultiplicativePopulationFIMObject )
print(weights)
} # }
```
