# MultiplicativeAlgorithm Class

The `MultiplicativeAlgorithm` class implements the multiplicative
algorithm for the continuous optimization of study design weights. This
approach iteratively updates weights to maximize a specific optimality
criterion (e.g., D-optimality).

## Usage

``` r
MultiplicativeAlgorithm(
  optimisationDesign = list(),
  optimisationAlgorithmOutputs = list(),
  name = character(0),
  modelParameters = list(),
  modelEquations = list(),
  modelFromLibrary = list(),
  modelError = list(),
  designs = list(),
  outputs = list(),
  fimType = character(0),
  odeSolverParameters = list(),
  optimizer = character(0),
  optimizerParameters = list(),
  lambda = 0,
  delta = 0,
  numberOfIterations = 0,
  weightThreshold = 0,
  showProcess = FALSE,
  multiplicativeAlgorithmOutputs = list()
)
```

## Arguments

- optimisationDesign:

  A list storing the evaluations (FIM, criteria, SE) of both the initial
  and the optimal design.

- optimisationAlgorithmOutputs:

  A list containing the logs and algorithm-specific outputs produced
  during the optimization process.

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

- optimizer:

  A character string naming the optimization algorithm.

- optimizerParameters:

  A named list of algorithm-specific hyperparameters.

- lambda:

  A `numeric` value for the relaxation parameter `lambda` (typically
  between 0 and 1).

- delta:

  A `numeric` convergence criterion `delta`.

- numberOfIterations:

  Maximum `integer` number of iterations to perform.

- weightThreshold:

  A `numeric` threshold; weights below this value are considered zero
  and effectively removed from the design.

- showProcess:

  `logical`; if `TRUE`, displays the optimization progress and
  convergence status in the console.

- multiplicativeAlgorithmOutputs:

  A `list` storing optimization results, including weight history and
  optimality criterion values.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# Example from Vignette 1: Initializing the Multiplicative algorithm for population FIM optimization

optimizationMultPopFIM = Optimization(
  name                = "PKPD_ODE_multi_doses_populationFIM",
  modelEquations      = modelEquations,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "MultiplicativeAlgorithm",
  optimizerParameters = list(
    lambda             = 0.99,    # near-unity: slow but stable weight updates
    numberOfIterations = 1000,    # maximum multiplicative iterations
    weightThreshold    = 0.01,    # discard protocols with weight < 1%
    delta              = 1e-04,   # stop when D-criterion improvement < 0.01%
    showProcess        = TRUE
  ),
  designs             = list(designConstraint),
  fimType             = "population",
  outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)

# Run the optimization and display results
optimizationResults = run(optimizationMultPopFIM)
show(optimizationResults)
} # }
```
