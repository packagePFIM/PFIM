# model equations
modelEquations = list(  "Deriv_C1" = "-ka*C1",
                        "Deriv_C2" = "ka*C1 + C3*Q/V2 - C2*(Cl/V1+Q/V1)",
                        "Deriv_C3" = "C2* Q/V1-C3*Q/V2" )

modelParameters = list(
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 10,   omega = 1.0 ) ),
  ModelParameter( name = "V1", distribution = LogNormal( mu = 100,  omega = 0.0 ) ),
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,    omega = 0.433 ) ),
  ModelParameter( name = "Q",  distribution = LogNormal( mu = 3.0,  omega = 0.0 ) ),
  ModelParameter( name = "V2", distribution = LogNormal( mu = 40.0, omega = 0.499 ) ) )

# Error Model
errorModelRespPK = Proportional( output = "RespPK", sigmaSlope = 0.0954 )
errorModelRespPD = Proportional( output = "RespPD", sigmaSlope = 0.153 )
modelError = list( errorModelRespPK, errorModelRespPD )

#==============================================================================================
# administration
administrationC1 = Administration( outcome = "C1", timeDose = c(0), dose = c(200) )

# sampling times
samplingTimesC2 = SamplingTimes( outcome = "C2", samplings = c( 0.5, 170, 172, 175, 180, 192 ) )
samplingTimesC3 = SamplingTimes( outcome = "C3", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationC1 ) ,
            samplingTimes    = list( samplingTimesC2, samplingTimesC3 ),
            initialCondition = list( "C2" = 100, "C3" = 0 ) )

design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )

evaluationIndFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

evaluationBayFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

#==============================================================================================
# administration
administrationC1 = Administration( outcome = "C1", timeDose = c(0,20,50), dose = c(100,50,200) )

# sampling times
samplingTimesC2 = SamplingTimes( outcome = "C2", samplings = c( 0.5, 170, 172, 175, 180, 192 ) )
samplingTimesC3 = SamplingTimes( outcome = "C3", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationC1 ) ,
            samplingTimes    = list( samplingTimesC2, samplingTimesC3 ),
            initialCondition = list( "C2" = 100, "C3" = 0 ) )

design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationPopFIM_admin2 = run( evaluationPopFIM_admin2 )

evaluationIndFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationIndFIM_admin2 = run( evaluationIndFIM_admin2 )

evaluationBayFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationBayFIM_admin2 = run( evaluationBayFIM_admin2 )

#==============================================================================================
# administration
administrationC1 = Administration( outcome = "C1", tau = c(24), dose = c(200) )

# sampling times
samplingTimesC2 = SamplingTimes( outcome = "C2", samplings = c( 0.5, 170, 172, 175, 180, 192 ) )
samplingTimesC3 = SamplingTimes( outcome = "C3", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationC1 ) ,
            samplingTimes    = list( samplingTimesC2, samplingTimesC3 ),
            initialCondition = list( "C2" = 100, "C3" = 0 ) )

design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationPopFIM_admin3 = run( evaluationPopFIM_admin3 )

evaluationIndFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationIndFIM_admin3 = run( evaluationIndFIM_admin3 )

evaluationBayFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C2", "RespPD" = "C3" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationBayFIM_admin3 = run( evaluationBayFIM_admin3 )

# Save results & Reports
outputPath = file.path("model_ode_Clozapine_3cmpt_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

# pop FIM
outputFile = "popFIM_admin1.html"
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationPopFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin2.html"
outputFileRDS = "popFIM_admin2.rds"
saveRDS(evaluationPopFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin3.html"
outputFileRDS = "popFIM_admin3.rds"
saveRDS(evaluationPopFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin3, outputPath, outputFile, plotOptions )

# ind FIM
outputFile = "indFIM_admin1.html"
outputFileRDS = "indFIM_admin1.rds"
saveRDS(evaluationIndFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "indFIM_admin2.html"
outputFileRDS = "indFIM_admin2.rds"
saveRDS(evaluationIndFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "indFIM_admin3.html"
outputFileRDS = "indFIM_admin3.rds"
saveRDS(evaluationIndFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM_admin3, outputPath, outputFile, plotOptions )

# Bay FIM
outputFile = "BayFIM_admin1.html"
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin2.html"
outputFileRDS = "popFIM_admin2.rds"
saveRDS(evaluationBayFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin3.html"
outputFileRDS = "BayFIM_admin3.rds"
saveRDS(evaluationBayFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin3, outputPath, outputFile, plotOptions )
