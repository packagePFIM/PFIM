# Generate Numerical Intervals from Sampling Constraints

The `generateSamplingsFromSamplingConstraints` method transforms a
[`SamplingTimeConstraints`](https://packagepfim.github.io/PFIM/reference/SamplingTimeConstraints.md)
object into a structured list of mathematical intervals. These intervals
define the feasible search space for each optimizable sampling point.

## Arguments

- samplingTimeConstraints:

  An object of class
  [`SamplingTimeConstraints`](https://packagepfim.github.io/PFIM/reference/SamplingTimeConstraints.md)
  containing the user-defined constraints and windows.

## Value

A `list` named `intervalsConstraints`. Each element of the list is a
numeric vector of length 2 (lower and upper bound) representing the
search space for one optimizable sample.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
