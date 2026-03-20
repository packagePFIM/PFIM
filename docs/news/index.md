# Changelog

## PFIM 7.0.3

### Complete Package Redesign

- **Functional Programming Architecture**: Version 7.0 is entirely
  rebuilt using functional programming principles for improved
  performance and maintainability.

- **Breaking Changes**: This version introduces significant user script
  changes that require script updates from previous versions.

- **Enhanced Features**: New modeling capabilities and improved Bayesian
  FIM estimation.

### Key New Features

- **Flexible PK/PD Modeling**: Support for multiple PK responses with PD
  components (ode pk pk pk .. pd).

- **Expanded User Defined Model**: Additional models available (see BJCP
  test at <https://github.com/packagePFIM>).

- **Bayesian FIM Estimation**: Enhanced estimation for single sampling
  time scenarios.

- **Multi-dose Bolus Models**: New ODE-based multi-dose bolus modeling
  capabilities.

- **Object-Oriented Plot Interface**: A unified
  [`plot()`](https://packagePFIM.github.io/PFIM/reference/plot.md)
  method now dispatches automatically on the object class (`Evaluation`
  or `Optimization`), following the same OO convention as `plot.lm` in
  base R. The user no longer needs to know which specific plot function
  to call.

### Refined User Experience

- **Refined Documentation**: Vignettes 1 and 2 have been redesigned to
  provide a step-by-step guide to the design evaluation and optimization
  process, with integrated examples for plots and results display.

------------------------------------------------------------------------

## Migration Guide from PFIM 6.1 to PFIM 7.0

CRAN release: 2024-10-23

### 1. Equations of a user defined model

PFIM 6.1:

``` r
modelEquations = list(
  outcomes  = list("RespPK", "RespPD"),
  equations = list(
    "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V*t) - exp(-ka*t))",
    "RespPD" = "S0 * (1 - Imax * RespPK/(RespPK + C50))"
  )
)
```

PFIM 7.0:

``` r
modelEquations = list(
  "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V*t) - exp(-ka*t))",
  "RespPD" = "S0 * (1 - Imax * RespPK/(RespPK + C50))"
)
```

### 2. Model equations from the library of models

PFIM 7.0 introduces `modelFromLibrary` for predefined models:

``` r
modelFromLibrary = list(
  "PKModel" = "MichaelisMenten2InfusionSingleDose_VmKmk12k21V1V2",
  "PDModel" = "TurnoverRinEmax_RinEmaxCC50koutE"
)

evaluation = Evaluation(modelFromLibrary = modelFromLibrary, ...)
```

The `modelEquations` slot is no longer needed when using library models.

### 3. Model error

The outcome of an error model is modified.

- PFIM 6.1: `outcomes`
- PFIM 7.0: `outputs`

### 4. Arm

The specification of the dose in the initial conditions for an ODE model
is modified.

- PFIM 6.1: `initialCondition = list("C1" = "dose")`
- PFIM 7.0: `initialCondition = list("C1" = "dose_C1")`

### 5. Administration constraints

The constraints for the administration for the design optimization is
changed.

- PFIM 6.1 (vector): `doses = c(0.2, 0.64, 2, 6.24, 11.24, 20)`
- PFIM 7.0 (list): `doses = list(0.2, 0.64, 2, 6.24, 11.24, 20)`

### 6. Evaluation

The evaluation outcomes are changed.

- PFIM 6.1: `outcomes = list("RespPK")`
- PFIM 7.0: `outputs = list("RespPK")`

The specification of the FIM type is changed.

- PFIM 6.1: `fim = "..."`
- PFIM 7.0: `fimType = "..."`

### 7. Output methods

The plot method for the sensitivity indices is renamed.

- PFIM 6.1: `plotSensitivityIndice(...)`
- PFIM 7.0: `plotSensitivityIndices(...)`

Other changes:

- Correlation matrix removed from report in this version.
- SE and RSE extraction simplified: direct access without
  `[[designName]]` indexing.

### 8. Unified `plot()` interface (new in 7.0)

PFIM 7.0 introduces a single OO entry point for all plots.
[`plot()`](https://packagePFIM.github.io/PFIM/reference/plot.md)
dispatches automatically on the object class and returns a named list of
`ggplot2` objects. The `which` argument selects a subset; omitting it
computes all plots for the given class.

PFIM 6.1 (separate calls required):

``` r
evalPlots = plotEvaluation(results, plotOptions)
siPlots   = plotSensitivityIndices(results, plotOptions)
SEplot    = plotSE(results)
RSEplot   = plotRSE(results)
wPlot     = plotWeights(optimizationResults)
fPlot     = plotFrequencies(optimizationResults)
```

PFIM 7.0 (single call, named list returned):

``` r
# Evaluation object
p = plot(results,
         plotOptions = plotOptions,
         which       = c("evaluation", "sensitivityIndices", "SE", "RSE"))

p[["evaluation"]][["design1"]][["arm1"]][["RespPK"]]
p[["sensitivityIndices"]][["design1"]][["arm1"]][["RespPK"]][["Cl"]]
p[["SE"]]
p[["RSE"]]

# Optimization object -- weights (Multiplicative) or frequencies (Fedorov-Wynn)
p = plot(optimizationResults,
         plotOptions = plotOptions,
         which       = c("evaluation", "SE", "RSE", "weights"))

p[["weights"]]

# Skip slow plots
p = plot(results,
         plotOptions = plotOptions,
         which       = c("SE", "RSE"))
```

The specific functions `plotSE`, `plotRSE`, `plotEvaluation`,
`plotSensitivityIndices`, `plotWeights`, and `plotFrequencies` remain
fully exported for direct access when needed.
