# ModelError Class

The class `ModelError` is used to defined a model error.

## Usage

``` r
ModelError(
  output = "output",
  equation = expression(),
  derivatives = list(),
  sigmaInter = 0.1,
  sigmaSlope = 0,
  sigmaInterFixed = FALSE,
  sigmaSlopeFixed = FALSE,
  cError = 1
)
```

## Arguments

- output:

  A string giving the model error output.

- equation:

  A expression giving the model error equation.

- derivatives:

  A list giving the derivatives of the model error equation.

- sigmaInter:

  A double giving the sigma inter.

- sigmaSlope:

  A double giving the sigma slope

- sigmaInterFixed:

  A boolean giving if the sigma inter is fixed or not.

- sigmaSlopeFixed:

  A boolean giving if the sigma slope is fixed or not.

- cError:

  A integer giving the power parameter.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# 1. Define an additive error model
# sigmaInter: intercept (additive), sigmaSlope: slope (proportional)
additiveError = ModelError(
  output     = "RespPK",
  sigmaInter = 0.1,
  sigmaSlope = 0.0
)
print(additiveError)
#> <PFIM::ModelError> <environment: 0x0000021f68175c10> 
#>  @ output         : chr "RespPK"
#>  @ equation       :  expression()
#>  @ derivatives    : list()
#>  @ sigmaInter     : num 0.1
#>  @ sigmaSlope     : num 0
#>  @ sigmaInterFixed: logi FALSE
#>  @ sigmaSlopeFixed: logi FALSE
#>  @ cError         : num 1

# 2. Define a combined error model (Additive + Proportional)
combinedError = ModelError(
  output     = "RespPK",
  sigmaInter = 0.05,
  sigmaSlope = 0.15
)
print(combinedError)
#> <PFIM::ModelError> <environment: 0x0000021f67c62310> 
#>  @ output         : chr "RespPK"
#>  @ equation       :  expression()
#>  @ derivatives    : list()
#>  @ sigmaInter     : num 0.05
#>  @ sigmaSlope     : num 0.15
#>  @ sigmaInterFixed: logi FALSE
#>  @ sigmaSlopeFixed: logi FALSE
#>  @ cError         : num 1
```
