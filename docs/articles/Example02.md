# Design Evaluation and Optimization in Continuous Space

------------------------------------------------------------------------

## Design Evaluation

### Model Equations from from Library of Models

PFIM provides a library of pre-implemented standard PK/PD structural
models. `modelFromLibrary` replaces `modelEquations` — the two arguments
are mutually exclusive. The key `"PKModel"` is used for pharmacokinetic
models.

The string `"Linear1InfusionSingleDose_ClV"` decodes as:

| Token | Meaning |
|:---|:---|
| `Linear` | First-order (linear) elimination |
| `1` | One-compartment disposition |
| `Infusion` | IV infusion route; requires `Tinf` in [`Administration()`](https://packagepfim.github.io/PFIM/reference/Administration.md) |
| `ClV` | Parameterised by clearance $Cl$ and volume $V$ |

The predicted concentration follows:

$$C_{c}(t) = \begin{cases}
{\frac{D}{T_{inf} \cdot Cl}\!\left( 1 - e^{-\frac{Cl}{V}t} \right)} & {0 \leq t \leq T_{inf}} \\
{C_{c}\left( T_{inf} \right)\, e^{-\frac{Cl}{V}{(t - T_{inf})}}} & {t > T_{inf}}
\end{cases}$$

``` r
modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_ClV")
```

### Model Parameters

The model has two structural parameters, both log-normally distributed:

| Parameter | Description | $\mu$ | $\omega$ | Fixed $\mu$ | Fixed $\omega$ |
|:--:|:---|---:|---:|:--:|:--:|
| $V$ | Volume of distribution (L) | 50 | $\sqrt{0.26} \approx 0.51$ | No | No |
| $Cl$ | Total clearance (L/h) | 5 | $\sqrt{0.34} \approx 0.58$ | No | No |

IIV of ~51% for $V$ reflects moderate variability in body composition;
~58% for $Cl$ is typical of metabolic clearance variability. Note that
$\omega$ is the standard deviation on the log scale:
`omega = sqrt(variance)`.

``` r
modelParameters = list(
  ModelParameter(name = "V",  distribution = LogNormal(mu = 50, omega = sqrt(0.26))),
  ModelParameter(name = "Cl", distribution = LogNormal(mu = 5,  omega = sqrt(0.34)))
)
```

### Residual Error Model

A `Combined1` error model is used for the PK response.

``` r
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = sqrt( 0.15 ) )
modelError = list( errorModelRespPK )
```

### Administration Parameters

The dosing schedule encodes the full multiple-dose regimen. The loading
dose (400 mg = 2× maintenance) rapidly raises $C_{c}$ toward the
therapeutic target; subsequent 200 mg doses maintain near-steady-state
concentrations.

``` r
administrationRespPK = Administration(
  outcome  = "RespPK",
  Tinf     = rep(1, 5),           # 1-hour infusion for each of the 5 doses
  timeDose = seq(0, 96, 24),      # dosing at t = 0, 24, 48, 72, 96 h
  dose     = c(400, rep(200, 4))  # 400 mg loading + 4 × 200 mg maintenance
)
```

### Sampling Times

Six sampling times cover distinct phases of the multi-dose concentration
profile:

| Time (h) | Pharmacokinetic phase                           |
|:--------:|:------------------------------------------------|
|    1     | End of first infusion — $C_{max}$ of dose 1     |
|    12    | Mid-interdose Day 1 — early elimination         |
|    24    | Trough before dose 2 — $C_{min}$ after dose 1   |
|    44    | Near $C_{max}$ of dose 2 (dose at 24 h + ~20 h) |
|    72    | Trough before dose 4 — approaching steady state |
|   120    | 24 h after the last dose — post-SS elimination  |

``` r
samplingTimesRespPK = SamplingTimes(
  outcome   = "RespPK",
  samplings = c(1, 12, 24, 44, 72, 120)
)
```

### Arm and Design

A single arm with all 150 subjects on the same regimen. No
`initialCondition` is required: the library model sets $C_{c}(0) = 0$
internally for IV infusion models.

``` r
arm1 = Arm(
  name            = "arm1",
  size            = 150,
  administrations = list(administrationRespPK),
  samplingTimes   = list(samplingTimesRespPK)
)

design1 = Design(name = "design1", arms = list(arm1))
```

### FIM Evaluation: Population, Individual, and Bayesian FIM

``` r
# --- Population FIM ---
evaluationPop = Evaluation(
  name                = "evaluationPop",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  outputs             = list("RespPK"),
  designs             = list(design1),
  fimType             = "population",
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)
evaluationPopResults = run(evaluationPop)

# --- Individual FIM ---
evaluationInd = Evaluation(
  name                = "evaluationInd",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  outputs             = list("RespPK"),
  designs             = list(design1),
  fimType             = "individual",
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)
evaluationIndResults = run(evaluationInd)

# --- Bayesian FIM ---
evaluationBay = Evaluation(
  name                = "evaluationBay",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  outputs             = list("RespPK"),
  designs             = list(design1),
  fimType             = "Bayesian",
  odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
)
evaluationBayResults = run(evaluationBay)
```

``` r
show(evaluationPopResults)
```

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl      ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1393880 -0.2899109   0.00000   0.00000        0.00000         0.0000
    μ_Cl           -0.2899109 14.3204999   0.00000   0.00000        0.00000         0.0000
    ω²_V            0.0000000  0.0000000 404.77110  17.51007       51.06227       259.6216
    ω²_Cl           0.0000000  0.0000000  17.51007 427.24316       54.71243        80.1080
    σ_inter_RespPK  0.0000000  0.0000000  51.06227  54.71243     1982.21804      1361.3658
    σ_slope_RespPK  0.0000000  0.0000000 259.62165  80.10800     1361.36582      1648.5030

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1393880 -0.2899109
    μ_Cl -0.2899109 14.3204999

    *************************************** 
     Variance components 
    *************************************** 

                        ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           404.77110  17.51007       51.06227       259.6216
    ω²_Cl           17.51007 427.24316       54.71243        80.1080
    σ_inter_RespPK  51.06227  54.71243     1982.21804      1361.3658
    σ_slope_RespPK 259.62165  80.10800     1361.36582      1648.5030

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 380849659427.786 
    D-criterion: 85.1384217619946 
    Conditional number of the fixed effects: 107.343235280232 
    Conditional number of the random effects: 12.6420305367204 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.73670901  5.473418
    μ_Cl                  5.0000000 0.26999904  5.399981
    ω²_V                  0.2600000 0.05481857 21.084067
    ω²_Cl                 0.3400000 0.04861157 14.297522
    σ_inter_RespPK        0.5000000 0.03570392  7.140784
    σ_slope_RespPK        0.3872983 0.04131312 10.667003

``` r
show(evaluationIndResults)
```

    *************************************** 
     Individual Fisher Matrix 
    *************************************** 

                            μ_V        μ_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.003831386 -0.03578704        0.00000        0.00000
    μ_Cl           -0.035787035  0.74495930        0.00000        0.00000
    σ_inter_RespPK  0.000000000  0.00000000       16.79391       12.15818
    σ_slope_RespPK  0.000000000  0.00000000       12.15818       20.61786

    *************************************** 
     Fixed effects 
    *************************************** 

                  μ_V        μ_Cl
    μ_V   0.003831386 -0.03578704
    μ_Cl -0.035787035  0.74495930

    *************************************** 
     Variance components 
    *************************************** 

                   σ_inter_RespPK σ_slope_RespPK
    σ_inter_RespPK       16.79391       12.15818
    σ_slope_RespPK       12.15818       20.61786

    *********************************************** 
     Determinant, condition numbers and D-criterion 
    *********************************************** 

    Determinant: 0.312237623200518 
    D-criterion: 0.747517403243219 
    Conditional number of the fixed effects: 354.325216014069 
    Conditional number of the variance effects: 4.84715360183152 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE      RSE
    μ_V                  50.0000000 21.7585945 43.51719
    μ_Cl                  5.0000000  1.5604237 31.20847
    σ_inter_RespPK        0.5000000  0.3223403 64.46806
    σ_slope_RespPK        0.3872983  0.2909168 75.11439

``` r
show(evaluationBayResults)
```

    *************************************** 
     Bayesian Fisher Matrix 
    *************************************** 

               μ_V      μ_Cl
    μ_V   9.580004 -8.946759
    μ_Cl -8.946759 18.741630

    *************************************** 
     Fixed effects 
    *************************************** 

               μ_V      μ_Cl
    μ_V   9.580004 -8.946759
    μ_Cl -8.946759 18.741630

    *********************************************** 
     Determinant, condition numbers and D-criterion 
    *********************************************** 

    Determinant: 99.5003949119652 
    D-criterion: 9.9749884667585 
    Conditional number of the fixed effects: 5.89169416176677 

    *************************************** 
     Shrinkage 
    *************************************** 

          Shrinkage
    μ_V  0.02897805
    μ_Cl 1.13271843

    *************************************** 
     Parameters estimation 
    *************************************** 

         parametersValues        SE       RSE
    μ_V                50 0.4340015 0.8680031
    μ_Cl                5 0.3102919 6.2058381

``` r
cat("--- Fisher Information Matrix (population FIM) ---\n")
print(getFisherMatrix(evaluationPopResults))

cat("--- Correlation Matrix (population FIM) ---\n")
print(getCorrelationMatrix(evaluationPopResults))

cat("--- Standard Errors ---\n")
print(getSE(evaluationPopResults))

cat("--- Relative Standard Errors ---\n")
print(getRSE(evaluationPopResults))

cat("--- Shrinkage ---\n")
print(getShrinkage(evaluationPopResults))

cat("--- D-Criterion ---\n")
print(getDcriterion(evaluationPopResults))
```

#### Response profiles

``` r
plotOptions = list(unitTime = "hour", unitOutcomes = "mcg/mL")
# plot() is the unified OO entry point -- dispatches on class, returns a named list:
#   $evaluation         -> nested [["design"]][["arm"]][["outcome"]]
#   $sensitivityIndices -> nested [["design"]][["arm"]][["outcome"]][["param"]]
#   $SE / $RSE          -> ggplot2 bar charts
# Predicted concentration profile with sampling times overlaid
plotsEval = plot(evaluationPopResults,
                 plotOptions = plotOptions,
                 which       = c("evaluation", "sensitivityIndices", "SE", "RSE"))
plotOutcomesRespPK = plotsEval$evaluation[["design1"]][["arm1"]][["RespPK"]]
print(plotOutcomesRespPK)
```

![PK response profile -- arm1 (population
FIM)](figures/vignette2_evaluation_popFim_design1_arm1_RespPK.png)

PK response profile – arm1 (population FIM)

#### Sensitivity indices

``` r
# $sensitivityIndices is computed in the same plot() call above
print(plotsEval$sensitivityIndices[["design1"]][["arm1"]][["RespPK"]][["V"]])
print(plotsEval$sensitivityIndices[["design1"]][["arm1"]][["RespPK"]][["Cl"]])
```

![Sensitivity index for V -- RespPK,
arm1](figures/vignette2_evaluation_popFim_design1_SI_RespPK_V.png)

Sensitivity index for V – RespPK, arm1

![Sensitivity index for Cl -- RespPK,
arm1](figures/vignette2_evaluation_popFim_design1_SI_RespPK_Cl.png)

Sensitivity index for Cl – RespPK, arm1

#### Standard errors and Relative Standard errors

``` r
# Standard error and RSE bar charts -- computed in the same plot() call above
print(plotsEval$SE)
print(plotsEval$RSE)
```

![Standard Errors
(SE)](figures/vignette2_evaluation_popFim_design1_SE.png)

Standard Errors (SE)

![Relative Standard Errors
(RSE)](figures/vignette2_evaluation_popFim_design1_RSE.png)

Relative Standard Errors (RSE)

------------------------------------------------------------------------

## Design Optimization in Continuous Space

**Objective.** Find 4 optimal sampling times (instead of the original
6), constrained to two disjoint time windows, maximizing the D-criterion
of the population FIM $M_{PF}$:

$$\max\limits_{t_{1},\ldots,t_{4}}\;\left| M_{PF}(\xi) \right|^{1/p}\quad\text{s.t.}\quad t_{1},t_{2} \in \lbrack 1,\, 48\rbrack,\quad t_{3},t_{4} \in \lbrack 72,\, 120\rbrack,\quad\left| t_{i} - t_{j} \right| \geq 5\,\text{h}$$

Three algorithms - PSO, PGBO, Simplex - are used.

### Shared Optimization Setup

``` r
samplingTimesOptim = SamplingTimes(
  outcome   = "RespPK",
  samplings = c(1, 48, 72, 120)   # initial guess: window boundaries
)

samplingConstraintsRespPK = SamplingTimeConstraints(
  outcome                = "RespPK",
  initialSamplings       = c(1, 48, 72, 120),
  numberOfTimesByWindows = c(2, 2),
  samplingsWindows       = list(c(1,  48),    # Window 1: post-dose 1 to pre-dose 3
                                c(72, 120)),  # Window 2: near-SS to post-last-dose
  minSampling            = 5                  # min 5 h between consecutive samples
)

arm2 = Arm(
  name                     = "arm2",
  size                     = 150,
  administrations          = list(administrationRespPK),
  samplingTimes            = list(samplingTimesOptim),
  samplingTimesConstraints = list(samplingConstraintsRespPK)
)

# numberOfArms = 150: upper bound on distinct elementary protocols
design2 = Design(name = "design2", arms = list(arm2), numberOfArms = 150)
```

### PSO Algorithm (Particle Swarm Optimization)

``` r
optimizationPSO = Optimization(
  name                = "PSO",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "PSOAlgorithm",
  optimizerParameters = list(
    maxIteration                = 100,
    populationSize              = 50,
    personalLearningCoefficient = 2.05,
    globalLearningCoefficient   = 2.05,
    seed                        = 42,
    showProcess                 = FALSE
  ),
  designs  = list(design2),
  fimType  = "population",
  outputs  = list("RespPK")
)
optimizationPSO = run(optimizationPSO)
```

``` r
show(optimizationPSO)
```

    ===================================== 
      Initial design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose   Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 48, 72, 120)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl      ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1354839 -0.3248313   0.00000   0.00000        0.00000        0.00000
    μ_Cl           -0.3248313 12.1107623   0.00000   0.00000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 382.41404  21.98237       44.63647      264.88128
    ω²_Cl           0.0000000  0.0000000  21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  0.0000000  0.0000000  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK  0.0000000  0.0000000 264.88128  79.50987      653.06837      634.97897

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1354839 -0.3248313
    μ_Cl -0.3248313 12.1107623

    *************************************** 
     Variance components 
    *************************************** 

                        ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           382.41404  21.98237       44.63647      264.88128
    ω²_Cl           21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK 264.88128  79.50987      653.06837      634.97897

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 41386277548.9818 
    D-criterion: 58.8133694373923 
    Conditional number of the fixed effects: 95.6713072499344 
    Conditional number of the random effects: 18.4576745614613 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.80859742  5.617195
    μ_Cl                  5.0000000 0.29706229  5.941246
    ω²_V                  0.2600000 0.07073645 27.206328
    ω²_Cl                 0.3400000 0.05824621 17.131237
    σ_inter_RespPK        0.5000000 0.04347975  8.695951
    σ_slope_RespPK        0.3872983 0.07639997 19.726386

    ===================================== 
      Optimal design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose   Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 24, 97, 120)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl       ω²_V      ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1553579 -0.1841623   0.000000   0.000000        0.00000        0.00000
    μ_Cl           -0.1841623 12.4931400   0.000000   0.000000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 502.835221   7.065782       52.29275      247.79202
    ω²_Cl           0.0000000  0.0000000   7.065782 325.163639      101.06946       95.55499
    σ_inter_RespPK  0.0000000  0.0000000  52.292752 101.069458      698.92855      623.89899
    σ_slope_RespPK  0.0000000  0.0000000 247.792018  95.554992      623.89899     1641.69761

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1553579 -0.1841623
    μ_Cl -0.1841623 12.4931400

    *************************************** 
     Variance components 
    *************************************** 

                         ω²_V      ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           502.835221   7.065782       52.29275      247.79202
    ω²_Cl            7.065782 325.163639      101.06946       95.55499
    σ_inter_RespPK  52.292752 101.069458      698.92855      623.89899
    σ_slope_RespPK 247.792018  95.554992      623.89899     1641.69761

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 207256273436.376 
    D-criterion: 76.9280305604956 
    Conditional number of the fixed effects: 81.881392644448 
    Conditional number of the random effects: 6.92393338504603 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.55953621  5.119072
    μ_Cl                  5.0000000 0.28542513  5.708503
    ω²_V                  0.2600000 0.04654285 17.901095
    ω²_Cl                 0.3400000 0.05674885 16.690838
    σ_inter_RespPK        0.5000000 0.04739386  9.478773
    σ_slope_RespPK        0.3872983 0.03156589  8.150277

