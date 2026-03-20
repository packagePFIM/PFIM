# Process arm evaluation for response plots

Evaluates the model on a dense time grid and generates response plots
for a given arm, overlaying the design sampling points.

## Usage

``` r
processArmEvaluationResults(arm, model, fim, designName, plotOptions, ...)
```

## Arguments

- arm:

  An object of class `Arm`.

- model:

  An object of class `Model`.

- fim:

  An object of class `Fim`.

- designName:

  A string giving the name of the design.

- plotOptions:

  A list with `unitTime` and `unitOutcomes`.

- ...:

  Additional arguments

## Value

A named list of `ggplot` objects per design and arm.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
