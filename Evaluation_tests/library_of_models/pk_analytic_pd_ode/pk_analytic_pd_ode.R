

modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV",
                        "PDModel" = "TurnoverRinFullImax_RinCC50koutE")

# model parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt(0.2) ) ),
  ModelParameter( name = "kout",distribution = LogNormal( mu = 0.06, omega = 0 )),
  ModelParameter( name = "C50",distribution = LogNormal( mu = 1.2, omega = sqrt(0.01) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD  = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1,  errorModelRespPD )

# =======================================================================================
# Administration
administrationRespPK = Administration( outcome = "RespPK",
                                       timeDose = c( 0, 50, 100 ),
                                       dose = c( 20, 30, 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )
design2 = Design( name = "design2", arms = list( arm1, arm2 ) )

# population Fim

evaluationPopFIM_admin1 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "population",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )


evaluationIndFIM_admin1 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "individual",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )



evaluationBayFIM_admin1 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "Bayesian",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# =======================================================================================
# Administration
administrationRespPK = Administration( outcome = "RespPK",
                                       timeDose = c( 0 ),
                                       dose = c( 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )
design2 = Design( name = "design2", arms = list( arm1, arm2 ) )

# population Fim

evaluationPopFIM_admin2 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "population",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM_admin2 = run( evaluationPopFIM_admin2 )


evaluationIndFIM_admin2 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "individual",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFIM_admin2 = run( evaluationIndFIM_admin2 )



evaluationBayFIM_admin2 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "Bayesian",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin2 = run( evaluationBayFIM_admin2 )

# =======================================================================================
# Administration
administrationRespPK = Administration( outcome = "RespPK",
                                       tau = c( 5 ),
                                       dose = c( 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 24, 36, 48, 72, 96, 120 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "Cc" = 0, "E" = 90 ) )

# Design
design1 = Design( name = "design1", arms = list( arm1, arm2 ) )
design2 = Design( name = "design2", arms = list( arm1, arm2 ) )

# population Fim

evaluationPopFIM_admin3 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "population",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM_admin3 = run( evaluationPopFIM_admin3 )


evaluationIndFIM_admin3 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "individual",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationIndFIM_admin3 = run( evaluationIndFIM_admin3 )

evaluationBayFIM_admin3 = Evaluation( name = "PKPD_ODE_multi_doses_populationFIM",
                         modelFromLibrary = modelFromLibrary,
                         modelParameters = modelParameters,
                         modelError = modelError,
                         outputs = list( "RespPK" = "Cc", "RespPD" = "E" ),
                         designs = list( design1, design2 ),
                         fimType = "Bayesian",
                         odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationBayFIM_admin3 = run( evaluationBayFIM_admin3 )

# Save results
outputPath = getwd()

# pop FIM
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationPopFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "popFIM_admin2.rds"
saveRDS(evaluationPopFIM_admin2, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "popFIM_admin3.rds"
saveRDS(evaluationPopFIM_admin3, file = file.path(outputPath, outputFileRDS))

# ind FIM
outputFileRDS = "indFIM_admin1.rds"
saveRDS(evaluationIndFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "indFIM_admin2.rds"
saveRDS(evaluationIndFIM_admin2, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "indFIM_admin3.rds"
saveRDS(evaluationIndFIM_admin3, file = file.path(outputPath, outputFileRDS))

# Bay FIM
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "BayFIM_admin2.rds"
saveRDS(evaluationBayFIM_admin2, file = file.path(outputPath, outputFileRDS))

outputFileRDS = "BayFIM_admin3.rds"
saveRDS(evaluationBayFIM_admin3, file = file.path(outputPath, outputFileRDS))
