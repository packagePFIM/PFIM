
modelEquations = list( duringInfusion = list( "Deriv_C1" = "dose_RespPK1/(Tinf_RespPK1*V1) - (CL1/V1)*C1",
                                              "Deriv_E" = "Rin*( 1 - Imax1*C1/(C1+C501) )- kout*E" ),

                       afterInfusion  = list( "Deriv_C1" = "- (CL1/V1)*C1" ,
                                              "Deriv_E" =  "Rin*( 1 - Imax1*C1/(C1+C501) ) - kout*E" ) )

# model parameters
modelParameters = list(
  ModelParameter( name = "C501",
                  distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ),
  ModelParameter( name = "V1",
                  distribution = LogNormal( mu = 8.0, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "CL1",
                  distribution = LogNormal( mu = 0.13, omega = sqrt( 0.06 ) ) ),
  ModelParameter( name = "Rin",
                  distribution = LogNormal( mu = 5.40, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "kout",
                  distribution = LogNormal( mu = 0.06, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "Imax1",
                  distribution = LogNormal( mu = 0.8, omega = sqrt( 0 ) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK1", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD  = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1, errorModelRespPD )

# ==================================================================================
# Administration
administrationRespPK1 = Administration( outcome = "RespPK1",
                                        Tinf = c(2,2),
                                        timeDose = c( 0,15 ),
                                        dose = c( 10,20 ) )
# Sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "RespPK1",
                                      samplings = c(0.5,1,2,6,9,12,24,36,48,72,96,120) )

samplingTimesRespPD = SamplingTimes( outcome = "RespPD",
                                     samplings = c(0,24,36,48,72,96,120) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK1 ) ,
            samplingTimes = list( samplingTimesRespPK1, samplingTimesRespPD ),
            initialCondition = list( "C1" = 0, "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationIndFim_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK1"="C1", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationIndFim_admin1 = run( evaluationIndFim_admin1 )

# ==================================================================================
# Administration

administrationRespPK1 = Administration( outcome = "RespPK1",
                                        Tinf = c(2),
                                        timeDose = c( 0 ),
                                        dose = c( 10 ) )


# Sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "RespPK1",
                                      samplings = c(0.5,1,2,6,9,12,24,36,48,72,96,120) )

samplingTimesRespPD = SamplingTimes( outcome = "RespPD",
                                     samplings = c(0,24,36,48,72,96,120) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK1 ) ,
            samplingTimes = list( samplingTimesRespPK1, samplingTimesRespPD ),
            initialCondition = list( "C1" = 0, "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationIndFim_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK1"="C1", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationIndFim_admin2 = run( evaluationIndFim_admin2 )


# Save results & Reports
outputPath = file.path("model_ode_infusion_pkpd_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "IndFim_admin1.html"
outputFileRDS = "IndFim_admin1.rds"
saveRDS(evaluationIndFim_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFim_admin1, outputPath, outputFile, plotOptions )

outputFile = "IndFim_admin2.html"
outputFileRDS = "IndFim_admin2.rds"
saveRDS(evaluationIndFim_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFim_admin2, outputPath, outputFile, plotOptions )
