# LibraryOfPKModels Class

The `LibraryOfPKModels` class is a specialized container for managing
and storing Pharmacokinetic (PK) model definitions.

## Usage

``` r
LibraryOfPKModels
```

## Format

An object of class `PFIM::LibraryOfPKModels` (inherits from
[`PFIM::LibraryOfModels`](https://packagepfim.github.io/PFIM/reference/LibraryOfModels.md),
`S7_object`) of length 1.

## Details

This class inherits from `LibraryOfModels`. It is specifically optimized
to handle PK-specific attributes such as absorption types (e.g., Bolus,
Infusion, Zero-Order), clearance structures, and compartmental volumes.

## Slots

- `models`:

  A named list of PK model structures (e.g., 1-compartment,
  2-compartment).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
