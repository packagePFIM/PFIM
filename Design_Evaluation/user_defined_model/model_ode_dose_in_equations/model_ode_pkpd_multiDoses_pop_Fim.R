# Model Parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt(0.2) ), fixedMu = TRUE ),
  ModelParameter( name = "kout",distribution = LogNormal( mu = 0.06, omega = sqrt(0.01) ) ),
  ModelParameter( name = "C50",distribution = LogNormal( mu = 1.2, omega = sqrt(0.01) ) ) )

# Model Equations
modelEquations = list( "Deriv_C1" = "(dose_RespPK * ka * exp(-(ka * t)) - Cl * C1)/V",
                       "Deriv_C2" = "(Rin * (1 - (C1)/(C1 + C50)) - kout * C2)" )

# Model Error
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK,  errorModelRespPD )

# Administration
administrationRespPK = Administration( outcome = "RespPK", timeDose = c( 0, 50, 100 ), dose = c( 20, 30, 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )
design2 = Design( name = "design2", arms = list( arm1, arm2 ) )

evaluationPopFIM_admin1 = Evaluation( name = "evaluation",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1, design2 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C1", "RespPD" = "C2" ),
                                      odeSolverParameters = list( atol = 1e-6, rtol = 1e-6 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )

# =====================================================================================================

# Administration
administrationRespPK = Administration( outcome = "RespPK", tau = 12, dose = c( 20 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )

evaluationPopFIM_admin2 = Evaluation( name = "evaluation",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C1", "RespPD" = "C2" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationPopFIM_admin2 = run( evaluationPopFIM_admin2 )

# =====================================================================================================

# Administration
administrationRespPK = Administration( outcome = "RespPK", timeDose = c( 0 ), dose = c( 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )

evaluationPopFIM_admin3 = Evaluation( name = "evaluation",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK" = "C1", "RespPD" = "C2" ),
                                      odeSolverParameters = list( atol = 1e-6, rtol = 1e-6 ) )

evaluationPopFIM_admin3 = run( evaluationPopFIM_admin3 )

# Save results & Reports
outputPath = file.path("model_ode_pkpd_multiDoses_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

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




