modelEquations = list(  "Deriv_C1" = "(dose_RespPK * ka * exp(-(ka * t)) - Cl * C1)/V",
                        "Deriv_C2" = "(Rin * (1 - (Imax*C1)/(C1 + C50)) - kout * C2)" )

# model parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.24, omega = sqrt(0.0) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 12.2, omega = sqrt(0.25) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 28.1, omega = sqrt(0.4333) ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt(0.2) ) ),
  ModelParameter( name = "kout",distribution = LogNormal( mu = 0.06, omega = sqrt(0.02) ) ),
  ModelParameter( name = "C50",distribution = LogNormal( mu = 1.2, omega = sqrt(0.01) ) ),
  ModelParameter( name = "Imax",distribution = LogNormal( mu = 1.0, omega = sqrt(0.1) ) ) )

# error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD  = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK,  errorModelRespPD )

# arm
administrationRespPK = Administration( outcome = "RespPK", timeDose = c( 0), dose = c( 100 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# constraints
administrationConstraintsRespPK = AdministrationConstraints( outcome = "RespPK", doses = list( c( 50 ), c(75), c( 100) ) )

samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ),
                                                      numberOfsamplingsOptimisable = 5,
                                                      fixedTimes = c(0.5, 1, 9, 96 ) )

samplingConstraintsRespPD = SamplingTimeConstraints( outcome = "RespPD",
                                                     initialSamplings = c( 0, 24, 36, 48, 72, 96, 120 ),
                                                     numberOfsamplingsOptimisable = 5,
                                                     fixedTimes = c( 0, 24, 72, 120 ) )

arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            administrationsConstraints = list( administrationConstraintsRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ),
            initialCondition = list( "C1" = 0, "C2" = "Rin/kout" ) )

design1 = Design( name = "design1", arms = list( arm1), numberOfArms = 100 )

# optimizationPopFIM
optimizationPopFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "MultiplicativeAlgorithm",
                                   optimizerParameters = list( lambda = 0.99,
                                                               numberOfIterations = 1000,
                                                               weightThreshold = 0.01,
                                                               delta = 1e-04, showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "population",
                                   outputs = list( "RespPK" = "C1","RespPD" = "C2" ),
                                   odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationPopFIM = run( optimizationPopFIM )

# optimizationIndFIM
optimizationIndFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "MultiplicativeAlgorithm",
                                   optimizerParameters = list( lambda = 0.99,
                                                               numberOfIterations = 1000,
                                                               weightThreshold = 0.01,
                                                               delta = 1e-04, showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "individual",
                                   outputs = list( "RespPK" = "C1","RespPD" = "C2" ),
                                   odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationIndFIM = run( optimizationIndFIM )

# optimizationBayFIM
optimizationBayFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "MultiplicativeAlgorithm",
                                   optimizerParameters = list( lambda = 0.99,
                                                               numberOfIterations = 1000,
                                                               weightThreshold = 0.01,
                                                               delta = 1e-04, showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "Bayesian",
                                   outputs = list( "RespPK" = "C1","RespPD" = "C2" ),
                                   odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationBayFIM = run( optimizationBayFIM )

# save results
outputPath = file.path("multiplicativeAlgorithm_PKPD_ode_dose_in_eqs_results")
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


