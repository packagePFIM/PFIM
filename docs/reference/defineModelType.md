# defineModelType

The method acts as a constructor for the specific model class required
for analysis. It extracts configurations from a
[`PFIMProject`](https://packagePFIM.github.io/PFIM/reference/PFIMProject.md)
and instantiates a `Model` object, integrating equations, parameter
structures, error models, and solver settings.

## Usage

``` r
defineModelType(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class
  [`PFIMProject`](https://packagePFIM.github.io/PFIM/reference/PFIMProject.md)
  containing the project specifications.

- ...:

  Additional arguments.

## Value

An object of class `Model` (or a subclass thereof) initialized with
`modelParameters`, `odeSolverParameters`, `modelError`, and
`modelEquations`.

## Details

This method determines whether the model should be treated as a:

- **Library Model:** Pre-defined structural models (e.g., 1-compartment
  PK).

- **User-Defined Model:** Custom equations provided via
  `modelEquations`.

- **ODE Model:** Models requiring numerical integration using specified
  `odeSolverParameters`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
