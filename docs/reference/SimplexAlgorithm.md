# SimplexAlgorithm Class

The `SimplexAlgorithm` class implements the Nelder-Mead downhill simplex
method for derivative-free optimization. It is particularly robust for
non-smooth objective functions in population FIM optimization.

## Usage

``` r
SimplexAlgorithm(
  pctInitialSimplexBuilding = 10,
  maxIteration = 1000,
  tolerance = 1e-10,
  seed = 42,
  showProcess = FALSE,
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

- pctInitialSimplexBuilding:

  A numeric value giving the percent variation used to build the initial
  simplex around the starting point.

- maxIteration:

  An integer specifying the maximum number of iterations allowed.

- tolerance:

  A numeric value for the convergence tolerance on the FIM criterion.

- seed:

  A numeric value for the random number generator seed (if applicable).

- showProcess:

  A logical value; if `TRUE`, prints optimization progress to the
  console at each iteration.

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

# Examples from Vignette 2

# Initializing the Simplex algorithm for population FIM optimization
optimizationSimplexPopFIM = Optimization(
  name                = "optimizationExampleSimplex",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "SimplexAlgorithm",
  optimizerParameters = list(
    pctInitialSimplexBuilding = 10,    # initial spread: 10% of window widths
    maxIteration              = 1000,  # max Nelder-Mead iterations
    tolerance                 = 1e-10, # convergence on relative D-criterion change
    showProcess               = FALSE
  ),
  designs             = list(design2),
  fimType             = "population",
  outputs             = list("RespPK")
)

# Run the Simplex optimization and display the results
resultsSimplexPopFIM = run(optimizationSimplexPopFIM)
show(resultsSimplexPopFIM)

} # }
```
