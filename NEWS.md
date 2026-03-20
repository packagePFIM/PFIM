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

\<style\>
body {
max-width: 960px;
margin: 2em auto;
font-family: "Lato", "Helvetica Neue", Helvetica, Arial, sans-serif;
line-height: 1.7;
color: #DDD;
background-color: #121212;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
}

h1, h2, h3 {
margin-top: 1.5em;
margin-bottom: 0.75em;
font-weight: 700;
color: #EEE;
}

pre, code {
font-family: Consolas, Monaco, "Courier New", monospace;
font-size: 90%;
background-color: #1E1E1E;
color: #DDD;
padding: 0.3em 0.5em;
border-radius: 4px;
overflow-x: auto;
}

a {
color: #58A6FF;
text-decoration: none;
}

a:hover {
text-decoration: underline;
}

img {
border: none;
}
\</style\>

This version fully replaces the version of PFIM 6.1

### Complete Package Redesign

-   **Functional Programming Architecture**: Version 7.0 is entirely
    rebuilt using functional programming principles for improved
    performance and maintainability.

-   **Breaking Changes**: This version introduces significant user
    script changes that require script updates from previous versions

-   **Enhanced Features**: New modeling capabilities and improved
    Bayesian FIM estimation

### Key New Features

-   **Flexible PK/PD Modeling**: Support for multiple PK responses with
    PD components (ode pk pk pk .. pd)

-   **Expanded User Defined Model**: Additional models available (see
    BJCP test in <https://github.com/packagePFIM>)

-   **Bayesian FIM Estimation**: Enhanced estimation for single sampling
    time scenarios

-   **Multi-dose Bolus Models**: New ODE-based multi-dose bolus modeling
    capabilities

### Refined User Experience

-   **Refined Documentation**: Vignettes 1 and 2 have been redesigned to provide a step-by-step guide to the 
    design evaluation and optimization process. These updates now include integrated examples for plot results and show results, 
    ensuring a seamless and user-friendly experience for all PFIM users.

## Migration Guide from PFIM 6.1 to PFIM 7.0

### 1. Equations of a user defined model

-   PFIM 6.1:

```{r, echo = TRUE, comment='',eval=FALSE} 
modelEquations` = `list( outcomes = list( "RespPK", "RespPD" ), 
                         equations = list( "RespPK" = "dose_RespPK/V * ka/( ka - Cl/V ) * ( exp( -Cl/V *t ) - exp(-ka * t ) )", 
                         "RespPD" = "S0 * ( 1 - Imax * RespPK/( RespPK + C50 ) )" ) )
```
-   PFIM 7.0:
```{r, echo = TRUE, comment='',eval=FALSE} 
modelEquations = list( "RespPK" = "dose_RespPK/V * ka/( ka - Cl/V )*( exp( -Cl/V * t ) - exp( -ka * t ) )", 
                        "RespPD" = "S0 * ( 1 - Imax * RespPK/( RespPK + C50 ) )" )
```

### 2. Model equations from the library of models.

PFIM 7.0 introduces `modelFromLibrary` for predefined models:

```{r, echo = TRUE, comment='',eval=FALSE} 
modelFromLibrary = list( "PKModel" = "MichaelisMenten2InfusionSingleDose_VmKmk12k21V1V2", 
                         "PDModel" = "TurnoverRinEmax_RinEmaxCC50koutE" )
```

and the evaluation writes:

```{r, echo = TRUE, comment='',eval=FALSE} 
evaluation = Evaluation( modelFromLibrary = modelFromLibrary, ... )
```

without the slots `modelEquations`.

### 3. Model error

The outcome od an error model is modified.

-   PFIM 6.1: `outcomes`
-   PFIM 7.0: `outputs`

### 4. Arm

The specification of the dose in the initial conditions for an ode model
is modified.

-   PFIM 6.1: `initialCondition = list( "C1" = "dose" )`
-   PFIM 7.0: `initialCondition = list( "C1" = "dose_C1" )`

### 5. Administration constraints

The constraints for the administration for the design optimization is
changed.

-   PFIM 6.1 (vector): `doses = c( 0.2, 0.64, 2, 6.24, 11.24, 20 )`
-   PFIM 7.0 (list): `doses = list( 0.2, 0.64, 2, 6.24, 11.24, 20 )`

### 6. Evaluation

The evaluation outcomes are changed.

-   PFIM 6.1: `outcomes = list( "RespPK" )`
-   PFIM 7.0: `outputs = list( "RespPK" )`

The specification of the Fim type is changed.

-   PFIM 6.1: `fim = " ... "\`
-   PFIM 7.0 `fimType = " ... "`

### 7. Output methods

The plot method for the sensitivity indices is changed.

- PFIM 6.1: `plotSensitivityIndice = plotSensitivityIndice( ..., ... )`
- PFIM 7.0: `plotSensitivityIndices = plotSensitivityIndices( ..., ... )`
- Correlation matrix removed from report in this version
- SE and RSE extraction simplified with direct access without `[[designName]]` indexing

 
