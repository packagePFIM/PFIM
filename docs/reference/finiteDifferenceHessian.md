# Compute the Hessian

Prepares the necessary parameters and data structures for the
computation of gradients and the Hessian matrix via the finite
difference method. This includes calculating inverse column scales
(`XcolsInv`), shifted parameter values, and step size fractions.

## Arguments

- model:

  An object of class
  [`Model`](https://packagePFIM.github.io/PFIM/reference/Model.md)
  containing the structural and error model definitions.

## Value

Returns the `Model` object with the updated slot
`parametersForComputingGradient`, now containing:

- `XcolsInv`: The inverse of the column scaling factors.

- `shifted`: The perturbed parameter values for finite differences.

- `frac`: The fractional step size used for the perturbations.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
