# plotFrequencies: visualize optimal frequencies for the Fedorov-Wynn algorithm

Generates a bar plot showing the frequencies (normalized counts) of the
design arms selected by the Fedorov-Wynn algorithm. This plot identifies
the support points of the optimal discrete design.

## Usage

``` r
plotFrequencies(optimization, ...)
```

## Arguments

- optimization:

  An object of class `Optimization` containing Fedorov-Wynn algorithm
  results.

- ...:

  Additional arguments.

## Value

A `ggplot2` bar plot of the optimal frequencies.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# plot frequencie from optimizationFedorovWynnPopulationFIMObject
frequencies = plotFrequencies( optimizationFedorovWynnPopulationFIMObject )
print(frequencies)
} # }
```
