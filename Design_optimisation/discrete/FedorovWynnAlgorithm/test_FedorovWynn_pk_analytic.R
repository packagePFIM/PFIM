
rm(list=ls(all=TRUE))
devtools::load_all(".")
# Model equations
modelEquations = list( "RespPK" = "dose_RespPK / V * ka/(ka - k) * (exp(-k * t) - exp(-ka * t) )" )

# model parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 2.0, omega = sqrt(1.0) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 15, omega = sqrt(0.1) ) ),
  ModelParameter( name = "k", distribution = LogNormal( mu = 0.25, omega = sqrt(0.25) ) ) )

# error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
modelError = list( errorModelRespPK )

# arm
administrationRespPK = Administration( outcome = "RespPK", timeDose = c( 0 ), dose = c( 100 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.33, 1.5, 5, 12 ) )

# constraints
administrationConstraintsRespPK = AdministrationConstraints( outcome = "RespPK", doses = list( 100, 200 ) )

samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0.33, 1, 1.5, 3, 5, 8, 12 ),
                                                      fixedTimes = c( 0.33, 1.5 ),
                                                      numberOfsamplingsOptimisable = 4 )

arm1 = Arm( name = "BrasTest1",
            size = 200,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK  ),
            administrationsConstraints = list( administrationConstraintsRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ) )

arm2 = Arm( name = "BrasTest2",
            size = 200,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK  ),
            administrationsConstraints = list( administrationConstraintsRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ) )

design1 = Design( name = "design1", arms = list( arm1 ), numberOfArms = 200 )

optimizationPopFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "FedorovWynnAlgorithm",
                                   optimizerParameters = list( elementaryProtocols = list( c( 0.33, 1, 1.5, 3 ) ),
                                                               numberOfSubjects = c(200),
                                                               proportionsOfSubjects = c(1),
                                                               showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "population",
                                   outputs = list( "RespPK" ),
                                   odeSolverParameters = list( atol = 1e-6, rtol = 1e-6 ))

optimizationPopFIM = run( optimizationPopFIM )

optimizationIndFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "FedorovWynnAlgorithm",
                                   optimizerParameters = list( elementaryProtocols = list( c( 0.33, 1, 1.5, 3 ) ),
                                                               numberOfSubjects = c(200),
                                                               proportionsOfSubjects = c(1),
                                                               showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "individual",
                                   outputs = list( "RespPK" ),
                                   odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ))

optimizationIndFIM = run( optimizationIndFIM )

optimizationBayFIM = Optimization( name = "PKPD_ODE_multi_doses_populationFIM",
                                   modelEquations = modelEquations,
                                   modelParameters = modelParameters,
                                   modelError = modelError,
                                   optimizer = "FedorovWynnAlgorithm",
                                   optimizerParameters = list( elementaryProtocols = list( c( 0.33, 1, 1.5, 3 ) ),
                                                               numberOfSubjects = c(200),
                                                               proportionsOfSubjects = c(1),
                                                               showProcess = T ),
                                   designs = list( design1 ),
                                   fimType = "Bayesian",
                                   outputs = list( "RespPK" ) ,
                                   odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ))

optimizationBayFIM = run( optimizationBayFIM )

# save results
outputPath = file.path("FedorovWynn_pk_analytic_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("" )  )

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
