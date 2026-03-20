# Visualize Optimal Weight Distribution from Multiplicative Algorithm

Generates a bar plot representing the optimal weights allocated to each
study arm after the execution of the multiplicative algorithm. This
visualization quickly highlights which arms have been retained or
prioritized by the optimization process.

## Arguments

- optimization:

  An object of class
  [`Optimization`](https://packagePFIM.github.io/PFIM/reference/Optimization.md)
  containing the optimized weights.

- optimizationAlgorithm:

  An object of class
  [`MultiplicativeAlgorithm`](https://packagePFIM.github.io/PFIM/reference/MultiplicativeAlgorithm.md)
  used for the optimization.

## Value

A `ggplot2` graphical object representing the weights per arm.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
