# Arm Class

The `Arm` class represents an experimental group within a study. It
integrates all components of the design for that group, including the
sample size, dosing regimens, sampling schedules, and initial conditions
for ODE models.

## Usage

``` r
Arm(
  name = character(0),
  size = numeric(0),
  administrations = list(),
  initialConditions = list(),
  samplingTimes = list(),
  administrationsConstraints = list(),
  samplingTimesConstraints = list(),
  evaluationModel = list(),
  evaluationGradients = list(),
  evaluationVariance = list(),
  evaluationFim = Fim()
)
```

## Arguments

- name:

  A string giving the name of the arm.

- size:

  An integer giving the number of subjects in the arm.

- administrations:

  A list of `Administration` objects defining the dosing.

- initialConditions:

  A named list of numeric values for ODE initial states.

- samplingTimes:

  A list of `SamplingTimes` objects defining the observations.

- administrationsConstraints:

  A list of `AdministrationsConstraints` objects.

- samplingTimesConstraints:

  A list of `SamplingTimesConstraints` objects.

- evaluationModel:

  A list containing the evaluation of the responses.

- evaluationGradients:

  A list containing the evaluation of the gradients.

- evaluationVariance:

  A list containing the evaluation of the variance.

- evaluationFim:

  An object of class `Fim` representing the Fisher Information Matrix.

## Value

An object of class `Arm`.

## Slots

- `name`:

  `character`. The unique identifier for the arm.

- `size`:

  `numeric`. The number of subjects assigned to this arm.

- `administrations`:

  `list`. A list of `Administration` objects.

- `initialConditions`:

  `list`. A named list where keys are variable names (strings) and
  values are their initial states (numeric).

- `samplingTimes`:

  `list`. A list of `SamplingTimes` objects.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Note: The 'initialConditions' slot is strictly used for ODE-based model arms.
# For analytic (closed-form) solutions, this slot is ignored as the
# initial state is implicitly defined by the model equations.

# 1. Define sampling times for PK and PD outcomes
samplingTimesRespPK = SamplingTimes(outcome = "RespPK",
                                     samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))

samplingTimesRespPD = SamplingTimes(outcome = "RespPD",
                                     samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))

# 2. Define the administration (Dose of 20 at t=0)
adminRespPK = Administration(outcome = "RespPK", timeDose = 0, dose = 20)

# 3. Define the study arm "0.2mg"
# Outcomes are linked to state variables: RespPK to Cc, RespPD to E.
arm = Arm(name = "0.2mg",
           size = 6,
           administrations = list(adminRespPK),
           samplingTimes   = list(samplingTimesRespPK, samplingTimesRespPD),
           initialConditions = list("Cc" = 0, "E" = 100))

print(arm)
#> <PFIM::Arm>
#>  @ name                      : chr "0.2mg"
#>  @ size                      : num 6
#>  @ administrations           :List of 1
#>  .. $ : <PFIM::Administration>
#>  ..  ..@ outcome : chr "RespPK"
#>  ..  ..@ timeDose: num 0
#>  ..  ..@ dose    : num 20
#>  ..  ..@ Tinf    : num(0) 
#>  ..  ..@ tau     : num 0
#>  @ initialConditions         :List of 2
#>  .. $ Cc: num 0
#>  .. $ E : num 100
#>  @ samplingTimes             :List of 2
#>  .. $ : <PFIM::SamplingTimes>
#>  ..  ..@ outcome  : chr "RespPK"
#>  ..  ..@ samplings: num [1:9] 0.25 0.5 0.75 1 1.25 1.5 2 3 4
#>  .. $ : <PFIM::SamplingTimes>
#>  ..  ..@ outcome  : chr "RespPD"
#>  ..  ..@ samplings: num [1:9] 0.25 0.5 0.75 1 1.25 1.5 2 3 4
#>  @ administrationsConstraints: list()
#>  @ samplingTimesConstraints  : list()
#>  @ evaluationModel           : list()
#>  @ evaluationGradients       : list()
#>  @ evaluationVariance        : list()
#>  @ evaluationFim             : <PFIM::Fim>
#>  .. @ fisherMatrix             : num(0) 
#>  .. @ fixedEffects             : num(0) 
#>  .. @ varianceEffects          : num(0) 
#>  .. @ SEAndRSE                 : list()
#>  .. @ condNumberFixedEffects   : num 0
#>  .. @ condNumberVarianceEffects: num 0
#>  .. @ shrinkage                : num(0) 
```
