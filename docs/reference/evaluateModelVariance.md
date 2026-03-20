# Evaluate Model Variance and Sigma Derivatives

Evaluates the residual error variance of the model and computes the
partial derivatives with respect to the variance parameters
(\\\sigma\\).

## Arguments

- model:

  An object of class
  [`Model`](https://packagePFIM.github.io/PFIM/reference/Model.md)
  defining the structural and residual error models.

- arm:

  An object of class
  [`Arm`](https://packagePFIM.github.io/PFIM/reference/Arm.md) defining
  the design (sampling times and doses) for a specific group.

## Value

A `list` containing:

- `errorVariance`: A numeric vector or matrix representing the evaluated
  residual variance.

- `sigmaDerivatives`: The derivatives of the variance with respect to
  the \\\sigma\\ parameters.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
