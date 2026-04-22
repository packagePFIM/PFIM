modelEquations = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl * (1 - exp(-Cl/V * t ) )",
                                              "RespPD" = "S0 + RespPK * Alin" ),

                       afterInfusion  = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl * (1 - exp(-Cl/V * Tinf_RespPK)) * (exp(-Cl/V * (t - Tinf_RespPK ) ) )",
                                              "RespPD" = "S0 + RespPK * Alin") )

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 3.5, omega = 0.09 ) ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 2,   omega = 0.09 ) ),
  ModelParameter( name = "Alin", distribution = LogNormal( mu = 10,  omega = 0.5 ) ),
  ModelParameter( name = "S0",   distribution = LogNormal( mu = 1.0, omega = 0.1 ), fixedMu = TRUE ) )

# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
errorModelRespPD = Constant(  output = "RespPD", sigmaInter = 0.8 )
modelError = list( errorModelRespPK, errorModelRespPD )

# administration
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(2, 5),
                                       timeDose = c( 0, 10 ),
                                       dose = c( 5, 15 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 1, 2, 5, 7,8, 10,12,14, 15, 16, 20, 21, 30 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 2, 10, 12, 14, 20, 30 ) )

# samplingConstraints
samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0, 1, 2, 5, 7,8, 10,12,14, 15, 16, 20, 21, 30  ),
                                                      samplingsWindows = list( c( 0,15 ), c( 16,30 ) ),
                                                      numberOfTimesByWindows = c( 10,4 ),
                                                      minSampling = c( 1, 2 ) )

samplingConstraintsRespPD  = SamplingTimeConstraints( outcome = "RespPD",
                                                      initialSamplings = c( 0, 2, 10, 12, 14, 20, 30  ),
                                                      samplingsWindows = list( c( 0,14 ),c( 20, 30 ) ),
                                                      numberOfTimesByWindows = c( 4, 3 ),
                                                      minSampling = c( 2, 0 ) )

# =============================================================
# complete and partial sampling times constraints
# =============================================================

# arm1 = Arm( name = "BrasTest1",
#             size = 100,
#             administrations = list( administrationRespPK ),
#             samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
#             samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ) )
#
# arm2 = Arm( name = "BrasTest2",
#             size = 100,
#             administrations = list( administrationRespPK ),
#             samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
#             samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ) )

arm2 = Arm( name = "BrasTest2",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            samplingTimesConstraints = list( samplingConstraintsRespPD ) )



design1 = Design( name = "design1", arms = list( arm1, arm2 ), numberOfArms = 100 )

# optimizationPopFIM
optimizationPopFIM = Optimization( name = "",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "PSOAlgorithm",
                                   optimizerParameters = list(
                                     maxIteration = 20,
                                     populationSize = 20,
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
                                     maxIteration = 20,
                                     populationSize = 20,
                                     personalLearningCoefficient = 2.05,
                                     globalLearningCoefficient = 2.05,
                                     seed = 1234,
                                     showProcess = T  ),
                                   designs = list( design1 ),
                                   fimType = "population",
                                   outputs = list( "RespPK","RespPD" ) )

optimizationIndFIM = run( optimizationIndFIM )

# optimizationIndFIM
optimizationBayFIM = Optimization( name = "",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "PSOAlgorithm",
                                   optimizerParameters = list(
                                     maxIteration = 20,
                                     populationSize = 20,
                                     personalLearningCoefficient = 2.05,
                                     globalLearningCoefficient = 2.05,
                                     seed = 1234,
                                     showProcess = T  ),
                                   designs = list( design1 ),
                                   fimType = "population",
                                   outputs = list( "RespPK","RespPD" ) )

optimizationBayFIM = run( optimizationBayFIM )

# save results
outputPath = file.path("test_PSO_pkpkd_analytic_infusion_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","" )  )

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