### PGBO Algorithm (Population genetic-based optimization)

``` r
optimizationPGBO = Optimization(
  name                = "PGBO",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "PGBOAlgorithm",
  optimizerParameters = list(
    N              = 30,
    muteEffect     = 0.65,
    maxIteration   = 1000,
    purgeIteration = 200,
    seed           = 42,
    showProcess    = FALSE
  ),
  designs  = list(design2),
  fimType  = "population",
  outputs  = list("RespPK")
)
optimizationPGBO = run(optimizationPGBO)
```

``` r
show(optimizationPGBO)
```

    ===================================== 
      Initial design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose   Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 48, 72, 120)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl      ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1354839 -0.3248313   0.00000   0.00000        0.00000        0.00000
    μ_Cl           -0.3248313 12.1107623   0.00000   0.00000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 382.41404  21.98237       44.63647      264.88128
    ω²_Cl           0.0000000  0.0000000  21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  0.0000000  0.0000000  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK  0.0000000  0.0000000 264.88128  79.50987      653.06837      634.97897

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1354839 -0.3248313
    μ_Cl -0.3248313 12.1107623

    *************************************** 
     Variance components 
    *************************************** 

                        ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           382.41404  21.98237       44.63647      264.88128
    ω²_Cl           21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK 264.88128  79.50987      653.06837      634.97897

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 41386277548.9818 
    D-criterion: 58.8133694373923 
    Conditional number of the fixed effects: 95.6713072499344 
    Conditional number of the random effects: 18.4576745614613 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.80859742  5.617195
    μ_Cl                  5.0000000 0.29706229  5.941246
    ω²_V                  0.2600000 0.07073645 27.206328
    ω²_Cl                 0.3400000 0.05824621 17.131237
    σ_inter_RespPK        0.5000000 0.04347975  8.695951
    σ_slope_RespPK        0.3872983 0.07639997 19.726386

    ===================================== 
      Optimal design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose      Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 48, 72.97, 120)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl       ω²_V      ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1548932 -0.1689487   0.000000   0.000000        0.00000        0.00000
    μ_Cl           -0.1689487 11.6800910   0.000000   0.000000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 499.831270   5.946593       56.06854      245.91576
    ω²_Cl           0.0000000  0.0000000   5.946593 284.217764      122.82514       88.37993
    σ_inter_RespPK  0.0000000  0.0000000  56.068542 122.825140      792.72088      609.27763
    σ_slope_RespPK  0.0000000  0.0000000 245.915762  88.379926      609.27763     1578.56182

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1548932 -0.1689487
    μ_Cl -0.1689487 11.6800910

    *************************************** 
     Variance components 
    *************************************** 

                         ω²_V      ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           499.831270   5.946593       56.06854      245.91576
    ω²_Cl            5.946593 284.217764      122.82514       88.37993
    σ_inter_RespPK  56.068542 122.825140      792.72088      609.27763
    σ_slope_RespPK 245.915762  88.379926      609.27763     1578.56182

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 190655846414.95 
    D-criterion: 75.8650394322679 
    Conditional number of the fixed effects: 76.6486671491829 
    Conditional number of the random effects: 7.78335282832985 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.56116249  5.122325
    μ_Cl                  5.0000000 0.29493763  5.898753
    ω²_V                  0.2600000 0.04668595 17.956133
    ω²_Cl                 0.3400000 0.06141230 18.062441
    σ_inter_RespPK        0.5000000 0.04358091  8.716183
    σ_slope_RespPK        0.3872983 0.03120088  8.056032

