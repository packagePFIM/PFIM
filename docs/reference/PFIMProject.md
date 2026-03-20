# PFIMProject Class

The \`PFIMProject\` class is the central orchestrator for a Population
Fisher Information Matrix (PFIM) analysis. It encapsulates all necessary
components for design evaluation or optimization, including structural
models, statistical parameters, experimental designs, and optimization
settings.

## Usage

``` r
PFIMProject(
  name = character(0),
  modelEquations = list(),
  modelFromLibrary = list(),
  modelParameters = list(),
  modelError = list(),
  optimizer = character(0),
  optimizerParameters = list(),
  outputs = list(),
  designs = list(),
  fimType = character(0),
  fim = Fim(),
  odeSolverParameters = list()
)
```

## Arguments

- name:

  A string representing the name of the project or evaluation study.

- modelEquations:

  A list containing the mathematical equations of the model.

- modelFromLibrary:

  A list specifying the pre-defined model selected from the PFIM
  library.

- modelParameters:

  A list defining the fixed effects and random effects (variances) of
  the model.

- modelError:

  A list specifying the residual error model (e.g., constant,
  proportional, or combined).

- optimizer:

  A string identifying the optimization algorithm to be used (e.g.,
  "Simplex", "Fedov").

- optimizerParameters:

  A list of settings for the chosen optimizer (e.g., iterations,
  tolerance).

- outputs:

  A list defining the observation variables or responses of the model.

- designs:

  A list of \`Design\` objects representing the experimental protocols
  to be evaluated.

- fimType:

  A string specifying the FIM calculation method (e.g., "Population",
  "Individual", "Bayesian").

- fim:

  An object of class `Fim` representing the computed Fisher Information
  Matrix.

- odeSolverParameters:

  A list containing technical settings for the ODE solver, such as
  `atol` and `rtol`.

## Slots

- `name`:

  `character`

- `modelEquations`:

  `list`

- `modelFromLibrary`:

  `list`

- `modelParameters`:

  `list`

- `modelError`:

  `list`

- `optimizer`:

  `character`

- `optimizerParameters`:

  `list`

- `outputs`:

  `list`

- `designs`:

  `list`

- `fimType`:

  `character`

- `fim`:

  `Fim`

- `odeSolverParameters`:

  `list`

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
