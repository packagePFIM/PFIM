# Report

Creates a detailed HTML report from the design evaluation results,
including tables, matrices, and plots.

## Usage

``` r
Report(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class `PFIMProject`.

- ...:

  Additional arguments: outputPath, outputFile, plotOptions

## Value

Generates and saves an HTML report to `outputPath/outputFile`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Examples from Vignette 1 and 2

# Generate a comprehensive HTML report for the design evaluation
Report(
  pfimproject = evaluationPopulationFIMResults,
  outputPath  = "C:/MyResults",
  outputFile  = "Design_Evaluation_Report.html",
  plotOptions = plotOptions
)

} # }
```
