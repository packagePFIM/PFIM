# Evaluate the Variance Component of the Fisher Information Matrix

The `evaluateVarianceFIM` method calculates the portion of the Fisher
Information Matrix that corresponds to the variance parameters of the
Nonlinear Mixed Effects Model. This includes the inter-individual
variability (random effects) and the residual error components.

## Arguments

- arm:

  An object of class
  [`Arm`](https://packagepfim.github.io/PFIM/reference/Arm.md) defining
  the experimental design (sampling times, doses) for a group of
  subjects.

- model:

  An object of class
  [`Model`](https://packagepfim.github.io/PFIM/reference/Model.md)
  containing the structural equations and the statistical model for
  random effects.

- fim:

  An object of class
  [`PopulationFim`](https://packagepfim.github.io/PFIM/reference/PopulationFim.md)
  used as the container for the resulting matrices.

## Value

A `list` containing:

- `MFVar`: A matrix representing the Fisher Information for the variance
  parameters.

- `V`: The computed variance-covariance matrix of the observations.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
