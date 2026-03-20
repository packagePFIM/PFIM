# Get arm constraints for optimization algorithms

Extracts administration and sampling time constraints formatted for the
`MultiplicativeAlgorithm`, `FedorovWynnAlgorithm`, `SimplexAlgorithm`,
`PSOAlgorithm`, or `PGBOAlgorithm`.

## Usage

``` r
getArmConstraints(arm, optimizationAlgorithm, ...)
```

## Arguments

- arm:

  An object of class
  [`Arm`](https://packagepfim.github.io/PFIM/reference/Arm.md).

- optimizationAlgorithm:

  An object of class `MultiplicativeAlgorithm`, `FedorovWynnAlgorithm`,
  `SimplexAlgorithm`, `PSOAlgorithm`, or `PGBOAlgorithm`.

- ...:

  Additional arguments

## Value

A list of constraint entries, one per sampling outcome.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
