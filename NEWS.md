---
title: "PFIM 7.0 – What's New"
output:
  html_document:
    toc: false
    toc_depth: 2
    toc_float: false
    theme: null
    highlight: tango
    number_sections: false
    self_contained: true
fontsize: 18pt
mainfont: Lato
editor_options: 
  markdown: 
    wrap: 72
---

# PFIM 7.0.3

## Complete Package Redesign
* Entirely rebuilt using the **S7 object-oriented system** (successor to S3/S4) for improved performance and maintainability. 
* Core Class Refactoring: The Optimization, Evaluation, and plotEvaluation classes have been redesigned as fully compliant S7 objects, resulting in a more modular and stable codebase.
* Strategic S7 Refactoring: The Optimization, Evaluation, and plotEvaluation classes have been prioritized for full S7 compliance, serving as the cornerstone of the package's new modular architecture to ensure maximum stability and rigorous property validation.

## Breaking Changes 
* Significant updates required for user scripts from version 6.1.
* Changed `outcomes` slot to `outputs` in `ModelError` and `Evaluation` classes.
* Modified FIM type specification from `fim` to `fimType`.
* Updated ODE initial conditions: use `"dose_C1"` instead of `"dose"`.
* Administration constraints for `doses` now require a `list()` instead of a `vector()`.
* Sensitivity indices plot method renamed from `plotSensitivityIndice` to `plotSensitivityIndices`.
* SE and RSE extraction simplified (direct access without `[[designName]]` indexing).
* New plot() methods for comprehensive design assessment, including model output evaluation, parameter sensitivity indices, SE and RSE.
* All user-facing functions and methods in PFIM now include executable examples. All exported functions are now documented with @examples sections that illustrate primary use cases in a clear and reproducible manner

## Minor changes
* Naming Consistency: Renamed proportionsOfsubjects to proportionsOfSubjects to strictly adhere to the UpperCamelCase convention used throughout the PFIM package.

## New Features 
* **Flexible PK/PD Modeling**: Full support for multiple PK responses with PD components (ODE-based).
* **Library of Models**: Introduction of `modelFromLibrary` for quick access to predefined PK/PD models.
* **Bayesian FIM**: Enhanced estimation for single sampling time scenarios.
* **Multi-dose Bolus**: New ODE-based modeling for complex dosing regimens.
* **Documentation**: Completely redesigned Vignettes 1 and 2 with step-by-step guides for evaluation and optimization.

## Deprecated and Removed
* Version Deprecation: All versions of PFIM prior to 7.0.3 are now officially deprecated. Users are encouraged to migrate to the current release for improved stability.
* Report Streamlining: The correlation matrix has been removed from the standard report to simplify output, though diagnostic data remains accessible via specialized functions.
