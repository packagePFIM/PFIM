# Optimize Study Design

Dispatches the optimization of a study design to the appropriate
algorithm. Methods are available for all PFIM optimization algorithms:
[`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md),
[`FedorovWynnAlgorithm`](https://packagepfim.github.io/PFIM/reference/FedorovWynnAlgorithm.md),
[`SimplexAlgorithm`](https://packagepfim.github.io/PFIM/reference/SimplexAlgorithm.md),
[`PSOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PSOAlgorithm.md),
and
[`PGBOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PGBOAlgorithm.md).

## Usage

``` r
optimizeDesign(optimizationObject, optimizationAlgorithm, ...)
```

## Arguments

- optimizationObject:

  An object of class
  [`Optimization`](https://packagepfim.github.io/PFIM/reference/Optimization.md)
  containing the design space, model, and objective function settings.

- optimizationAlgorithm:

  An object of the algorithm class to use (`MultiplicativeAlgorithm`,
  `FedorovWynnAlgorithm`, etc.).

- ...:

  Additional arguments passed to methods

## Value

The updated `optimizationObject` with optimized designs, final FIM
value, and algorithm-specific outputs stored in the relevant slots.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
