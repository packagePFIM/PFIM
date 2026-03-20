# ModelODEDoseNotInEquations Class

The `ModelODEDoseNotInEquations` class defines an ODE-based model where
doses are handled as discrete events rather than continuous functions
within the equations. This is typically used for bolus administrations
where the dose results in an instantaneous change in state variables.

## Usage

``` r
ModelODEDoseNotInEquations(
  name = character(0),
  modelParameters = list(),
  samplings = numeric(0),
  modelEquations = list(),
  wrapper = function() NULL,
  outputFormula = list(),
  outputNames = character(0),
  variableNames = character(0),
  outcomesWithAdministration = character(0),
  outcomesWithNoAdministration = character(0),
  modelError = list(),
  odeSolverParameters = list(),
  parametersForComputingGradient = list(),
  initialConditions = numeric(0),
  functionArguments = character(0),
  functionArgumentsSymbol = list(),
  modelODE = function() NULL,
  doseEvent = list(),
  solverInputs = list()
)
```

## Arguments

- name:

  A `character` vector specifying the name of the model.

- modelParameters:

  A `list` of objects defining the model parameters.

- samplings:

  A `numeric` vector specifying the planned sampling times.

- modelEquations:

  A `list` containing the system of equations (analytical or ODEs).

- wrapper:

  A `function` wrapper used to interface the model (defaults to
  `function() NULL`).

- outputFormula:

  A `list` of mathematical formulas for the model outputs.

- outputNames:

  A `character` vector defining the names of the output variables.

- variableNames:

  A `character` vector defining the names of the state variables.

- outcomesWithAdministration:

  A `character` vector specifying outcomes associated with drug
  administration.

- outcomesWithNoAdministration:

  A `character` vector specifying outcomes without drug administration.

- modelError:

  A `list` defining the residual error model structure.

- odeSolverParameters:

  A `list` of parameters for the ODE solver (e.g., `atol`, `rtol`).

- parametersForComputingGradient:

  A `list` of parameters required for numerical gradient computation.

- initialConditions:

  A `numeric` vector specifying the initial state of the system.

- functionArguments:

  A `character` vector of arguments required by the model function.

- functionArgumentsSymbol:

  A `list` of symbols representing the function arguments.

- modelODE:

  An object of class `modelODE` defining the structural differential
  equations.

- doseEvent:

  A `data.frame` containing the event schedule (time, dose amount,
  compartment index) required by the ODE solver.

- solverInputs:

  A `list` providing specific configurations for the numerical
  integrator, such as event-handling logic.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
