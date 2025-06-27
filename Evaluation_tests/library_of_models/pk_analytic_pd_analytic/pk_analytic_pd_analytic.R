
modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV",
                        "PDModel" = "ImmediateDrugImax_S0ImaxC50")

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 8, omega = 0.02 ),  fixedMu=TRUE ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 0.13, omega = 0.06 ) ),
  ModelParameter( name = "S0",   distribution = LogNormal( mu = 100, omega = 0.1 ) ),
  ModelParameter( name = "C50",  distribution = LogNormal( mu = 0.17, omega = 0.7 ) ),
  ModelParameter( name = "ka",   distribution = LogNormal( mu = 1.6, omega = 0.1 ) ),
  ModelParameter( name = "Imax", distribution = LogNormal( mu = 0.73, omega = 0.3 ) ) )


# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 2 )
modelError = list( errorModelRespPK, errorModelRespPD )

# ==============================================================================================
# administration
administrationRespPK = Administration( outcome = "RespPK", tau = c(6), dose = c( 50 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 2, 3, 8, 12, 24, 36, 50, 72, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 4, 8, 12, 24, 36, 72, 100, 120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM_admin1 = Evaluation( name = " ",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "population" )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )


evaluationIndFIM_admin1 = Evaluation( name = " ",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "individual" )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

evaluationBayFIM_admin1 = Evaluation( name = " ",
                                      modelFromLibrary = modelFromLibrary,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      outputs = list( "RespPK", "RespPD" ),
                                      designs = list( design1 ),
                                      fimType = "Bayesian" )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# ==============================================================================================
# administration
administrationRespPK = Administration( outcome = "RespPK", timeDose = c(2,3,6), dose = c( 50,50,50 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 2, 3, 8, 12, 24, 36, 50, 72, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 4, 8, 12, 24, 36, 72, 100, 120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM_admin2 = Evaluation( name = " ",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "population" )

evaluationPopFIM_admin2 = run( evaluationPopFIM_admin2 )

evaluationIndFIM_admin2 = Evaluation( name = " ",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "individual" )

evaluationIndFIM_admin2 = run( evaluationIndFIM_admin2 )

evaluationBayFIM_admin2 = Evaluation( name = " ",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK", "RespPD" ),
                         designs = list( design1 ),
                         fimType = "Bayesian" )

evaluationBayFIM_admin2 = run( evaluationBayFIM_admin2 )

# Save results
outputPath = getwd()

# pop FIM
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationPopFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "popFIM_admin2.rds"
saveRDS(evaluationPopFIM_admin2, file = file.path(outputPath, outputFileRDS))

# ind FIM
outputFileRDS = "indFIM_admin1.rds"
saveRDS(evaluationIndFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "indFIM_admin2.rds"
saveRDS(evaluationIndFIM_admin2, file = file.path(outputPath, outputFileRDS))

# Bay FIM
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "BayFIM_admin2.rds"
saveRDS(evaluationBayFIM_admin2, file = file.path(outputPath, outputFileRDS))
