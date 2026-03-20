# Define the Fisher Information Matrix object

This method initializes and configures the specific type of Fisher
Information Matrix to be calculated within a `PFIMProject`. It maps the
project's statistical assumptions (Population, Individual, or Bayesian)
to the underlying FIM computational engine.

- **Population:** For Nonlinear Mixed Effects Models (NLME), accounting
  for inter-individual variability.

- **Individual:** For standard fixed-effects models where only one
  subject/profile is considered.

- **Bayesian:** When prior distributions for the parameters are
  incorporated into the information matrix.

## Usage

``` r
defineFim(pfimproject, ...)
```

## Arguments

- pfimproject:

  An object of class
  [`PFIMProject`](https://packagePFIM.github.io/PFIM/reference/PFIMProject.md)
  containing the model and design specifications.

- ...:

  Additional arguments.

## Value

An object of class
[`Fim`](https://packagePFIM.github.io/PFIM/reference/Fim.md) initialized
with the settings defined in the project.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
