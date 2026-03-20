# Fisher Information Matrix (FIM) Class

The `Fim` class represents the Fisher Information Matrix in the context
of population pharmacokinetics and pharmacodynamics. It acts as a
container for the numerical matrix and derived statistical metrics used
to evaluate design performance, such as parameter precision and
shrinkage.

## Usage

``` r
Fim(
  fisherMatrix = numeric(0),
  fixedEffects = numeric(0),
  varianceEffects = numeric(0),
  SEAndRSE = list(),
  condNumberFixedEffects = 0,
  condNumberVarianceEffects = 0,
  shrinkage = numeric(0)
)
```

## Arguments

- fisherMatrix:

  A matrix giving the numerical values of the Fim.

- fixedEffects:

  A matrix giving the numerical values of the fixed effects of the Fim.

- varianceEffects:

  A matrix giving the numerical values of variance effects of the Fim.

- SEAndRSE:

  A data frame giving the calculated values of SE and RSE for
  parameters.

- condNumberFixedEffects:

  The condition number of the fixed effects portion of the Fim.

- condNumberVarianceEffects:

  The condition number of the variance effects portion of the Fim.

- shrinkage:

  A vector giving the shrinkage values for the random effects.

## Value

An object of class `Fim`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
