# Optimize Study Design

Dispatches the optimization of a study design to the appropriate
algorithm. Methods are available for all PFIM optimization algorithms:
[`MultiplicativeAlgorithm`](https://packagePFIM.github.io/PFIM/reference/MultiplicativeAlgorithm.md),
[`FedorovWynnAlgorithm`](https://packagePFIM.github.io/PFIM/reference/FedorovWynnAlgorithm.md),
[`SimplexAlgorithm`](https://packagePFIM.github.io/PFIM/reference/SimplexAlgorithm.md),
[`PSOAlgorithm`](https://packagePFIM.github.io/PFIM/reference/PSOAlgorithm.md),
and
[`PGBOAlgorithm`](https://packagePFIM.github.io/PFIM/reference/PGBOAlgorithm.md).

## Usage

``` r
optimizeDesign(optimizationObject, optimizationAlgorithm, ...)
```

## Arguments

- optimizationObject:

  An object of class
  [`Optimization`](https://packagePFIM.github.io/PFIM/reference/Optimization.md)
  containing the design space, model, and objective function settings.

- optimizationAlgorithm:

  An object of the algorithm class to use (`MultiplicativeAlgorithm`,
  `FedorovWynnAlgorithm`, `PSOAlgorithm`, etc.).

- ...:

  Additional arguments passed to methods

## Value

The updated `optimizationObject` with optimized designs, final FIM
value, and algorithm-specific outputs stored in the relevant slots.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
