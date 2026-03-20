# defineModelEquationsFromLibraryOfModel

The method extracts the structural mathematical equations from the
pre-defined PFIM library. This allows users to leverage standard
pharmacokinetic (PK) and pharmacodynamic (PD) models without manually
defining differential or algebraic equations.

## Usage

``` r
defineModelEquationsFromLibraryOfModel(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class
  [`PFIMProject`](https://packagepfim.github.io/PFIM/reference/PFIMProject.md)
  containing the library selection criteria.

- ...:

  Additional arguments.

## Value

A `list` of character strings or expressions representing the structural
model equations.

## Details

This function references the `modelFromLibrary` property of the
`PFIMProject`. It maps library identifiers to a specific set of symbolic
or numeric equations used by the evaluation engine. Typical library
models include:

- **One-compartment:** Bolus, Infusion, or First-order absorption.

- **Multi-compartment:** Distribution models with various elimination
  routes.

- **Standard PD:** Emax, Sigmoid Emax, or Indirect response models.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
