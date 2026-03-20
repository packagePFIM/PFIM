# Display the Bayesian Fim in the console

The `showFIM` method provides a comprehensive summary of the Fisher
Information Matrix (FIM) results. It prints structural and statistical
metrics to the console, allowing the user to evaluate parameter
precision, numerical stability, and optimization criteria for a specific
design.

## Arguments

- fim:

  An object of class `IndividualFim` (or `PopulationFim`) containing the
  computed results.

## Value

Prints the FIM, fixed effects, criteria, and shrinkage to the console.

The fisherMatrix, fixedEffects, Determinant, condition numbers and
D-criterion, Shrinkage and Parameters estimation

This function returns a formatted summary to the console. It invisibly
returns a list containing the `fisherMatrix`, `fixedEffects`,
`Determinant`, `conditionNumbers`, `D-criterion`, and `Shrinkage`.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