### Simplex Algorithm (Nelder-Mead)

``` r
optimizationSimplex = Optimization(
  name                = "Simplex",
  modelFromLibrary    = modelFromLibrary,
  modelParameters     = modelParameters,
  modelError          = modelError,
  optimizer           = "SimplexAlgorithm",
  optimizerParameters = list(
    pctInitialSimplexBuilding = 10,
    maxIteration              = 1000,
    tolerance                 = 1e-10,
    showProcess               = FALSE
  ),
  designs  = list(design2),
  fimType  = "population",
  outputs  = list("RespPK")
)
optimizationSimplex = run(optimizationSimplex)
```

``` r
show(optimizationSimplex)
```

    ===================================== 
      Initial design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose   Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 48, 72, 120)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl      ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1354839 -0.3248313   0.00000   0.00000        0.00000        0.00000
    μ_Cl           -0.3248313 12.1107623   0.00000   0.00000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 382.41404  21.98237       44.63647      264.88128
    ω²_Cl           0.0000000  0.0000000  21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  0.0000000  0.0000000  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK  0.0000000  0.0000000 264.88128  79.50987      653.06837      634.97897

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1354839 -0.3248313
    μ_Cl -0.3248313 12.1107623

    *************************************** 
     Variance components 
    *************************************** 

                        ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           382.41404  21.98237       44.63647      264.88128
    ω²_Cl           21.98237 305.56368      105.52177       79.50987
    σ_inter_RespPK  44.63647 105.52177     1392.16105      653.06837
    σ_slope_RespPK 264.88128  79.50987      653.06837      634.97897

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 41386277548.9818 
    D-criterion: 58.8133694373923 
    Conditional number of the fixed effects: 95.6713072499344 
    Conditional number of the random effects: 18.4576745614613 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.80859742  5.617195
    μ_Cl                  5.0000000 0.29706229  5.941246
    ω²_V                  0.2600000 0.07073645 27.206328
    ω²_Cl                 0.3400000 0.05824621 17.131237
    σ_inter_RespPK        0.5000000 0.04347975  8.695951
    σ_slope_RespPK        0.3872983 0.07639997 19.726386

    ===================================== 
      Optimal design 
    ===================================== 

      Arms name Number of subjects Outcome                    Dose   Sampling times
    1      arm2                150  RespPK 400, 200, 200, 200, 200 (1, 48, 72, 108)

    *************************************** 
     Population Fisher Matrix 
    *************************************** 

                          μ_V       μ_Cl      ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    μ_V             0.1348140 -0.2668512   0.00000   0.00000        0.00000        0.00000
    μ_Cl           -0.2668512 12.7511475   0.00000   0.00000        0.00000        0.00000
    ω²_V            0.0000000  0.0000000 378.64174  14.83533       51.14649      269.76601
    ω²_Cl           0.0000000  0.0000000  14.83533 338.73284       90.52798       91.56249
    σ_inter_RespPK  0.0000000  0.0000000  51.14649  90.52798     1082.56615      725.21291
    σ_slope_RespPK  0.0000000  0.0000000 269.76601  91.56249      725.21291      892.90492

    *************************************** 
     Fixed effects 
    *************************************** 

                μ_V       μ_Cl
    μ_V   0.1348140 -0.2668512
    μ_Cl -0.2668512 12.7511475

    *************************************** 
     Variance components 
    *************************************** 

                        ω²_V     ω²_Cl σ_inter_RespPK σ_slope_RespPK
    ω²_V           378.64174  14.83533       51.14649      269.76601
    ω²_Cl           14.83533 338.73284       90.52798       91.56249
    σ_inter_RespPK  51.14649  90.52798     1082.56615      725.21291
    σ_slope_RespPK 269.76601  91.56249      725.21291      892.90492

    ********************************************* 
     Determinant, condition numbers and D-criterion  
    *********************************************** 

    Determinant: 57264569164.007 
    D-criterion: 62.0841871782222 
    Conditional number of the fixed effects: 98.7579745041842 
    Conditional number of the random effects: 13.8859868390161 

    *************************************** 
     Parameters estimation 
    *************************************** 

                   parametersValues         SE       RSE
    μ_V                  50.0000000 2.78175798  5.563516
    μ_Cl                  5.0000000 0.28603036  5.720607
    ω²_V                  0.2600000 0.06457386 24.836098
    ω²_Cl                 0.3400000 0.05516612 16.225328
    σ_inter_RespPK        0.5000000 0.05010192 10.020383
    σ_slope_RespPK        0.3872983 0.06227156 16.078448
