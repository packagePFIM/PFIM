# Design Class

The `Design` class represents a full clinical trial design. It acts as a
container for multiple `Arm` objects and stores the population-level
Fisher Information Matrix (FIM) and evaluation results for the entire
study.

## Usage

``` r
Design(
  name = character(0),
  size = 0,
  arms = list(),
  evaluationArms = list(),
  numberOfArms = 0,
  fim = Fim()
)
```

## Arguments

- name:

  A string giving the name of the design.

- size:

  A numeric value representing the total number of subjects.

- arms:

  A list of `Arm` objects defining the different groups.

- evaluationArms:

  A list containing the evaluation results for each arm.

- numberOfArms:

  An integer giving the number of arms.

- fim:

  An object of class `Fim` giving the global FIM of the design.

## Value

An object of class `Design`.

## Slots

- `name`:

  `character`. The name of the design.

- `size`:

  `numeric`. Total number of subjects across all arms.

- `arms`:

  `list`. A list containing the `Arm` objects.

- `numberOfArms`:

  `numeric`. The count of arms in the design.

- `fim`:

  `Fim`. The global Fisher Information Matrix for the design.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# 1. Define sampling times for PK and PD outcomes
samplingTimesRespPK = SamplingTimes(outcome   = "RespPK",
                                     samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))

samplingTimesRespPD = SamplingTimes(outcome   = "RespPD",
                                     samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))

# 2. Define the administration (Dose of 20 at t=0)
adminRespPK = Administration(outcome = "RespPK", timeDose = 0, dose = 20)

# 3. Define the study arm "0.2mg"
# Outcomes are linked to state variables: RespPK to Cc, RespPD to E.
arm02mg = Arm(name = "0.2mg",
               size = 6,
               administrations   = list(adminRespPK),
               samplingTimes     = list(samplingTimesRespPK, samplingTimesRespPD),
               initialConditions = list("Cc" = 0, "E" = 100))

# 4. Create the Design object
# The arm defined above is included in the 'arms' list.
design1 = Design(name = "Design1",
                  arms = list(arm02mg))

# Display the design summary
print(design1)
#> <PFIM::Design>
#>  @ name          : chr "Design1"
#>  @ size          : num 0
#>  @ arms          :List of 1
#>  .. $ : <PFIM::Arm>
#>  ..  ..@ name                      : chr "0.2mg"
#>  ..  ..@ size                      : num 6
#>  ..  ..@ administrations           :List of 1
#>  .. .. .. $ : <PFIM::Administration>
#>  .. .. ..  ..@ outcome : chr "RespPK"
#>  .. .. ..  ..@ timeDose: num 0
#>  .. .. ..  ..@ dose    : num 20
#>  .. .. ..  ..@ Tinf    : num(0) 
#>  .. .. ..  ..@ tau     : num 0
#>  ..  ..@ initialConditions         :List of 2
#>  .. .. .. $ Cc: num 0
#>  .. .. .. $ E : num 100
#>  ..  ..@ samplingTimes             :List of 2
#>  .. .. .. $ : <PFIM::SamplingTimes>
#>  .. .. ..  ..@ outcome  : chr "RespPK"
#>  .. .. ..  ..@ samplings: num [1:9] 0.25 0.5 0.75 1 1.25 1.5 2 3 4
#>  .. .. .. $ : <PFIM::SamplingTimes>
#>  .. .. ..  ..@ outcome  : chr "RespPD"
#>  .. .. ..  ..@ samplings: num [1:9] 0.25 0.5 0.75 1 1.25 1.5 2 3 4
#>  ..  ..@ administrationsConstraints: list()
#>  ..  ..@ samplingTimesConstraints  : list()
#>  ..  ..@ evaluationModel           : list()
#>  ..  ..@ evaluationGradients       : list()
#>  ..  ..@ evaluationVariance        : list()
#>  ..  ..@ evaluationFim             : <PFIM::Fim>
#>  .. .. .. @ fisherMatrix             : num(0) 
#>  .. .. .. @ fixedEffects             : num(0) 
#>  .. .. .. @ varianceEffects          : num(0) 
#>  .. .. .. @ SEAndRSE                 : list()
#>  .. .. .. @ condNumberFixedEffects   : num 0
#>  .. .. .. @ condNumberVarianceEffects: num 0
#>  .. .. .. @ shrinkage                : num(0) 
#>  @ evaluationArms: list()
#>  @ numberOfArms  : num 0
#>  @ fim           : <PFIM::Fim>
#>  .. @ fisherMatrix             : num(0) 
#>  .. @ fixedEffects             : num(0) 
#>  .. @ varianceEffects          : num(0) 
#>  .. @ SEAndRSE                 : list()
#>  .. @ condNumberFixedEffects   : num 0
#>  .. @ condNumberVarianceEffects: num 0
#>  .. @ shrinkage                : num(0) 
```
