modelFromLibrary = list("PKModel" = "Linear1FirstOrderSteadyState_kaClVtau")

# model parameters
modelParameters = list(
  ModelParameter( name = "V", distribution = LogNormal( mu = 8, omega = sqrt(0.020) ) ),
  ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
  ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) ) )

# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )


# administration
administration = Administration( outcome = "RespPK",
                                 timeDose = c( 0,20 ),
                                 tau = c(5),
                                 dose = c( 100,100 ) )

# sampling times
samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120) )

# arm
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations  = list( administration ) ,
            samplingTimes    = list( samplingTimes ) )

# design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# Evaluate the Fisher Information Matrix for the PopulationFIM
evaluationPopFIM_admin1 = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
                            designs = list( design1 ),
                            fimType = "population",
                            odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )

evaluationIndFIM_admin1 = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
                            designs = list( design1 ),
                            fimType = "individual",
                            odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

evaluationBayFIM_admin1 = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
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

