# Plot sensitivity indices for an arm

Generates `ggplot2` line plots of the partial derivatives of model
responses with respect to population parameters (sensitivity indices).

## Usage

``` r
plotEvaluationSI(
  arm,
  evaluationModelGradient,
  parametersNames,
  outputNames,
  samplingData,
  designName,
  plotOptions,
  ...
)
```

## Arguments

- arm:

  An object of class `Arm`.

- evaluationModelGradient:

  A list of data frames from `evaluateModelGradient`.

- parametersNames:

  A character vector of parameter names.

- outputNames:

  A list of strings giving the output names.

- samplingData:

  A list from `getSamplingData`.

- designName:

  A string giving the design name.

- plotOptions:

  A list with `unitTime` and `unitOutcomes`.

- ...:

  Additional arguments

## Value

A named list of `ggplot` objects per output and parameter.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
