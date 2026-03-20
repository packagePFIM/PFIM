# Evaluate an arm

Evaluates the model, gradients, variance, and FIM for an arm.

## Usage

``` r
evaluateArm(arm, model, fim, ...)
```

## Arguments

- arm:

  An object of class `Arm`.

- model:

  An object of class `Model`.

- fim:

  An object of class `Fim`.

- ...:

  Additional arguments

## Value

The `Arm` object with updated `evaluationModel`, `evaluationGradients`,
`evaluationVariance`, and `evaluationFim`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
