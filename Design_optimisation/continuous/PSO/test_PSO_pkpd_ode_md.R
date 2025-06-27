# Model equations
modelEquations = list(  "RespPK" = "dose_RespPK / V * ka/(ka - (Cl/V)) * (exp(-(Cl/V) * t) - exp(-ka * t))",
                        "RespPD" = "S0 * ( 1 - 0.73 * RespPK / ( RespPK + S0 ) )" )

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 8, omega = 0.02 ), fixedMu=TRUE ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 0.13, omega = 0.06 ) ),
  ModelParameter( name = "S0",   distribution = LogNormal( mu = 100, omega = 0.1 ) ),
  ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.6, omega = 0.7 ) ) )

# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 8 )
modelError = list( errorModelRespPK, errorModelRespPD )

# arm
administrationRespPK = Administration( outcome = "RespPK", timeDose = c( 0,20,50,70 ), dose = c( 100,80,50,20 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 8, 20, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 2, 12, 30, 115 ) )

# samplingConstraints
samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0.5, 8, 20, 120 ),
                                                      samplingsWindows = list( c( 0,20),c(30,50), c(60, 120 )  ),
                                                      numberOfTimesByWindows = c(1,2,1),
                                                      minSampling = c(0,2,0) )

samplingConstraintsRespPD  = SamplingTimeConstraints( outcome = "RespPD",
                                                      initialSamplings = c( 2, 12, 30, 115 ),
                                                      samplingsWindows = list( c( 0,40),c(60, 115 )  ),
                                                      numberOfTimesByWindows = c(3,1),
                                                      minSampling = c(2,0) )

# with all sampling times constraints

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ) )

arm2 = Arm( name = "BrasTest2",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ) )

# with partial sampling times constraints

# arm1 = Arm( name = "BrasTest1",
#             size = 100,
#             administrations = list( administrationRespPK ),
#             samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
#             samplingTimesConstraints = list( samplingConstraintsRespPK ) )
#
# arm2 = Arm( name = "BrasTest2",
#             size = 100,
#             administrations = list( administrationRespPK ),
#             samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
#             samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 100 )

# optimizationPopFIM
optimizationPopFIM = Optimization( name = "",

                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,

                                   optimizer = "PSOAlgorithm",

                                   optimizerParameters = list(
                                     maxIteration = 10,
                                     populationSize = 50,
                                     personalLearningCoefficient = 2.05,
                                     globalLearningCoefficient = 2.05,
                                     seed = 1234,
                                     showProcess = T  ),

                                   designs = list( design1 ),

                                   fimType = "population",

                                   outputs = list( "RespPK","RespPD" ) )

optimizationPopFIM = run( optimizationPopFIM )

# optimizationIndFIM
optimizationIndFIM = Optimization( name = "",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "PSOAlgorithm",
                                   optimizerParameters = list(
                                     maxIteration = 10,
                                     populationSize = 50,
                                     personalLearningCoefficient = 2.05,
                                     globalLearningCoefficient = 2.05,
                                     seed = 1234,
                                     showProcess = T  ),

                                   designs = list( design1 ),

                                   fimType = "individual",

                                   outputs = list( "RespPK","RespPD" ) )

optimizationIndFIM = run( optimizationIndFIM )

# optimizationBayFIM
optimizationBayFIM = Optimization( name = "",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "PSOAlgorithm",
                                   optimizerParameters = list(
                                     maxIteration = 10,
                                     populationSize = 50,
                                     personalLearningCoefficient = 2.05,
                                     globalLearningCoefficient = 2.05,
                                     seed = 1234,
                                     showProcess = T  ),

                                   designs = list( design1 ),

                                   fimType = "Bayesian",

                                   outputs = list( "RespPK","RespPD" ) )

optimizationBayFIM = run( optimizationBayFIM )

# save results
outputPath = file.path("test_PSO_pkpd_ode_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(optimizationPopFIM, file = file.path(outputPath, outputFileRDS))

Report( optimizationPopFIM, outputPath, outputFile, plotOptions )

outputFile = "indFIM.html"
outputFileRDS = "indFIM.rds"
saveRDS(optimizationIndFIM, file = file.path(outputPath, outputFileRDS))
Report( optimizationIndFIM, outputPath, outputFile, plotOptions )

outputFile = "BayFIM.html"
outputFileRDS = "BayFIM.rds"
saveRDS(optimizationBayFIM, file = file.path(outputPath, outputFileRDS))
Report( optimizationBayFIM, outputPath, outputFile, plotOptions )
