# Process arm evaluation for sensitivity index plots

Evaluates model gradients on a dense time grid and generates sensitivity
index plots (partial derivatives of responses with respect to
parameters).

## Usage

``` r
processArmEvaluationSI(arm, model, fim, designName, plotOptions, ...)
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

A named list of `ggplot` objects per design, arm, output, and parameter.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
