# Set the optimal arms for Multiplicative Algorithm

The `setOptimalArms` method identifies and extracts the best performing
experimental arms from an optimization routine. It converts the output
of the
[`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md)
into a structured list of optimized experimental designs.

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagepfim.github.io/PFIM/reference/PopulationFim.md)
  containing the Fisher Information Matrix evaluated at the optimal
  design points.

- optimizationAlgorithm:

  An object of class
  [`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md)[`FedorovWynnAlgorithm`](https://packagepfim.github.io/PFIM/reference/FedorovWynnAlgorithm.md)
  representing the solver that has completed its execution. sampling
  schedule and dosing protocols that maximize the optimization
  criterion.

## Value

A list of the optimal arms.

A list of the optimal arms.

The list optimalArms.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
