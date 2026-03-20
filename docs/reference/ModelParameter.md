# ModelParameter Class

The `ModelParameter` class defines the characteristics of a model
parameter, including its identifier (name), statistical distribution
(mean and variance), and the estimation status of its components.

## Usage

``` r
ModelParameter(
  name = character(0),
  distribution = Distribution(),
  fixedMu = FALSE,
  fixedOmega = FALSE
)
```

## Arguments

- name:

  The parameter name (string).

- distribution:

  A `Distribution` object.

- fixedMu:

  Logical; indicates if the mean is fixed. Defaults to `FALSE`.

- fixedOmega:

  Logical; indicates if the variance is fixed. Defaults to `FALSE`.

## Value

An object of class `ModelParameter`.

## Slots

- `name`:

  `character`. A unique string identifying the parameter.

- `distribution`:

  `Distribution`. An object of class `Distribution` defining the
  statistical law (e.g., Log-Normal, Normal).

- `fixedMu`:

  `logical`. If `TRUE`, the population mean is fixed and will not be
  estimated.

- `fixedOmega`:

  `logical`. If `TRUE`, the inter-individual variability (omega) is
  fixed and will not be estimated.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# 1. Clearance with estimated mean and estimated variance (mu and omega)
clEstimated = ModelParameter(
  name         = "Cl",
  distribution = LogNormal(mu = 0.28, omega = 0.456),
  fixedMu      = FALSE,
  fixedOmega   = FALSE
)
print(clEstimated)
#> <PFIM::ModelParameter>
#>  @ name        : chr "Cl"
#>  @ distribution: <PFIM::LogNormal>
#>  .. @ name : chr(0) 
#>  .. @ mu   : num 0.28
#>  .. @ omega: num 0.456
#>  @ fixedMu     : logi FALSE
#>  @ fixedOmega  : logi FALSE

# 2. Clearance with fixed mean and fixed variance
# Useful for parameters known from literature (e.g., mu = log(20) approx 2.99)
clFixed = ModelParameter(
  name         = "Cl",
  distribution = LogNormal(mu = 2.99, omega = 0.1),
  fixedMu      = TRUE,
  fixedOmega   = TRUE
)
print(clFixed)
#> <PFIM::ModelParameter>
#>  @ name        : chr "Cl"
#>  @ distribution: <PFIM::LogNormal>
#>  .. @ name : chr(0) 
#>  .. @ mu   : num 2.99
#>  .. @ omega: num 0.1
#>  @ fixedMu     : logi TRUE
#>  @ fixedOmega  : logi TRUE
```
