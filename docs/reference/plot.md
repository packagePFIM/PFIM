# plot

Generates plots for `Evaluation` or `Optimization` objects and returns
them as a named list. S7 dispatches automatically on the object class –
the user never needs to know which specific plot function to call.
Follows the same OO convention as `plot.lm` in base R.

## Usage

``` r
plot(x, plotOptions = list(), which = NULL, ...)
```

## Format

An object of class `character` of length 4.

## Arguments

- x:

  An object of class `Evaluation` or `Optimization`.

- plotOptions:

  A `list` of graphical options forwarded to `plotEvaluation` and
  `plotSensitivityIndices`. Defaults to
  [`list()`](https://rdrr.io/r/base/list.html).

- which:

  `character`. Subset of plots to compute. Partial matching supported
  (like `plot.lm`).

  - `Evaluation`: any subset of
    `c("evaluation", "sensitivityIndices", "SE", "RSE")`.

  - `Optimization`: any subset of
    `c("evaluation", "sensitivityIndices", "SE", "RSE", "weights", "frequencies")`.

  Default: all plots for the given class.

- ...:

  Additional arguments (ignored).

## Value

A named `list` of `ggplot2` objects.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## See also

[`plotEvaluation`](https://packagePFIM.github.io/PFIM/reference/plotEvaluation.md),
[`plotSensitivityIndices`](https://packagePFIM.github.io/PFIM/reference/plotSensitivityIndices.md),
[`plotSE`](https://packagePFIM.github.io/PFIM/reference/plotSE.md),
[`plotRSE`](https://packagePFIM.github.io/PFIM/reference/plotRSE.md),
[`plotWeights`](https://packagePFIM.github.io/PFIM/reference/plotWeights.md),
[`plotFrequencies`](https://packagePFIM.github.io/PFIM/reference/plotFrequencies.md)

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
results = run(evaluationPop)
p = plot(results,
         plotOptions = plotOptions,
         which       = c("evaluation", "sensitivityIndices", "SE", "RSE"))
p$SE

opt = run(optimizationMult)
p = plot(opt,
         plotOptions = plotOptions,
         which       = c("evaluation", "SE", "RSE", "weights"))
p$weights
} # }
```
