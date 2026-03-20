# Format and set the Bayesian Fim results

The `setEvaluationFim` method processes the raw results from a model
evaluation to populate the detailed statistical slots of a
[`PopulationFim`](https://packagePFIM.github.io/PFIM/reference/PopulationFim.md)
object. It transforms the Fisher Information Matrix into actionable
metrics like Standard Errors (SE) and Relative Standard Errors (RSE).

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagePFIM.github.io/PFIM/reference/PopulationFim.md)
  to be updated.

- evaluation:

  An object of class `Evaluation` containing the outputs from the
  structural model and error engine.

## Value

The object `Fim` with formatted results and SE/RSE calculations.

The object `IndividualFim` with its fisherMatrix, fixedEffects,
shrinkage, condNumberFixedEffects, SEAndRSE.

The updated
[`PopulationFim`](https://packagePFIM.github.io/PFIM/reference/PopulationFim.md)
object, with the following slots populated: `fisherMatrix`,
`fixedEffects`, `shrinkage`, `condNumberFixedEffects`, and `SEAndRSE`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
