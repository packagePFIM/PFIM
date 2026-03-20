# Evaluation of the Bayesian Fim

Computes the Fisher Information Matrix for an individual design. This
method calculates the structural information (fixed effects) and the
variance information (residual error components) to assemble the final
FIM.

The `evaluateFim` method computes the numerical values of the Fisher
Information Matrix (FIM) for a given experimental design (arm). It
integrates the structural model, the parameter variances, and the
residual error model to quantify the expected precision of parameter
estimates. This method specifically computes:

- **The Fisher Matrix:** The expected information content for fixed and
  random effects.

- **Shrinkage:** An estimation of the "shrinkage" towards the population
  mean, providing insight into how well the design informs individual
  parameters.

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagepfim.github.io/PFIM/reference/PopulationFim.md)
  to be populated with results.

- model:

  An object of class `Model` containing the structural equations and
  parameter values.

- arm:

  An object of class `Arm` representing the sampling schedule and dose
  levels for a specific group.

## Value

The object `Fim` updated with the calculated fisherMatrix and shrinkage.

The `IndividualFim` object populated with the calculated `fisherMatrix`.

An object of class `PopulationFim` (updated with the `fisherMatrix` and
calculated `shrinkage` values).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
