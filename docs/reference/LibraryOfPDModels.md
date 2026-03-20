# LibraryOfPDModels Class

The `LibraryOfPDModels` class is a specialized container for managing
and storing Pharmacodynamic (PD) model definitions.

## Usage

``` r
LibraryOfPDModels
```

## Format

An object of class `PFIM::LibraryOfPDModels` (inherits from
[`PFIM::LibraryOfModels`](https://packagepfim.github.io/PFIM/reference/LibraryOfModels.md),
`S7_object`) of length 1.

## Details

This class inherits from
[`LibraryOfModels`](https://packagepfim.github.io/PFIM/reference/LibraryOfModels.md)
and provides a dedicated structure for pharmacodynamic responses. It is
designed to handle various PD mechanisms, including direct effect models
(Emax, Sigmoid Emax), indirect response models (Turnover), and
kinetic-pharmacodynamic (K-PD) structures.

## Slots

- `models`:

  A named list of PD model structures (e.g., Emax, Indirect Response).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
