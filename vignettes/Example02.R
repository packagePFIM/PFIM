## ----setup, include=FALSE---------------------------------------------------------------------------------------------
backup_options = options()
options(width = 120)

knitr::opts_chunk$set(
echo       = TRUE,
eval       = FALSE,          # chunks do NOT execute by default (CRAN compliance)
warning    = FALSE,
message    = FALSE,
comment    = "#>",
cache      = FALSE,
fig.width  = 8,
fig.height = 5,
fig.align  = "center",
out.width  = "90%"
)

library(PFIM)

# paths$data    : pre-computed RDS files shipped in inst/extdata/
# paths$outputs : text outputs  -> tempdir() (CRAN-compliant)
# paths$reports : HTML reports  -> tempdir()
paths = list(
data    = system.file("extdata", package = "PFIM"),
outputs = file.path(tempdir(), "pfim_out"),
reports = file.path(tempdir(), "pfim_rep")
)
dir.create(paths$outputs, showWarnings = FALSE, recursive = TRUE)
dir.create(paths$reports, showWarnings = FALSE, recursive = TRUE)

# Shared plot options
plotOptions = list(unitTime = "hour", unitOutcomes = c("mcg/mL", "DI%"))

## ----model-library, echo = TRUE, eval = FALSE, comment=''-------------------------------------------------------------
# modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_ClV")

## ----model-parameters-------------------------------------------------------------------------------------------------
# modelParameters = list(
#   ModelParameter(name = "V",  distribution = LogNormal(mu = 50, omega = sqrt(0.26))),
#   ModelParameter(name = "Cl", distribution = LogNormal(mu = 5,  omega = sqrt(0.34)))
# )

## ----error-model, echo = TRUE, eval = FALSE, comment=''---------------------------------------------------------------
# errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = sqrt( 0.15 ) )
# modelError = list( errorModelRespPK )

## ----administration, echo = TRUE, eval = FALSE, comment=''------------------------------------------------------------
# administrationRespPK = Administration(
#   outcome  = "RespPK",
#   Tinf     = rep(1, 5),           # 1-hour infusion for each of the 5 doses
#   timeDose = seq(0, 96, 24),      # dosing at t = 0, 24, 48, 72, 96 h
#   dose     = c(400, rep(200, 4))  # 400 mg loading + 4 × 200 mg maintenance
# )

## ----sampling-times-eval, echo = TRUE, eval = FALSE, comment=''-------------------------------------------------------
# samplingTimesRespPK = SamplingTimes(
#   outcome   = "RespPK",
#   samplings = c(1, 12, 24, 44, 72, 120)
# )

## ----arm-design-eval, echo = TRUE, eval = FALSE, comment=''-----------------------------------------------------------
# arm1 = Arm(
#   name            = "arm1",
#   size            = 150,
#   administrations = list(administrationRespPK),
#   samplingTimes   = list(samplingTimesRespPK)
# )
# 
# design1 = Design(name = "design1", arms = list(arm1))

## ----evaluation-run, echo = TRUE, eval = FALSE, comment=''------------------------------------------------------------
# # --- Population FIM ---
# evaluationPop = Evaluation(
#   name                = "evaluationPop",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   outputs             = list("RespPK"),
#   designs             = list(design1),
#   fimType             = "population",
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )
# evaluationPopResults = run(evaluationPop)
# 
# # --- Individual FIM ---
# evaluationInd = Evaluation(
#   name                = "evaluationInd",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   outputs             = list("RespPK"),
#   designs             = list(design1),
#   fimType             = "individual",
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )
# evaluationIndResults = run(evaluationInd)
# 
# # --- Bayesian FIM ---
# evaluationBay = Evaluation(
#   name                = "evaluationBay",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   outputs             = list("RespPK"),
#   designs             = list(design1),
#   fimType             = "Bayesian",
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )
# evaluationBayResults = run(evaluationBay)

## ----results-show-pop, echo = TRUE, eval = FALSE, comment=''----------------------------------------------------------
# show(evaluationPopResults)

