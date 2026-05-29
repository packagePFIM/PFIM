# ======================================================================================================
# PFIM 7.1 — Population FIM evaluation tests
# ======================================================================================================
#
# Model: 1-compartment PK with first-order absorption (analytical model)
#   RespPK = dose/V * ka/(ka - Cl/V) * (exp(-Cl/V*t) - exp(-ka*t))
#
# Population parameters (log-normal distribution):
#   ka  ~ LogNormal(mu=1,   omega=0.3)   absorption rate constant (h⁻¹)
#   V   ~ LogNormal(mu=3.5, omega=0.3)   volume of distribution (L)
#   Cl  ~ LogNormal(mu=2,   omega=0.3)   clearance (L/h)
#
# Residual error: Constant(sigmaInter=0.1)  — pure additive error
#
# Common design: 1 arm, N=40 subjects, single dose 30 mg at t=0
#                5 sampling times: {0.5, 2, 4, 6, 8} h
#
# ======================================================================================================
# DESCRIPTION OF THE 6 TEST CASES
# ======================================================================================================
#
# 6 cases:
# case 1: base test case
# case 2: test case with IOV
# case 3: test case with covariate
# case 4: test case IOV + covariate
# case 5: mixed covariate test case
# case 6: occasion covariate test

# CASE 1 — No covariates, no IOV
#   Simplest model: 3 estimable parameters (mu_ka, mu_V, mu_Cl)
#   + 3 IIV variances (omega²_ka, omega²_V, omega²_Cl) + 1 sigma
#   = 7 parameters in the FIM.
#   Reference: "Poster case 1"

# CASE 2 — No covariates, with IOV (gamma = sqrt(0.0225), 2 occasions)
#   Adds inter-occasion variability (IOV) on all 3 parameters.
#   Model: log(theta_ij) = log(mu) + eta_i + kappa_ij
#     eta_i    ~ N(0, omega²)  — IIV (between subjects)
#     kappa_ij ~ N(0, gamma²)  — IOV (between occasions within the same subject)
#   Extended FIM: + 3 gamma² = 10 parameters in total.

# CASE 3 — Fixed covariate Sex on V, no IOV
#   Adds a Sex effect (binary categorical: M reference, F active)
#   on volume V via the exponential model:
#     V_i = V_typ * exp(beta_V_Sex_F * Sex_i)
#     beta_V_Sex_F = log(1.2) ≈ 0.182  --> ratio V_F/V_M = 1.20
#   Fixed covariate: does not change across occasions.
#   Proportions: 50% M, 50% F.
#   FIM: + 1 beta = 8 parameters.

# CASE 4 — Fixed covariate Sex on V, with IOV (2 occasions)
#   Combines case 3 (Sex covariate) and case 2 (IOV on all 3 parameters).
#   Sex is a fixed covariate: its value does not vary across the 2 occasions.
#   FIM: mu + beta + omega² + gamma² + sigma = 11 parameters.

# CASE 5 — Fixed covariate Sex on V + occasion covariate Treatment on Cl
#   Sex       : fixed covariate (same value across the 2 occasions)
#               beta_V_Sex_F = log(1.2) --> ratio = 1.20
#   Treatment : occasion covariate in a AB/BA cross-over design
#               Sequence AB: occasion 1 = A (reference), occasion 2 = B (active)
#               Sequence BA: occasion 1 = B (active),    occasion 2 = A (reference)
#               50% of subjects per sequence
#               beta_Cl_Treatment_B = log(1.1) ≈ 0.095 --> ratio Cl_B/Cl_A = 1.10
#   Reference: "Poster case 4"

# CASE 6 — Occasion covariate Treatment on Cl only (no fixed covariate)
#   Identical to case 5 but without Sex.
#   Allows isolating the effect of the occasion covariate on the FIM.
#   Reference: "Poster case 3"
# ======================================================================================================

library(PFIM)

# set your path
folder_PFIM    = "C:/Users/a.romain.leroux/Documents/package-PFIM-dev/script_for_dev/tests_pfim_7.1/"
folder_results = "model_dev/resultsVersionPackage"

# ======================================================================================================
# saveResult: saves the FIM, D-criterion and SE to a text file
# ======================================================================================================

