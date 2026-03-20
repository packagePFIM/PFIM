# PSOAlgorithm Class

The `PSOAlgorithm` class is a subclass of
[`Optimization`](https://packagepfim.github.io/PFIM/reference/Optimization.md)
that implements the PSO metaheuristic. It optimizes experimental designs
by moving a "swarm" of candidate solutions (particles) through the
search space.

## Usage

``` r
PSOAlgorithm(
  maxIteration = 100,
  populationSize = 50,
  seed = 42,
  personalLearningCoefficient = 2.05,
  globalLearningCoefficient = 2.05,
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

- maxIteration:

  An integer specifying the maximum number of iterations before the
  algorithm stops.

- populationSize:

  An integer specifying the number of particles in the swarm. Larger
  populations explore the space better but increase computation time.

- seed:

  A numeric value for the random number generator to ensure
  reproducibility of the optimization results.

- personalLearningCoefficient:

  A numeric value (often denoted as \\c_1\\) that controls the
  "cognitive" component—how much the particle trusts its own best
  experience.

- globalLearningCoefficient:

  A numeric value (often denoted as \\c_2\\) that controls the "social"
  component—how much the particle follows the swarm's best experience.

- showProcess:

  A logical. If `TRUE`, the algorithm prints the current best fitness
  and iteration progress to the R console.

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

# Initializing the PSO algorithm for population FIM optimization
optimizationPSOPopFIM = Optimization(
  name                = "optimizationExamplePSO",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "PSOAlgorithm",
  optimizerParameters = list(
    maxIteration                = 100,   # number of swarm update cycles
    populationSize              = 50,    # number of particles
    personalLearningCoefficient = 2.05,  # c1: attraction toward personal best
    globalLearningCoefficient   = 2.05,  # c2: attraction toward global best
    seed                        = 42,    # reproducibility
    showProcess                 = FALSE  # suppress iteration-level output
  ),
  designs             = list(design2),
  fimType             = "population",
  outputs             = list("RespPK")
)

# Run the PSO optimization and display the results
resultsPSOPopFIM = run(optimizationPSOPopFIM)
show(resultsPSOPopFIM)

} # }
```
