# Plot model responses for an arm

Generates `ggplot2` line plots of model responses, overlaying design
sampling points in red on the secondary x-axis.

## Usage

``` r
plotEvaluationResults(
  arm,
  evaluationModel,
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

- evaluationModel:

  A list of data frames from `evaluateModel`.

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

A named list of `ggplot` objects.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
