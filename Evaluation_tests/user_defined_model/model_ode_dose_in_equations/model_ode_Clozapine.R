modelEquations = list(  "Deriv_C1" = "dose_RespPK1 * ka / V  * exp( -ka * t ) - Cl * C1/V",
                        "Deriv_C2" = "Cl/V*C1 - Clm/Vm * C2" )

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.24, omega = 0 ) ),
  ModelParameter( name = "V", distribution = LogNormal( mu = 750,  omega = 0.0 ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 28.1,   omega = 0.433 ) ),
  ModelParameter( name = "Vm", distribution = LogNormal( mu = 1860, omega = 0.499 ) ),
  ModelParameter( name = "Clm",  distribution = LogNormal( mu = 53.6,  omega = 0.499 ) ) )

# Error Model
errorModelRespPK1 = Proportional( output = "RespPK1", sigmaSlope = 0.0954 )
errorModelRespPK2 = Proportional( output = "RespPK2", sigmaSlope = 0.153 )
modelError = list( errorModelRespPK1, errorModelRespPK2 )

# administration
administrationC1 = Administration( outcome = "RespPK1", tau = c(24), dose = c(200) )

# sampling times
samplingTimesC1 = SamplingTimes( outcome = "RespPK1", samplings = c( 0.5, 170, 180, 192 ) )
samplingTimesC2 = SamplingTimes( outcome = "RespPK2", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationC1 ) ,
            samplingTimes    = list( samplingTimesC1, samplingTimesC2 ),
            initialCondition = list( "C1" = 0, "C2" = 0 ) )

design1 = Design( name = "design1", arms = list( arm1 ) )


evaluationPopFIM = Evaluation( name = "PKPD_ODE_repetead_doses_Clozapine_populationFIM",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               outputs = list( "RespPK1" = "C1/V", "RespPK2" = "C2/Vm" ),
                               designs = list( design1 ),
                               fimType = "population",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12  ) )
evaluationPopFIM = run( evaluationPopFIM )

evaluationIndFim = Evaluation( name = "",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               outputs = list( "RespPK1" = "C1/V", "RespPK2" = "C2/Vm" ),
                               designs = list( design1 ),
                               fimType = "individual",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12  ) )
evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = "",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               outputs = list( "RespPK1" = "C1/V", "RespPK2" = "C2/Vm" ),
                               designs = list( design1 ),
                               fimType = "Bayesian",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12  ) )
evaluationBayFim = run( evaluationBayFim )


# Save results & Reports
outputPath = file.path("model_ode_Clozapine_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","")  )

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(evaluationPopFIM, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM, outputPath, outputFile, plotOptions )

outputFile = "indFIM.html"
outputFileRDS = "indFIM.rds"
saveRDS(evaluationIndFim, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFim, outputPath, outputFile, plotOptions )

outputFile = "BayFIM.html"
outputFileRDS = "BayFIM.rds"
saveRDS(evaluationBayFim, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFim, outputPath, outputFile, plotOptions )