saveResult = function( evaluation, file_name ) {
  evaluationDesign = pluck( prop( evaluation, "evaluationDesign" ), 1 )
  fim              = prop( evaluationDesign, "fim" )
  fisherMatrix     = prop( fim, "fisherMatrix" )
  Dcrit            = Dcriterion( fim )                        # det(FIM)^(1/p)
  SE               = sqrt( diag( solve( fisherMatrix ) ) )   # sqrt(diag(FIM⁻¹))
  output_lines = c(
    "===============================================",
    "        PFIM7 - Population Fisher Matrix",
    "===============================================",
    "",
    "---- Fisher Information Matrix ----",
    capture.output( print( fisherMatrix ) ),
    "",
    "---- D-criterion ----",
    paste( "D-criterion:", Dcrit ),
    "",
    "---- Standard Errors (SE) ----",
    capture.output( print( SE ) ),
    "",
    "===============================================",
    "               END OF FILE",
    "==============================================="
  )
  dossier = file.path( folder_PFIM, folder_results )
  if ( !dir.exists( dossier ) ) dir.create( dossier, recursive = TRUE )
  writeLines( output_lines, file.path( dossier, file_name ) )
  cat( "Saved:", file.path( dossier, file_name ), "\n" )
}

# ======================================================================================================
# saveResultCovariateTest: saves the 3 slots of a CovariateTest object
#
# covariateTest() returns a CovariateTest object with 3 slots:
#   @significance : power and NSN of the bilateral Wald test (H0: beta = 0)
#                   applied to all mu and all beta
#   @nonRelevance : power and NSN of the TOST test (H0: ratio is relevant)
#                   for beta whose exp(beta) is in [0.80, 1.25]
#   @relevance    : power and NSN of the relevance test (H0: ratio is non-relevant)
#                   for beta whose exp(beta) < 0.80 or > 1.25
# ======================================================================================================

saveResultCovariateTest = function( tostResults, file_name ) {

  format_slot = function( df, title ) {
    c(
      strrep( "=", 60 ),
      paste0( "  ", title ),
      strrep( "=", 60 ),
      "",
      if ( nrow( df ) == 0 ) {
        "  (no parameter in this slot)"
      } else {
        capture.output( print( df, row.names = FALSE ) )
      },
      ""
    )
  }

  output_lines = c(
    "===============================================",
    "   PFIM7 - Tests significance / nonRelevance / relevance ",
    "===============================================",
    "",
    format_slot( prop( tostResults, "significance" ),
                 "Significance (bilateral Wald test)" ),
    format_slot( prop( tostResults, "nonRelevance" ),
                 "Non-relevance TOST (ratio within [0.80, 1.25])" ),
    format_slot( prop( tostResults, "relevance" ),
                 "Relevance (ratio outside [0.80, 1.25])" ),
    "===============================================",
    "               END OF FILE",
    "==============================================="
  )

  dossier = file.path( folder_PFIM, folder_results )
  if ( !dir.exists( dossier ) ) dir.create( dossier, recursive = TRUE )
  path = file.path( dossier, file_name )
  writeLines( output_lines, path )
  cat( "Saved:", path, "\n" )
}

# ======================================================================================================
# ELEMENTS COMMON TO ALL CASES
# ======================================================================================================

# Analytical PK equation: 1-compartment with first-order absorption
modelEquations = list(
  "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V * t) - exp(-ka * t))"
)

# Constant additive error: Var(eps) = sigmaInter² = 0.01
modelError = list( Constant( output = "RespPK", sigmaInter = 0.1 ) )

# Single dose administration: 30 mg at t=0
administrationRespPK = Administration( outcome = "RespPK", timeDose = c(0), dose = c(30) )

# Sampling times: 5 points covering the absorption and elimination phases
samplingTimesRespPK  = SamplingTimes( outcome = "RespPK", samplings = c(0.5, 2, 4, 6, 8) )

# Single arm: 40 subjects
arm1    = Arm( name = "Bras1", size = 40,
               administrations = list( administrationRespPK ),
               samplingTimes   = list( samplingTimesRespPK ) )

# Design: 1 arm
design1 = Design( name = "design1", arms = list( arm1 ) )

# ============================================================================================
# CASE 1: No covariates, no IOV
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

# IIV only (omega = 0.3, omega² = 0.09 on all 3 parameters)
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ) )
)

evaluation = Evaluation(
  name = "cas1_noCov_noIOV", modelParameters = modelParameters,
  modelCovariates = list(), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ),
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas1_noCov_noIOV.txt" )

# ============================================================================================
# CASE 2: No covariates, with IOV (gamma = sqrt(0.0225), 2 occasions)
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) )
)

evaluation = Evaluation(
  name = "cas2_noCov_withIOV", modelParameters = modelParameters,
  modelCovariates = list(), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ), numberOfOccasions = 2,
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas2_noCov_withIOV.txt" )

# ============================================================================================
# CASE 3: Fixed covariate Sex on V, no IOV
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ) )
)

# Fixed covariate: Sex on V
sex = Covariate(
  name = "Sex", categories = c("M","F"), categoriesProportions = c(0.5, 0.5),
  effects = list( "F" = c( "V" = log(1.2) ) )
)

