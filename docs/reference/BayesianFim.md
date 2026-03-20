# BayesianFim Class

The `BayesianFim` class stores the Bayesian Fisher Information Matrix
(FIM). It extends the standard `Fim` class by incorporating
Bayesian-specific metrics, such as the shrinkage of individual
parameters.

## Usage

``` r
BayesianFim(
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

  A numerical matrix representing the FIM.

- fixedEffects:

  A matrix representing fixed effects information.

- varianceEffects:

  A matrix representing variance components information.

- SEAndRSE:

  A data frame containing calculated SE and RSE values.

- condNumberFixedEffects:

  A numeric value for the fixed effects condition number.

- condNumberVarianceEffects:

  A numeric value for the variance effects condition number.

- shrinkage:

  A numeric vector representing parameter shrinkage.

## Slots

- `fisherMatrix`:

  `matrix`. The numerical values of the Bayesian FIM.

- `shrinkage`:

  `numeric vector`. The shrinkage values for each random effect.

- `fixedEffects`:

  `matrix`. The FIM components related to fixed effects.

- `varianceEffects`:

  `matrix`. The FIM components related to variance components (random
  effects).

- `SEAndRSE`:

  `data.frame`. Standard Errors (SE) and Relative Standard Errors (RSE).

- `condNumberFixedEffects`:

  `numeric`. The condition number for the fixed effects sub-matrix.

- `condNumberVarianceEffects`:

  `numeric`. The condition number for the variance effects sub-matrix.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
