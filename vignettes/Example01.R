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

## ----model-equations, echo=TRUE, comment=''---------------------------------------------------------------------------
# modelEquations = list(
#   Deriv_Cc = "dose_RespPK/V*ka*exp(-ka*t) - Cl/V*Cc",
#   Deriv_E  = "Rin*(1-Imax*(Cc**gamma)/(Cc**gamma + IC50**gamma)) - kout*E"
# )

## ----model-parameters, echo=TRUE, comment=''--------------------------------------------------------------------------
# modelParameters = list(
#   ModelParameter(name         = "V",
#                  distribution = LogNormal(mu = 0.74,  omega = 0.316)),
#   ModelParameter(name         = "Cl",
#                  distribution = LogNormal(mu = 0.28,  omega = 0.456)),
#   ModelParameter(name         = "ka",
#                  distribution = LogNormal(mu = 10,    omega = 0),
#                  fixedMu      = TRUE),
#   ModelParameter(name         = "kout",
#                  distribution = LogNormal(mu = 6.14,  omega = 0.947)),
#   ModelParameter(name         = "Rin",
#                  distribution = LogNormal(mu = 614,   omega = 0),
#                  fixedMu      = TRUE),
#   ModelParameter(name         = "Imax",
#                  distribution = LogNormal(mu = 0.76,  omega = 0.439)),
#   ModelParameter(name         = "IC50",
#                  distribution = LogNormal(mu = 9.22,  omega = 0.452)),
#   ModelParameter(name         = "gamma",
#                  distribution = LogNormal(mu = 2.77,  omega = 1.761))
# )

## ----error-models, echo=TRUE, comment=''------------------------------------------------------------------------------
# errorModelRespPK = Combined1(output = "RespPK", sigmaInter = 0,   sigmaSlope = 0.21)
# errorModelRespPD = Constant(output = "RespPD", sigmaInter = 9.6)
# modelError       = list(errorModelRespPK, errorModelRespPD)

## ----sampling-times, echo = TRUE,   comment=''------------------------------------------------------------------------
# samplingTimesRespPK = SamplingTimes(
#   outcome   = "RespPK",
#   samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4)
# )
# samplingTimesRespPD = SamplingTimes(
#   outcome   = "RespPD",
#   samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4)
# )

## ----arms, echo = TRUE,   comment=''----------------------------------------------------------------------------------
# # Helper to avoid repeating the Arm() constructor six times
# makeArm = function(armName, dose, size = 6) {
#   admin = Administration(outcome = "RespPK", timeDose = 0, dose = dose)
#   Arm(
#     name             = armName,
#     size             = size,
#     administrations  = list(admin),
#     samplingTimes    = list(samplingTimesRespPK, samplingTimesRespPD),
#     initialCondition = list(Cc = 0, E = 100)
#   )
# }
# 
# arm1 = makeArm("0.20mg Arm",  0.20)
# arm2 = makeArm("0.64mg Arm",  0.64)
# arm3 = makeArm("2.00mg Arm",  2.00)
# arm4 = makeArm("6.32mg Arm",  6.32)
# arm5 = makeArm("11.24mg Arm", 11.24)
# arm6 = makeArm("20.00mg Arm", 20.00)

## ----design1, echo = TRUE,   comment=''-------------------------------------------------------------------------------
# design1 = Design( name = "design1",
#                   arms = list( arm1, arm2, arm3, arm4, arm5, arm6 ) )

## ----evaluation-objects, echo = TRUE,   comment=''--------------------------------------------------------------------
# evaluationPop = Evaluation(
#   name                = "evaluationPop",
#   modelEquations      = modelEquations,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#   designs             = list(design1),
#   fimType             = "population",
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )
# 
# evaluationPopResults = run (evaluationPop )

## ----evaluation-run, echo=TRUE, comment=''----------------------------------------------------------------------------
# evaluationBayesian = Evaluation(
#   name                = "evaluationBayesian",
#   modelEquations      = modelEquations,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#   designs             = list(design1),
#   fimType             = "Bayesian",
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )
# 
# evaluationBayesianResults = run( evaluationBayesian )

## ----results-pop-show, echo = TRUE, eval= FALSE, comment=''-----------------------------------------------------------
# show(evaluationPopResults)

