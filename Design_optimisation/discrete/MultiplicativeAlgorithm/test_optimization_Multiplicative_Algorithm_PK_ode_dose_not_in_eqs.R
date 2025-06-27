# Model equations
modelEquations = list( "Deriv_C1" = "-k*C1")

# model parameters
modelParameters = list(
  ModelParameter( name = "k", distribution = LogNormal( mu = 0.082, omega = sqrt(0.25) ) ) )

# error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )

# arm
administrationRespPK = Administration( outcome = "C1", timeDose = c( 0), dose = c( 50 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "C1", samplings = c( 0.5, 1, 24, 36, 120  ) )

# constraints
administrationConstraintsRespPK = AdministrationConstraints( outcome = "C1", doses = list( 50,100,150 ) )

samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "C1",
                                                      initialSamplings = c( 0.5, 1, 2, 6, 96 ,9, 12, 24, 36, 48, 72, 120 ),
                                                      numberOfsamplingsOptimisable = 5,
                                                      fixedTimes = c( 0.5, 96, 72 ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            administrationsConstraints = list( administrationConstraintsRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ),
            initialCondition = list( "C1" = "dose_C1" ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 100 )

# optimizationPopFIM
optimization = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                             modelEquations = modelEquations,
                             modelParameters = modelParameters,
                             modelError = modelError,
                             optimizer = "MultiplicativeAlgorithm",
                             optimizerParameters = list( lambda = 0.99,
                                                         numberOfIterations = 1000,
                                                         weightThreshold = 0.001,
                                                         delta = 1e-04, showProcess = T ),
                             designs = list( design1 ),
                             fimType = "population",
                             outputs = list( "RespPK" = "C1" ),
                             odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationPopFIM = run( optimization )

# optimizationIndFIM
optimization = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                             modelEquations = modelEquations,
                             modelParameters = modelParameters,
                             modelError = modelError,
                             optimizer = "MultiplicativeAlgorithm",
                             optimizerParameters = list( lambda = 0.99,
                                                         numberOfIterations = 1000,
                                                         weightThreshold = 0.001,
                                                         delta = 1e-04, showProcess = T ),
                             designs = list( design1 ),
                             fimType = "individual",
                             outputs = list( "RespPK" = "C1" ),
                             odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationIndFIM = run( optimization )

# optimizationBayFIM
optimization = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                             modelEquations = modelEquations,
                             modelParameters = modelParameters,
                             modelError = modelError,
                             optimizer = "MultiplicativeAlgorithm",
                             optimizerParameters = list( lambda = 0.99,
                                                         numberOfIterations = 1000,
                                                         weightThreshold = 0.001,
                                                         delta = 1e-04, showProcess = T ),
                             designs = list( design1 ),
                             fimType = "Bayesian",
                             outputs = list( "RespPK" = "C1" ),
                             odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationBayFIM = run( optimization )

# save results
outputPath = file.path("multiplicative_Algorithm_PK_ode_dose_not_in_eqs_results")
plotOptions = list( unitTime = c("unit time"), unitOutcomes = c("","")  )

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