evaluation = Evaluation(
  name = "cas3_withCov_noIOV", modelParameters = modelParameters,
  modelCovariates = list( sex ), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ),
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas3_withCov_noIOV.txt" )

# Clinical relevance test
resultsClinicalRelevance = covariateTest( evaluation,
                                          thetaL       = log( 0.80 ),
                                          thetaU       = log( 1.25 ),
                                          target_power = 0.90,
                                          alpha        = 0.05 )
show( resultsClinicalRelevance )
saveResultCovariateTest( resultsClinicalRelevance, "cas3_withCov_noIOV_resultsClinicalRelevance.txt" )

# ============================================================================================
# CASE 4: Fixed covariate Sex on V + IOV (2 occasions)
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) )
)

# Fixed covariate: Sex on V
sex = Covariate(
  name = "Sex", categories = c("M","F"), categoriesProportions = c(0.5, 0.5),
  effects = list( "F" = c( "V" = log(1.2) ) )
)

evaluation = Evaluation(
  name = "cas4_withCov_withIOV", modelParameters = modelParameters,
  modelCovariates = list( sex ), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ), numberOfOccasions = 2,
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas4_withCov_withIOV.txt" )

# Clinical relevance test
resultsClinicalRelevance = covariateTest( evaluation,
                                          thetaL       = log( 0.80 ),
                                          thetaU       = log( 1.25 ),
                                          target_power = 0.90,
                                          alpha        = 0.05 )
show( resultsClinicalRelevance )
saveResultCovariateTest( resultsClinicalRelevance, "cas4_withCov_withIOV_resultsClinicalRelevance.txt" )

# ============================================================================================
# CASE 5: Fixed covariate Sex on V + occasion covariate Treatment on Cl
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) )
)

# Fixed covariate: Sex on V
sex = Covariate(
  name = "Sex", categories = c("M","F"), categoriesProportions = c(0.5, 0.5),
  effects = list( "F" = c( "V" = log(1.2) ) )
)

# Occasion covariate: Treatment on Cl (AB/BA cross-over, 2 occasions)
treatment = Covariate(
  name = "Treatment", categories = c("A","B"),
  sequences            = list( c("A","B"), c("B","A") ),
  sequencesProportions = c(0.5, 0.5),
  effects = list( "B" = c( "Cl" = log(1.1) ) )
)

evaluation = Evaluation(
  name = "cas5_withCov_mixed", modelParameters = modelParameters,
  modelCovariates = list( sex, treatment ), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ), numberOfOccasions = 2,
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas5_withCov_mixed.txt" )

# Clinical relevance test
resultsClinicalRelevance = covariateTest( evaluation,
                                          thetaL       = log( 0.80 ),
                                          thetaU       = log( 1.25 ),
                                          target_power = 0.90,
                                          alpha        = 0.05 )
show( resultsClinicalRelevance )
saveResultCovariateTest( resultsClinicalRelevance, "cas5_withCov_mixed_resultsClinicalRelevance.txt" )

# ============================================================================================
# CASE 6: Occasion covariate Treatment on Cl only (no fixed covariate)
# ============================================================================================

rm( list = setdiff( ls(), c("folder_PFIM","folder_results","saveResult","saveResultCovariateTest",
                            "modelEquations","modelError","administrationRespPK",
                            "samplingTimesRespPK","arm1","design1") ) )
devtools::load_all()

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 2,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) )
)

# Occasion covariate only: Treatment on Cl
treatment = Covariate(
  name = "Treatment", categories = c("A","B"),
  sequences            = list( c("A","B"), c("B","A") ),
  sequencesProportions = c(0.5, 0.5),
  effects = list( "B" = c( "Cl" = log(1.1) ) )
)

evaluation = Evaluation(
  name = "cas6_noCovFixed_withCovOccasion_withIOV", modelParameters = modelParameters,
  modelCovariates = list( treatment ), modelCovariatesEquation = "exponential",
  modelEquations = modelEquations, modelError = modelError,
  designs = list( design1 ), fimType = "population",
  outputs = list( "RespPK" = "RespPK" ), numberOfOccasions = 2,
  odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 )
)
evaluation = run( evaluation )
show( evaluation )
saveResult( evaluation, "cas6_noCovFixed_withCovOccasion_withIOV.txt" )

# Clinical relevance test
resultsClinicalRelevance = covariateTest( evaluation,
                                          thetaL       = log( 0.80 ),
                                          thetaU       = log( 1.25 ),
                                          target_power = 0.90,
                                          alpha        = 0.05 )
show( resultsClinicalRelevance )
saveResultCovariateTest( resultsClinicalRelevance, "cas6_noCovFixed_withCovOccasion_withIOV_resultsClinicalRelevance.txt" )
