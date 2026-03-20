# PGBOAlgorithm Class

The `PGBOAlgorithm` class implements a stochastic optimization routine
based on population genetics principles. It is designed to navigate
complex design spaces by simulating mutation, selection, and purging
processes to maximize the Fisher Information Matrix (FIM) criteria.

## Usage

``` r
PGBOAlgorithm(
  N = 30,
  muteEffect = 0.65,
  maxIteration = 1000,
  purgeIteration = 200,
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

- N:

  A numeric value specifying the population size (number of individuals)
  per generation.

- muteEffect:

  A numeric value (0-1) representing the mutation rate or the intensity
  of the genetic mutation effect.

- maxIteration:

  An integer specifying the maximum number of generations before the
  algorithm terminates.

- purgeIteration:

  An integer defining the frequency (in iterations) at which "weak"
  individuals are removed from the population to maintain genetic
  fitness.

- seed:

  A numeric value for the random number generator to ensure
  reproducibility of the optimization results.

- showProcess:

  A logical value; if `TRUE`, the algorithm prints progress updates and
  fitness scores to the console.

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

# Initializing the PGBO algorithm for population FIM optimization
optimizationPGBOPopFIM = Optimization(
  name                = "optimizationExamplePGBO",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "PGBOAlgorithm",
  optimizerParameters = list(
    N              = 30,    # population of 30 candidate designs
    muteEffect     = 0.65,  # mutation amplitude (65% of window width)
    maxIteration   = 1000,  # total evolutionary steps
    purgeIteration = 200,  # reinitialize worst solutions every 200 steps
    seed           = 42,
    showProcess    = FALSE
  ),
  designs             = list(design2),
  fimType             = "population",
  outputs             = list("RespPK")
)

# Run the PGBO optimization and display the results
resultsPGBOPopFIM = run(optimizationPGBOPopFIM)
show(resultsPGBOPopFIM)

} # }
```
