# Evaluation Class

The \`Evaluation\` class represents and stores all information required
to evaluate a clinical trial design. it serves as the main interface for
calculating the Fisher Information Matrix (FIM), Standard Errors (SE),
and other design criteria.

## Usage

``` r
Evaluation(
  evaluationDesign = list(),
  name = character(0),
  modelParameters = list(),
  modelEquations = list(),
  modelFromLibrary = list(),
  modelError = list(),
  designs = list(),
  outputs = list(),
  fimType = character(0),
  odeSolverParameters = list()
)
```

## Arguments

- evaluationDesign:

  A list containing the evaluation results of the design.

- name:

  A string representing the name of the project or evaluation study.

- modelParameters:

  A list defining the fixed effects and random effects (variances) of
  the model.

- modelEquations:

  A list containing the mathematical equations of the model.

- modelFromLibrary:

  A list specifying the pre-defined model selected from the PFIM
  library.

- modelError:

  A list specifying the residual error model (e.g., constant,
  proportional, or combined).

- designs:

  A list of \`Design\` objects representing the experimental protocols
  to be evaluated.

- outputs:

  A list defining the observation variables or responses of the model.

- fimType:

  A string specifying the FIM calculation method (e.g., "Population",
  "Individual", "Bayesian").

- odeSolverParameters:

  A list containing technical settings for the ODE solver, such as
  `atol` and `rtol`.

## Value

An object of class `Evaluation`.

## Slots

- `evaluationDesign`:

  `list`. Stores the results of the design evaluation.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Example: Evaluation of the Population Fisher Information Matrix (FIM)
# extracted from Vignette n°1.

evaluationPop = Evaluation(
  name                = "evaluation_example",
  modelEquations      = modelEquations,
  modelParameters     = modelParameters,
  modelError          = modelError,
  outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
  designs             = list(design1),
  fimType             = "population",
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)

# Display the results (Standard Errors, RSE, etc.)
show(evaluationPop)

} # }
```
