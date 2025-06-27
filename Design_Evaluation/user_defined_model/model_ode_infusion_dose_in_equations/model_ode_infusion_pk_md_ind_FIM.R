modelEquations = list( duringInfusion = list( "Deriv_Cc" = "dose_RespPK / ( V*Tinf_RespPK ) - k*Cc " ),
                  afterInfusion  = list( "Deriv_Cc" = "-k*Cc" ) )

# model parameters
modelParameters = list(
  ModelParameter( name = "V",
                  distribution = LogNormal( mu = 3.5, omega = sqrt( 0.09 ) ) ),
  ModelParameter( name = "k",
                  distribution = LogNormal( mu = 0.6, omega = sqrt( 0.09 ) ) ) )

# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
modelError = list( errorModelRespPK )

# =======================================================================================
# Administration
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(2,5),
                                       timeDose = c(0,10),
                                       dose = c( 50,50 ) )
# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c(0.5,1,4,8,10,15,20) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 40,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK ),
            initialCondition = list( "Cc" = 0 ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationIndFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK" = "Cc" ),
                                      odeSolverParameters = list( atol=1e-8, rtol=1e-8 ) )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

# =======================================================================================
# Administration
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(2),
                                       tau = c(10),
                                       dose = c( 50 ) )

# Sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c(0.5,1,4,8,10,15,20) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 40,
            administrations = list( administrationRespPK ) ,
            samplingTimes = list( samplingTimesRespPK ),
            initialCondition = list( "Cc" = 0 ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationIndFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      designs = list( design1 ),
                                      fimType = "individual",
                                      outputs = list( "RespPK" = "Cc" ),
                                      odeSolverParameters = list( atol=1e-8, rtol=1e-8 ) )

evaluationIndFIM_admin2 = run( evaluationIndFIM_admin2 )

# Save results & Reports
outputPath = file.path("model_ode_infusion_pk_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "indFIM_admin1.html"
outputFileRDS = "indFIM_admin1.rds"
saveRDS(evaluationIndFIM_admin1, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "indFIM_admin2.html"
outputFileRDS = "indFIM_admin2.rds"
saveRDS(evaluationIndFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM_admin2, outputPath, outputFile, plotOptions )
