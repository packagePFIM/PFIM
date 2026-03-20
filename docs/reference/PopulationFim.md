# PopulationFim Class

The `PopulationFim` class is a child of the `Fim` class. It is
specifically designed to store and manage the Fisher Information Matrix
calculated for population-level analyses. Unlike individual FIMs, it
incorporates the variance-covariance components of the random effects,
providing a measure of the information content regarding both structural
and statistical parameters.

- Determining the Standard Errors (SE) of population parameters.

- Calculating the Relative Standard Errors (RSE%).

- Evaluating and optimizing designs for clinical trials.

## Usage

``` r
PopulationFim(
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

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
