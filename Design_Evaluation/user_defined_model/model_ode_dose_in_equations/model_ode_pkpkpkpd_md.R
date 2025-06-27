
# Model Parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt(0.2) ), fixedMu = TRUE ),
  ModelParameter( name = "kout",distribution = LogNormal( mu = 0.06, omega = sqrt(0.01) ) ),
  ModelParameter( name = "C50",distribution = LogNormal( mu = 1.2, omega = sqrt(0.01) ) ) )

# Model Equations
modelEquations = list( "Deriv_C1" = "(dose_RespPK1 * ka * exp(-(ka * t)) - Cl * C1)/V",
                  "Deriv_C2" = "(dose_RespPK2 * ka * exp(-(ka * t)) - Cl * C2)/V",
                  "Deriv_C3" = "(dose_RespPK3 * ka * exp(-(ka * t)) - Cl * C3)/V",
                  "Deriv_C4" = "(Rin * (1 - (C2)/(C1 + C50)) - kout * C3)" )

# Model Error
errorModelRespPK1 = Combined1( output = "RespPK1", sigmaInter = 0.6, sigmaSlope = 0.01 )
errorModelRespPK2 = Combined1( output = "RespPK2", sigmaInter = 0.7, sigmaSlope = 0.02 )
errorModelRespPK3 = Combined1( output = "RespPK3", sigmaInter = 0.8, sigmaSlope = 0.03 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1,  errorModelRespPK2, errorModelRespPK3, errorModelRespPD )

# Administration
administrationRespPK1 = Administration( outcome = "RespPK1", timeDose = c( 0, 50, 100 ), dose = c( 20, 30, 50 ) )
administrationRespPK2 = Administration( outcome = "RespPK2", timeDose = c( 0, 20, 80 ), dose = c( 20, 50, 100 ) )
administrationRespPK3 = Administration( outcome = "RespPK3", timeDose = c( 0, 30, 120 ), dose = c( 30, 30, 50 ) )

# Sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "RespPK1", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPK2 = SamplingTimes( outcome = "RespPK2", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPK3 = SamplingTimes( outcome = "RespPK3", samplings = c( 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24,25, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2, administrationRespPK3) ,
            samplingTimes = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPK3, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = 0, "C3" = 0, "C4" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM = Evaluation( name = "evaluation",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                         modelError =  modelError,
                         designs = list( design1 ),
                         fimType = "population",
                         outputs = list( "RespPK1" = "C1", "RespPK2" = "C2",  "RespPK3" = "C3", "RespPD" = "C4" ),
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM = run( evaluationPopFIM )

evaluationIndFim = Evaluation( name = "evaluation",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                         modelError =  modelError,
                         designs = list( design1 ),
                         fimType = "individual",
                         outputs = list( "RespPK1" = "C1", "RespPK2" = "C2",  "RespPK3" = "C3", "RespPD" = "C4" ),
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = "evaluation",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                         modelError =  modelError,
                         designs = list( design1 ),
                         fimType = "Bayesian",
                         outputs = list( "RespPK1" = "C1", "RespPK2" = "C2",  "RespPK3" = "C3", "RespPD" = "C4" ),
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFim = run( evaluationBayFim )


# Save results & Reports
outputPath = file.path("model_ode_pkpkpkpd_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","","")  )

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
