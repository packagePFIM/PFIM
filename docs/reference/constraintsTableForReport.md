# Generate Algorithm Constraints Table for Reporting

Extracts and formats the design constraints and algorithm
hyperparameters into a structured table suitable for inclusion in PFIM
reports. Methods are available for all optimization algorithms:
[`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md),
[`FedorovWynnAlgorithm`](https://packagepfim.github.io/PFIM/reference/FedorovWynnAlgorithm.md),
[`SimplexAlgorithm`](https://packagepfim.github.io/PFIM/reference/SimplexAlgorithm.md),
[`PSOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PSOAlgorithm.md),
and
[`PGBOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PGBOAlgorithm.md).

## Usage

``` r
constraintsTableForReport(optimizationAlgorithm, ...)
```

## Arguments

- optimizationAlgorithm:

  An object of one of the PFIM optimization algorithm classes.

- ...:

  Additional arguments passed to methods.

## Value

A `kable` object containing the formatted constraints table, listing
arm-level and algorithm-level settings.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
