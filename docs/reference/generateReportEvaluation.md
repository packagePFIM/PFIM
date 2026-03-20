# Generate a Comprehensive HTML Evaluation Report

The `generateReportEvaluation` method compiles all computed Fisher
Information Matrix (FIM) results into a standalone HTML document. This
report serves as the final deliverable for a design evaluation,
summarizing parameter precision, design efficiency, and numerical
stability.

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagePFIM.github.io/PFIM/reference/PopulationFim.md)
  containing the finalized FIM data.

- tablesForReport:

  A `list` of data frames (as returned by
  [`tablesForReport`](https://packagePFIM.github.io/PFIM/reference/tablesForReport.md))
  containing the formatted statistical summaries.

## Value

An HTML file (or a path to the generated file) containing the complete
model evaluation report.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
