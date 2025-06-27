modelEquations = list(  "Deriv_Cc" = "-Cl/V * Cc",
                   "Deriv_E" = "Rin * ( 1-(Imax*(Cc/V) )/( (Cc/V)+C50 ) )-kout*E" )

# model parameters
modelParameters = list(
  ModelParameter( name = "V", distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.13, omega = sqrt( 0.06 ) ) ),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 5.4, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "kout", distribution = LogNormal( mu = 0.06, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "Imax", distribution = LogNormal( mu = 1.0, omega = sqrt(0.1) ) ),
  ModelParameter( name = "C50", distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1, errorModelRespPD )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "Cc",
                                     samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c(  0,24,36,48,72,96,120 ) )

# Administrations
administrationRespPK = Administration( outcome = "Cc", timeDose = c(0,20), dose = c( 100, 50 ) )

## arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialCondition = list( "Cc" = "dose_Cc/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationBayFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "Cc",  "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-4, rtol = 1e-4 ) )

evaluationBayFIM_admin1 = run( evaluationBayFIM_admin1 )

# =====================================================================================================================

# Administrations
administrationRespPK = Administration( outcome = "Cc", tau = c(20), dose = c( 100 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "Cc",
                                     samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c(  0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialCondition = list( "Cc" = "dose_Cc/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationBayFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "Cc",  "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-4, rtol = 1e-4 ) )

evaluationBayFIM_admin2 = run( evaluationBayFIM_admin2 )

# =====================================================================================================================

administrationRespPK = Administration( outcome = "Cc", timeDose = c(0), dose = c( 100 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "Cc",
                                     samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c(  0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ),
            initialCondition = list( "Cc" = "dose_Cc/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationBayFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "Bayesian",
                                      outputs = list( "RespPK" = "Cc",  "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-4, rtol = 1e-4 ) )

evaluationBayFIM_admin3 = run( evaluationBayFIM_admin3 )

# Save results & Reports
outputPath = file.path("model_ode_pkpd_Bolus_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "BayFIM_admin1.html"
outputFileRDS = "BayFIM_admin1.rds"
saveRDS(evaluationBayFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin2.html"
outputFileRDS = "BayFIM_admin2.rds"
saveRDS(evaluationBayFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "BayFIM_admin3.html"
outputFileRDS = "BayFIM_admin3.rds"
saveRDS(evaluationBayFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM_admin3, outputPath, outputFile, plotOptions )
