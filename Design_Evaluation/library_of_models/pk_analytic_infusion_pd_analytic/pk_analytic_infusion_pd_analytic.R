# --------------------------------------
# model equations
# --------------------------------------

modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_ClV",
                        "PDModel" = "ImmediateDrugLinear_S0Alin")

# --------------------------------------
# model parameters
# --------------------------------------

modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 3.5, omega = 0.09 ) ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 2,   omega = 0.09 ) ),
  ModelParameter( name = "Alin", distribution = LogNormal( mu = 10,  omega = 0.5 ) ),
  ModelParameter( name = "S0",   distribution = LogNormal( mu = 0.1,   omega = 0.0 ) ) )

# --------------------------------------
# error model
# --------------------------------------

errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
errorModelRespPD = Constant(  output = "RespPD", sigmaInter = 0.8 )

modelError = list( errorModelRespPK, errorModelRespPD )

# --------------------------------------
# Arm
# --------------------------------------

## administration & multi-doses
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(2,5,10),
                                       timeDose = c( 0,10,20 ),
                                       dose = c( 10,20,30 ) )
## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK",
                                     samplings = c( 0, 1, 2, 5, 7, 8, 10, 12, 14, 15, 16, 20, 21, 30, 40, 50, 60, 70, 80, 100 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD",
                                     samplings = c( 0, 2, 10, 12, 14, 20, 30, 40, 50, 60, 70, 80, 100 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 40,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ) )

# --------------------------------------
# Design
# --------------------------------------

design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# --------------------------------------
# Evaluation
# --------------------------------------

evaluationPopFIM_admin1 = Evaluation( name = "",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "population",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )

evaluationIndFIM_admin1 = Evaluation( name = "",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "individual",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

evaluationBayFIM_admin1 = Evaluation( name = "",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "Bayesian",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# Save results
outputPath = getwd()

# pop FIM
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationPopFIM_admin1, file = file.path(outputPath, outputFileRDS))

# ind FIM
outputFileRDS = "indFIM_admin1.rds"
saveRDS(evaluationIndFIM_admin1, file = file.path(outputPath, outputFileRDS))

# Bay FIM
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))

