rm(list=ls(all=TRUE))
devtools::load_all(".")

# Model equations
modelEquations = list(  "Deriv_Cc" = "dose_RespPK/V*ka*exp(-ka*t) - Cl/V*Cc",
                        "Deriv_E" = "Rin*(1-Imax*(Cc**gamma)/(Cc**gamma + IC50**gamma))-kout*E" )

modelParameters = list(
  ModelParameter( name = "V", distribution = LogNormal( mu = 0.74, omega = 0.316 ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.28, omega = 0.456 ) ),
  ModelParameter( name = "ka", distribution = LogNormal( mu = 10, omega = sqrt( 0 ) ), fixedMu = TRUE ),
  ModelParameter( name = "kout", distribution = LogNormal( mu = 6.14, omega = 0.947 ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 614, omega = sqrt( 0.0 ) ), fixedMu = TRUE ),
  ModelParameter( name = "Imax", distribution = LogNormal( mu = 0.76, omega = 0.439 ) ),
  ModelParameter( name = "IC50", distribution = LogNormal( mu = 9.22, omega = 0.452 ) ),
  ModelParameter( name = "gamma", distribution = LogNormal( mu = 2.77, omega = 1.761 ) ) )

# error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0, sigmaSlope = 0.21 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 9.6 )
modelError = list( errorModelRespPK,  errorModelRespPD )

# arm
administrationRespPK = Administration( outcome = "RespPK", timeDose = c(0), dose = c( 6.24 ) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.25, 0.75, 1, 1.5, 2, 4, 6 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0.25, 0.75, 1.5, 2, 3, 6, 8, 12 ) )

# constraints
administrationConstraintsRespK = AdministrationConstraints( outcome = "RespPK", doses = list( 0.2, 0.64, 2, 6.24, 11.24, 20 ) )

samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0.25, 0.75, 1, 1.5, 2, 4, 6 ),
                                                      fixedTimes = c( 0.25, 4 ),
                                                      numberOfsamplingsOptimisable = 4 )

samplingConstraintsRespPD  = SamplingTimeConstraints( outcome = "RespPD",
                                                      initialSamplings = c( 0.25, 0.75, 1.5, 2, 3, 6, 8, 12 ),
                                                      fixedTimes = c( 2, 6 ),
                                                      numberOfsamplingsOptimisable = 4 )

armConstraint = Arm( name = "armConstraint",
                     size = 30,
                     administrations = list( administrationRespPK ),
                     samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
                     administrationsConstraints = list( administrationConstraintsRespK ),
                     samplingTimesConstraints = list( samplingConstraintsRespPK, samplingConstraintsRespPD ),
                     initialCondition = list( "Cc" = 0, "E" = "Rin/kout"  ) )

designConstraint = Design( name = "designConstraint", arms = list( armConstraint ), numberOfArms = 100 )

optimizationFWPopFIM = Optimization(  name = "PKPD_ODE_multi_doses_populationFIM",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      optimizer = "FedorovWynnAlgorithm",
                                      optimizerParameters = list( elementaryProtocols = list( c( 0.25, 0.75, 1, 4 ),
                                                                                              c( 1.5, 2, 6, 12 ) ),
                                                                  numberOfSubjects = c(30),
                                                                  proportionsOfSubjects =  c(30)/30,
                                                                  showProcess = T ),
                                      designs = list( designConstraint ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "Cc","RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

optimizationFWPopFIM = run( optimizationFWPopFIM )

# save results
outputPath = file.path("FedorovWynn_pkpd_ode_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(optimizationFWPopFIM, file = file.path(outputPath, outputFileRDS))
Report( optimizationFWPopFIM, outputPath, outputFile, plotOptions )


