# Individual Fisher Information Matrix (IndividualFim) Class

The `IndividualFim` class represents and stores the Fisher Information
Matrix (FIM) calculated for a single individual's design. In contrast to
a population FIM, it focuses solely on the precision of the fixed
parameters (or individual parameters) without considering
inter-individual variability.

## Usage

``` r
IndividualFim(
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

## Methods

- `calculateDcriterion`:

  Computes the D-optimality criterion.

- `calculateEfficiency`:

  Compares the efficiency of two individual designs.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