## ----results-pop_from_outputs, echo = FALSE,  eval=TRUE, comment=''---------------------------------------------------
lines = readLines("outputs/vignette2_evaluation_PopFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----results-show-ind, echo = TRUE, eval = FALSE, comment=''----------------------------------------------------------
# show(evaluationIndResults)

## ----results-ind_from_outputs, echo = FALSE,  eval=TRUE, comment=''---------------------------------------------------
lines = readLines("outputs/vignette2_evaluation_IndFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----results-show-bay, echo = TRUE, eval = FALSE, comment=''----------------------------------------------------------
# show(evaluationBayResults)

## ----results-bay_from_outputs, echo = FALSE,  eval=TRUE, comment=''---------------------------------------------------
lines = readLines("outputs/vignette2_evaluation_BayFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----eval-accessors, echo = TRUE, eval = FALSE, comment=''------------------------------------------------------------
# cat("--- Fisher Information Matrix (population FIM) ---\n")
# print(getFisherMatrix(evaluationPopResults))
# 
# cat("--- Correlation Matrix (population FIM) ---\n")
# print(getCorrelationMatrix(evaluationPopResults))
# 
# cat("--- Standard Errors ---\n")
# print(getSE(evaluationPopResults))
# 
# cat("--- Relative Standard Errors ---\n")
# print(getRSE(evaluationPopResults))
# 
# cat("--- Shrinkage ---\n")
# print(getShrinkage(evaluationPopResults))
# 
# cat("--- D-Criterion ---\n")
# print(getDcriterion(evaluationPopResults))

## ----eval-plots, echo = TRUE, eval = FALSE, comment=''----------------------------------------------------------------
# plotOptions = list(unitTime = "hour", unitOutcomes = "mcg/mL")
# # Predicted concentration profile with sampling times overlaid
# plotEvalResults  = plotEvaluation(evaluationPopResults, plotOptions)
# plotOutcomesRespPK = plotEvalResults[["design1"]][["arm1"]][["RespPK"]]
# print(plotOutcomesRespPK)

## ----plot-eval-pk_from_figures, echo = FALSE,  eval=TRUE, out.width="50%",comment='', fig.align = "center", fig.cap="PK response profile -- arm1 (population FIM)"----
knitr::include_graphics("figures/vignette2_evaluation_popFim_design1_arm1_RespPK.png")

## ----eval-plots-si-V-Cl, echo = TRUE, eval = FALSE, comment=''--------------------------------------------------------
# plotSensResults = plotSensitivityIndices(evaluationPopResults, plotOptions)
# print(plotSensResults[["design1"]][["arm1"]][["RespPK"]][["V"]])
# print(plotSensResults[["design1"]][["arm1"]][["RespPK"]][["Cl"]])

## ----plot-si-V_from_figures, echo = FALSE,  eval=TRUE, out.width="50%",comment='', fig.align = "center", fig.cap="Sensitivity index for V -- RespPK, arm1"----
knitr::include_graphics("figures/vignette2_evaluation_popFim_design1_SI_RespPK_V.png")

## ----plot-si-cl_from_figures, echo = FALSE,  eval=TRUE, out.width="50%",comment='', fig.align = "center", fig.cap="Sensitivity index for Cl -- RespPK, arm1"----
knitr::include_graphics("figures/vignette2_evaluation_popFim_design1_SI_RespPK_Cl.png")

## ----plot-se, echo = TRUE, eval= FALSE,   comment=''------------------------------------------------------------------
# # Standard error and RSE bar charts
# print(plotSE(evaluationPopResults))
# print(plotRSE(evaluationPopResults))

## ----plot-se_figures, out.width="33%", echo = FALSE, eval= TRUE,  comment='', fig.align = "center",fig.cap="Standard Errors (SE)"----
knitr::include_graphics("figures/vignette2_evaluation_popFim_design1_SE.png")

## ----plot-rse_figures, out.width="33%", echo = FALSE, eval= TRUE,  comment='', fig.align = "center",fig.cap="Relative Standard Errors (RSE)"----
knitr::include_graphics("figures/vignette2_evaluation_popFim_design1_RSE.png")

## ----optim-shared-setup, echo = TRUE, eval = FALSE, comment=''--------------------------------------------------------
# samplingTimesOptim = SamplingTimes(
#   outcome   = "RespPK",
#   samplings = c(1, 48, 72, 120)   # initial guess: window boundaries
# )
# 
# samplingConstraintsRespPK = SamplingTimeConstraints(
#   outcome                = "RespPK",
#   initialSamplings       = c(1, 48, 72, 120),
#   numberOfTimesByWindows = c(2, 2),
#   samplingsWindows       = list(c(1,  48),    # Window 1: post-dose 1 to pre-dose 3
#                                 c(72, 120)),  # Window 2: near-SS to post-last-dose
#   minSampling            = 5                  # min 5 h between consecutive samples
# )
# 
# arm2 = Arm(
#   name                     = "arm2",
#   size                     = 150,
#   administrations          = list(administrationRespPK),
#   samplingTimes            = list(samplingTimesOptim),
#   samplingTimesConstraints = list(samplingConstraintsRespPK)
# )
# 
# # numberOfArms = 150: upper bound on distinct elementary protocols
# design2 = Design(name = "design2", arms = list(arm2), numberOfArms = 150)

## ----pso-run, echo = TRUE, eval = FALSE, comment=''-------------------------------------------------------------------
# optimizationPSO = Optimization(
#   name                = "PSO",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   optimizer           = "PSOAlgorithm",
#   optimizerParameters = list(
#     maxIteration                = 100,
#     populationSize              = 50,
#     personalLearningCoefficient = 2.05,
#     globalLearningCoefficient   = 2.05,
#     seed                        = 42,
#     showProcess                 = FALSE
#   ),
#   designs  = list(design2),
#   fimType  = "population",
#   outputs  = list("RespPK")
# )
# optimizationPSO = run(optimizationPSO)

## ----pso-load, echo = TRUE, eval = FALSE, comment=''------------------------------------------------------------------
# show(optimizationPSO)

## ----results-pso-popFIM_from_outputs, echo = FALSE,  eval=TRUE, comment=''--------------------------------------------
lines = readLines("outputs/vignette2_optimization_PSO_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----pgbo-run, echo = TRUE, eval = FALSE, comment=''------------------------------------------------------------------
# optimizationPGBO = Optimization(
#   name                = "PGBO",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   optimizer           = "PGBOAlgorithm",
#   optimizerParameters = list(
#     N              = 30,
#     muteEffect     = 0.65,
#     maxIteration   = 1000,
#     purgeIteration = 200,
#     seed           = 42,
#     showProcess    = FALSE
#   ),
#   designs  = list(design2),
#   fimType  = "population",
#   outputs  = list("RespPK")
# )
# optimizationPGBO = run(optimizationPGBO)

## ----pgbo-load, echo = TRUE, eval = FALSE, comment=''-----------------------------------------------------------------
# show(optimizationPGBO)

## ----results-pgbo-popFIM_from_outputs, echo = FALSE,  eval=TRUE, comment=''-------------------------------------------
lines = readLines("outputs/vignette2_optimization_PGBO_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----simplex-run, echo = TRUE, eval = FALSE, comment=''---------------------------------------------------------------
# optimizationSimplex = Optimization(
#   name                = "Simplex",
#   modelFromLibrary    = modelFromLibrary,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   optimizer           = "SimplexAlgorithm",
#   optimizerParameters = list(
#     pctInitialSimplexBuilding = 10,
#     maxIteration              = 1000,
#     tolerance                 = 1e-10,
#     showProcess               = FALSE
#   ),
#   designs  = list(design2),
#   fimType  = "population",
#   outputs  = list("RespPK")
# )
# optimizationSimplex = run(optimizationSimplex)

## ----simplex-load, echo = TRUE, eval = FALSE, comment=''--------------------------------------------------------------
# show(optimizationSimplex)

## ----results-simplex-popFIM_from_outputs, echo = FALSE,  eval=TRUE, comment=''----------------------------------------
lines = readLines("outputs/vignette2_optimization_Simplex_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----teardown, echo=FALSE, include=FALSE------------------------------------------------------------------------------
# options(backup_options)

