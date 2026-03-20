# Proportional Class

The `Proportional` class defines a proportional residual error model,
where the standard deviation of the error is proportional to the
predicted value.

## Usage

``` r
Proportional(
  output = character(0),
  equation = expression(sigmaSlope),
  derivatives = list(),
  sigmaInter = 0,
  sigmaSlope = 0,
  sigmaInterFixed = FALSE,
  sigmaSlopeFixed = FALSE,
  cError = 1
)
```

## Arguments

- output:

  A string specifying the name of the model output (e.g., "RespPK").

- equation:

  An `expression` defining the error model relationship.

- derivatives:

  A `list` containing the analytic derivatives of the error equation.

- sigmaInter:

  A `numeric` specifying the additive error component (intercept).

- sigmaSlope:

  A `numeric` specifying the proportional error component (slope).

- sigmaInterFixed:

  A `logical` indicating if the intercept parameter is fixed.

- sigmaSlopeFixed:

  A `logical` indicating if the slope parameter is fixed.

- cError:

  A `numeric` representing the power parameter (typically 1.0).

## Value

An object of class `Proportional`.

## Slots

- `output`:

  `character`. The name of the model output (e.g., "RespPK").

- `sigmaSlope`:

  `numeric`. The proportional error component (slope).

- `sigmaSlopeFixed`:

  `logical`. If `TRUE`, the slope is fixed.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Define a proportional error model for a PK output "RespPK"
errorModelRespPK = Proportional(
  output     = "RespPK",
  sigmaSlope = 0.10
)

# Display the proportional error model summary
print(errorModelRespPK)
#> <PFIM::Proportional> function (output = "output", equation = expression(), derivatives = list(), 
#>     sigmaInter = 0.1, sigmaSlope = 0, sigmaInterFixed = FALSE, sigmaSlopeFixed = FALSE, 
#>     cError = 1)  
#>  @ output         : chr "RespPK"
#>  @ equation       :  expression(sigmaSlope)
#>  @ derivatives    : list()
#>  @ sigmaInter     : num 0
#>  @ sigmaSlope     : num 0.1
#>  @ sigmaInterFixed: logi FALSE
#>  @ sigmaSlopeFixed: logi FALSE
#>  @ cError         : num 1
```