## ----results-pop-show_from_outputs, echo = FALSE,  eval=TRUE, comment=''----------------------------------------------
lines = readLines("outputs/vignette1_evaluation_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----results-pop-detail-----------------------------------------------------------------------------------------------
# cat("Fisher Information Matrix")
# print(getFisherMatrix(evaluationPopResults))
# 
# cat("Correlation Matrix")
# print(getCorrelationMatrix(evaluationPopResults))
# 
# cat("Standard Errors (SE)")
# print(getSE(evaluationPopResults))
# 
# cat("Relative Standard Errors")
# print(getRSE(evaluationPopResults))
# 
# cat("Shrinkage (%)")
# print(getShrinkage(evaluationPopResults))
# 
# cat("Determinant")
# print(getDeterminant(evaluationPopResults))
# 
# cat("D-Criterion")
# print(getDcriterion(evaluationPopResults))

## ----results-bayesian-show, echo = TRUE, eval= FALSE, comment=''------------------------------------------------------
# show(evaluationBayesianResults)

## ----results-bayesian_from_outputs, echo = FALSE,  eval=TRUE, comment=''----------------------------------------------
lines = readLines("outputs/vignette1_evaluation_BayesianFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----results-bayesian-detail------------------------------------------------------------------------------------------
# cat("Fisher Information Matrix")
# print(getFisherMatrix(evaluationBayesianResults))
# 
# cat("Correlation Matrix")
# print(getCorrelationMatrix(evaluationBayesianResults))
# 
# cat("Standard Errors (SE)")
# print(getSE(evaluationBayesianResults))
# 
# cat("Relative Standard Errorn")
# print(getRSE(evaluationBayesianResults))
# 
# cat("Shrinkage (%)")
# print(getShrinkage(evaluationBayesianResults))
# 
# cat("Determinant")
# print(getDeterminant(evaluationBayesianResults))
# 
# cat("D-Criterion")
# print(getDcriterion(evaluationBayesianResults))

## ----plot-eval-pk, echo = TRUE, eval=FALSE, comment=''----------------------------------------------------------------
# evalPlots = plotEvaluation(evaluationPopResults, plotOptions)
# print(evalPlots[["design1"]][["20.00mg Arm"]][["RespPK"]])

## ----plot-eval-pk_from_figures, echo=FALSE, eval=TRUE, out.width="50%", fig.align="center", fig.cap="PK response profile -- 20.00 mg arm (population FIM)"----
knitr::include_graphics("figures/vignette1_evaluation_populationFim_design1_arm20mg_RespPK.png")

## ----plot-eval-pd, echo = TRUE, eval=FALSE,  comment=''---------------------------------------------------------------
# print(evalPlots[["design1"]][["20.00mg Arm"]][["RespPD"]])

## ----plot-eval-pd_from_figures, echo = FALSE,  eval=TRUE, out.width="50%",comment='', fig.align = "center", fig.cap="PD response profile -- 20.00 mg arm (population FIM)"----
knitr::include_graphics("figures/vignette1_evaluation_populationFim_design1_arm20mg_RespPD.png")

## ----plot-si-cl, echo = TRUE, eval= FALSE,  comment=''----------------------------------------------------------------
# siPlots = plotSensitivityIndices(evaluationPopResults, plotOptions)
# print(siPlots[["design1"]][["20.00mg Arm"]][["RespPK"]][["Cl"]])

## ----plot-si-cl_from_figures, echo = FALSE,  eval=TRUE, out.width="50%", comment='', fig.align = "center", fig.cap="Sensitivity index for Cl -- RespPK, 20.00 mg arm"----
knitr::include_graphics("figures/vignette1_evaluation_populationFim_design1_SI_RespPK_Cl.png")

## ----plot-se, echo = TRUE, eval= FALSE,   comment=''------------------------------------------------------------------
# print(plotSE(evaluationPopResults))

## ----plot-se_figures, out.width="33%", echo = FALSE, eval= TRUE,  comment='', fig.align = "center",fig.cap="Standard Errors (SE)"----
knitr::include_graphics("figures/vignette1_evaluation_populationFim_design1_SE.png")

## ----plot-rse, fig.width=5, fig.width=15, echo = TRUE, eval= FALSE,  comment=''---------------------------------------
# print(plotRSE(evaluationPopResults))

## ----plot-rse_figures, out.width="33%", echo = FALSE, eval= TRUE,  comment='', fig.align = "center",fig.cap="Relative Standard Errors (RSE %)"----
knitr::include_graphics("figures/vignette1_evaluation_populationFim_design1_RSE.png")

## ----report-pop, eval=FALSE, echo=TRUE, comment=''--------------------------------------------------------------------
# #Define your path to save your report: pathsReports ="C:/..."
# Report(evaluationPopResults, pathsReports, "vignette1_evaluation_popFIM.html", plotOptions)

## ----optim-setup, echo = TRUE,  eval = FALSE, comment=''--------------------------------------------------------------
# #  Initial administration
# # Starting dose; optimizer will reassign from the discrete set in Section 2.6.
# adminRespPK = Administration(outcome = "RespPK", timeDose = 0, dose = 6.32)
# 
# # Candidate sampling grids
# sampTimesOptPK = SamplingTimes( outcome = "RespPK", samplings = c(0.25, 0.75, 1, 1.5, 2, 4, 6) )
# sampTimesOptPD = SamplingTimes( outcome   = "RespPD", samplings = c(0.25, 0.75, 1.5, 2, 3, 6, 8, 12) )
# 
# # Sampling constraints -- RespPK
# # Fixed:       0.25 h (absorption/Cmax) and 4 h (late elimination).
# # Optimisable: 4 times chosen from {0.75, 1, 1.5, 2, 6}.
# sampConstraintsPK = SamplingTimeConstraints(
#   outcome                      = "RespPK",
#   initialSamplings             = c(0.25, 0.75, 1, 1.5, 2, 4, 6),
#   fixedTimes                   = c(0.25, 4),
#   numberOfsamplingsOptimisable = 4
# )
# 
# # Sampling constraints -- RespPD
# # Fixed:       2 h (near peak effect / IC50) and 6 h (mid-recovery / kout).
# # Optimisable: 4 times chosen from {0.25, 0.75, 1.5, 3, 8, 12}.
# sampConstraintsPD = SamplingTimeConstraints(
#   outcome                      = "RespPD",
#   initialSamplings             = c(0.25, 0.75, 1.5, 2, 3, 6, 8, 12),
#   fixedTimes                   = c(2, 6),
#   numberOfsamplingsOptimisable = 4
# )
# 
# # 2.5 Initial elementary protocols (Fedorov-Wynn only)
# initialElementaryProtocols = list(
#   c(0.25, 0.75, 1, 4),  # PK-focused: absorption + elimination
#   c(1.5,  2, 6, 12)     # PD-focused: near-peak + late recovery
# )
# 
# # Dose constraints -- discrete set matching the original study
# adminConstraintsPK = AdministrationConstraints(
#   outcome = "RespPK",
#   doses   = list(0.2, 0.64, 2, 6.32, 11.24, 20)
# )
# 
# # Constrained arm and design
# # E(0) = "Rin/kout" as a formula string: PFIM evaluates this at typical values,
# # giving E0 = 614/6.14 = 100. This is preferable to hardcoding the numeric
# # value because it stays consistent if parameter estimates are updated.
# armConstraint = Arm(
#   name                       = "armConstraint",
#   size                       = 30,
#   administrations            = list(adminRespPK),
#   samplingTimes              = list(sampTimesOptPK, sampTimesOptPD),
#   administrationsConstraints = list(adminConstraintsPK),
#   samplingTimesConstraints   = list(sampConstraintsPK, sampConstraintsPD),
#   initialCondition           = list(Cc = 0, E = "Rin/kout")
# )
# 
# # numberOfArms: upper bound on distinct elementary protocols
# designConstraint = Design(
#   name         = "designConstraints",
#   arms         = list(armConstraint),
#   numberOfArms = 30
# )
# 
# numberOfSubjects      = 30
# proportionsOfSubjects = 1   # single group at init; optimizer redistributes

## ----fw-object, echo = TRUE,  eval=FALSE, comment=''------------------------------------------------------------------
# optimizationFW = Optimization(
#   name                = "FedorovWynn",
#   modelEquations      = modelEquations,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   optimizer           = "FedorovWynnAlgorithm",
#   optimizerParameters = list(
#     elementaryProtocols   = initialElementaryProtocols,
#     numberOfSubjects      = numberOfSubjects,
#     proportionsOfSubjects = proportionsOfSubjects,
#     showProcess           = TRUE
#   ),
#   designs             = list(designConstraint),
#   fimType             = "population",
#   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
# )

## ----fw-run, echo=TRUE, eval=FALSE, comment=''------------------------------------------------------------------------
# optimizationFWResults = run(optimizationFW)

## ----fw-show, echo=TRUE, eval=FALSE, comment=''-----------------------------------------------------------------------
# show(optimizationFWResults)

## ----results-optiFW-popFIM_from_outputs, echo = FALSE,  eval=TRUE, comment=''-----------------------------------------
lines = readLines("outputs/vignette1_optimization_FedorovWynn_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----fw-detail, echo=TRUE, eval=FALSE, comment=''---------------------------------------------------------------------
# cat("Fisher Information Matrix\n");  print(getFisherMatrix(optimizationFWResults))
# cat("\nCorrelation Matrix\n");        print(getCorrelationMatrix(optimizationFWResults))
# cat("\nStandard Errors (SE)\n");      print(getSE(optimizationFWResults))
# cat("\nRelative Standard Errors\n");  print(getRSE(optimizationFWResults))
# cat("\nShrinkage (%)\n");             print(getShrinkage(optimizationFWResults))
# cat("\nDeterminant\n");               print(getDeterminant(optimizationFWResults))
# cat("\nD-Criterion\n");               print(getDcriterion(optimizationFWResults))

## ----fw-report, eval=FALSE, echo=TRUE, comment=''---------------------------------------------------------------------
# #Define your path to save your report: pathsReports ="C:/..."
# Report(optimizationFWResults, pathsReports, "vignette1_optimization_FedorovWynn_populationFIM.html", plotOptions)

## ----mult-object, echo=TRUE, eval=FALSE, comment=''-------------------------------------------------------------------
# optimizationMult = Optimization(
#   name                = "Multiplicative",
#   modelEquations      = modelEquations,
#   modelParameters     = modelParameters,
#   modelError          = modelError,
#   optimizer           = "MultiplicativeAlgorithm",
#   optimizerParameters = list(
#     lambda             = 0.99,
#     numberOfIterations = 1000,
#     weightThreshold    = 0.01,
#     delta              = 1e-4,
#     showProcess        = TRUE
#   ),
#   designs             = list( designConstraint),
#   fimType             = "population",
#   outputs             = list( "RespPK" = "Cc", "RespPD" = "E" ),
#   odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
# )

## ----mult-run, echo=TRUE, eval=FALSE, comment=''----------------------------------------------------------------------
# optimizationMultResults = run( optimizationMult )

## ----mult-show, echo=TRUE, eval=FALSE, comment=''---------------------------------------------------------------------
# show(optimizationMultResults)

## ----results-optiAlgoMult-popFIM_from_outputs, echo = FALSE,  eval=TRUE, comment=''-----------------------------------
lines = readLines("outputs/vignette1_optimization_MultiplicativeAlgorithm_populationFIM_show.txt")
cat(paste(lines, collapse = "\n"))

## ----mult-detail------------------------------------------------------------------------------------------------------
# cat("Fisher Information Matrix")
# print(getFisherMatrix(optimizationMultResults))
# 
# cat("Correlation Matrix")
# print(getCorrelationMatrix(optimizationMultResults))
# 
# cat("Standard Errors (SE)")
# print(getSE(optimizationMultResults))
# 
# cat("Relative Standard Errors")
# print(getRSE(optimizationMultResults))
# 
# cat("Shrinkage (%)")
# print(getShrinkage(optimizationMultResults))
# 
# cat("Determinant")
# print(getDeterminant(optimizationMultResults))
# 
# cat("D-Criterion")
# print(getDcriterion(optimizationMultResults))

## ----algoMul-show, echo=TRUE, eval=FALSE, comment=''------------------------------------------------------------------
# plotWeights(optimizationMultResults)

## ----mult-plot, out.width="50%", echo = FALSE, eval= TRUE,  comment='', fig.align = "center",fig.cap="Standard Errors (SE)"----
knitr::include_graphics("figures/vignette1_optimization_MultiplicativeAlgorithm_populationFIM_weights.png")

## ----mult-report, eval=FALSE, echo=TRUE, comment=''-------------------------------------------------------------------
# #Define your path to save your report: pathsReports ="C:/...
# Report(optimizationMultResults,pathsReports ,"vignette1_optimization_Multiplicative_populationFIM.html",plotOptions)

## ----teardown, echo=FALSE, include=FALSE------------------------------------------------------------------------------
# options(backup_options)

