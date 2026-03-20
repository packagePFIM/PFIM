# LibraryOfModels Class

The `LibraryOfModels` class is a centralized container designed to store
and manage Pharmacokinetic (PK) and Pharmacodynamic (PD) model
definitions.

## Usage

``` r
LibraryOfModels(models = list())
```

## Arguments

- models:

  A named list containing the PK and PD model strings or objects.

## Details

This class acts as a bridge between structural model definitions and the
`Evaluation` engine, ensuring that PK/PD associations are correctly
mapped.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
