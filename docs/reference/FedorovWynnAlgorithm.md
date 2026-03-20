# FedorovWynnAlgorithm Class

The class `FedorovWynnAlgorithm` implements the FedorovWynn algorithm.
The class `FedorovWynnAlgorithm` implements the Fedorov-Wynn exchange
algorithm. This algorithm is used for discrete design optimization,
iteratively adding or exchanging elementary protocols to maximize the
determinant of the Fisher Information Matrix (D-optimality).

## Usage

``` r
FedorovWynnAlgorithm(
  elementaryProtocols = list(),
  numberOfSubjects = 0,
  proportionsOfSubjects = 0,
  showProcess = FALSE,
  FedorovWynnAlgorithmOutputs = list(),
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
  odeSolverParameters = list()
)
```

## Arguments

- elementaryProtocols:

  A list of elementary protocols available for selection.

- numberOfSubjects:

  A numeric vector specifying the number of subjects per arm.

- proportionsOfSubjects:

  A numeric vector of subject proportions for each protocol.

- showProcess:

  A logical indicating whether to display optimization progress.

- FedorovWynnAlgorithmOutputs:

  A list storing the results of the optimization.

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

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{

# Example from Vignette 1: Population FIM optimization using Fedorov-Wynn

# 1. Initialize the Optimization object
optiFW <- Optimization(
  name                = "FedorovWynn_Optimization",
  modelEquations      = modelEquations,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "FedorovWynnAlgorithm",
  optimizerParameters = list(
    elementaryProtocols   = initialElementaryProtocols,
    numberOfSubjects      = numberOfSubjects,
    proportionsOfSubjects = proportionsOfSubjects,
    showProcess           = TRUE
  ),
  designs             = list(designConstraint),
  fimType             = "population",
  outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)

# 2. Run the optimization algorithm
optimizationResults = run(optiFW)

# 3. Display the optimized design and Fisher Information Matrix
show(optimizationResults)

} # }
```
