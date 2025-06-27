# Model Parameters
modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ), fixedMu = TRUE, fixedOmega = TRUE ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ), fixedMu = TRUE, fixedOmega = TRUE ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt(0.2) ) ),
  ModelParameter( name = "kout",distribution = LogNormal( mu = 0.06, omega = sqrt(0.01)), fixedMu = TRUE, fixedOmega = TRUE ) ,
  ModelParameter( name = "C50",distribution = LogNormal( mu = 1.2, omega = sqrt(0.01) ) ))

# Model Equations
modelEquations = list( "Deriv_C1" = "(dose_RespPK * ka * exp(-(ka * t)) - Cl * C1)/V",
                       "Deriv_C2" = "(Rin * (1 - (C1)/(C1 + C50)) - kout * C2)" )

# Model Error
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK,  errorModelRespPD )

# Administration
administrationRespPK = Administration( outcome = "RespPK", timeDose = c(0,20), dose = c( 20,50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 10 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 10 ) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialConditions = list( "C1" = 0, "C2" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationBayFIM_admin1 = Evaluation( name = "evaluation",
                                      modelParameters = modelParameters,
                                      modelEquations = modelEquations,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "C1", "RespPD" = "C2" ),
                                      odeSolverParameters = list( atol = 1e-6, rtol = 1e-6 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# Save results
outputPath = file.path("model_ode_pkpd_one_sampling_time_results")

# Bay FIM
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))

