# Extract Model Parameter Data for Reporting

The `getModelParametersData` function retrieves and summarizes the
properties of all parameters within a `Model` object. It compiles their
statistical characteristics—including distribution types, population
means, and variability—into a structured `data.frame` suitable for
display or export.

## Arguments

- model:

  A `Model` object containing a collection of `ModelParameter`
  instances.

## Value

A `data.frame` with the following columns:

- `Parameter`: The unique identifier of the parameter (e.g., "Cl", "V").

- `Distribution`: The statistical law applied (e.g., "Normal",
  "Log-Normal").

- `Mu`: The population mean value.

- `Fixed_Mu`: Logical; `TRUE` if the mean is fixed (not estimated).

- `Omega`: The inter-individual variability (IIV) value.

- `Fixed_Omega`: Logical; `TRUE` if the variance is fixed.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
