# Model equations
modelEquations = list( "Deriv_C1" = "-k*C1")

# model parameters
modelParameters = list(
  ModelParameter( name = "k", distribution = LogNormal( mu = 0.082, omega = sqrt(0.25) )))

# error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )

# arm
administrationRespPK = Administration( outcome = "C1", timeDose = c( 0,20,50), dose = c( 100,100,100 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "C1", samplings = c( 0.5, 1, 24, 36, 120  ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            initialCondition = list( "C1" = "dose_C1" ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 100 )

evaluationBayFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C1" ),
                                      odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# =====================================================================================================================

# arm
administrationRespPK = Administration( outcome = "C1", tau = c(10), dose = c( 100 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "C1", samplings = c( 0.5, 1, 24, 36, 120  ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            initialCondition = list( "C1" = "dose_C1" ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 100 )

evaluationBayFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C1" ),
                                      odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin2 = run( evaluationBayFIM_admin2 )

# =====================================================================================================================

# arm
administrationRespPK = Administration( outcome = "C1", timeDose = c( 0), dose = c( 100 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "C1", samplings = c( 0.5, 1, 24, 36, 120  ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            initialCondition = list( "C1" = "dose_C1" ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 100 )

evaluationBayFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C1" ),
                                      odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin3 = run( evaluationBayFIM_admin3 )

# Save results & Reports
outputPath = file.path("model_ode_pk_Bolus_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("")  )

outputFile = "BayFIM_admin1.html"
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin2.html"
outputFileRDS = "BayFIM_admin2.rds"
saveRDS(evaluationBayFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin3.html"
outputFileRDS = "BayFIM_admin3.rds"
saveRDS(evaluationBayFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin3, outputPath, outputFile, plotOptions )
