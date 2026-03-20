# Validate New Sampling Schedules Against Constraints

The `checkSamplingTimeConstraintsForMetaheuristic` method evaluates
whether a proposed set of sampling times is feasible. It checks the
timings against defined windows, fixed points, and minimum intervals
required for clinical safety or logistical practicality.

## Arguments

- samplingTimesConstraints:

  An object of class
  [`SamplingTimeConstraints`](https://packagePFIM.github.io/PFIM/reference/SamplingTimeConstraints.md)
  defining the allowed design space.

- arm:

  An object of class
  [`Arm`](https://packagePFIM.github.io/PFIM/reference/Arm.md)
  representing the experimental group being validated.

- newSamplings:

  A `vector` of numeric values representing the candidate sampling times
  proposed by the algorithm.

- outcome:

  A `string` specifying the model output (e.g., "PK", "PD") to which
  these samples belong.

## Value

A `logical` value: `TRUE` if the design is valid, `FALSE` otherwise. If
`FALSE`, a descriptive error message is usually printed to the console
or stored in the optimization log.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
