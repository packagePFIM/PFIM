# Generate tables for the Bayesian Fim report

The `tablesForReport` method aggregates the results of a PFIM analysis
into three standardized tables. It provides a structured view of
parameter estimates, global design criteria, and the precision of the
estimation (Standard Errors and Relative Standard Errors).

## Arguments

- fim:

  An object of class
  [`PopulationFim`](https://packagepfim.github.io/PFIM/reference/PopulationFim.md)
  containing the calculated Fisher Information Matrix and derived
  statistics.

- evaluation:

  An object of class `Evaluation` providing the structural model context
  and output definitions.

## Value

A list of kable tables (Fixed Effects, Criteria, SE/RSE/Shrinkage).

fixedEffectsTable, FIMCriteriaTable, SEAndRSETable.

A `list` containing three data frames:

- `fixedEffectsTable`:

  Table of parameter names and values.

- `FIMCriteriaTable`:

  Summary of FIM-based optimality criteria.

- `SEAndRSETable`:

  Table of precision metrics (SE and RSE%).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
