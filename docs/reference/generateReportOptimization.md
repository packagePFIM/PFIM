# Generate the HTML Report for Design Optimization

The `generateReportOptimization` method compiles the results of a design
optimization into a professional HTML document. It specifically handles
the output of the
[`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md),
documenting the transition from the initial design to the optimal
sampling schedule.

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagepfim.github.io/PFIM/reference/PopulationFim.md)
  containing the Fisher Information Matrix of the final optimized
  design.

- optimizationAlgorithm:

  An object of class
  [`MultiplicativeAlgorithm`](https://packagepfim.github.io/PFIM/reference/MultiplicativeAlgorithm.md)`,`[`FedorovWynnAlgorithm`](https://packagepfim.github.io/PFIM/reference/FedorovWynnAlgorithm.md)` `[`SimplexAlgorithm`](https://packagepfim.github.io/PFIM/reference/SimplexAlgorithm.md)`,`[`PSOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PSOAlgorithm.md)`,`[`PGBOAlgorithm`](https://packagepfim.github.io/PFIM/reference/PGBOAlgorithm.md).

- tablesForReport:

  A `list` of data frames (as returned by
  [`tablesForReport`](https://packagepfim.github.io/PFIM/reference/tablesForReport.md))
  containing the final optimized statistical summaries.

## Value

An HTML report file (or a path to the file) containing the detailed
optimization results and diagnostic plots.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
