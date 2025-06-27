
modelEquations = list(  "Deriv_C1" = "dose_RespPK1 * ka / V  * exp( -ka * t ) - Cl * C1/V",
                   "Deriv_C2" = "V*C1/Vm - Clm/Vm * C2" )

# model parameters
modelParameters = list(
  ModelParameter( name = "ka",
                  distribution = LogNormal( mu = 1.24, omega =sqrt ( 0 ) ) ),
  ModelParameter( name = "V",
                  distribution = LogNormal( mu = 750, omega = sqrt( 0 ) ) ),
  ModelParameter( name = "Cl",
                  distribution = LogNormal( mu = 28.1, omega = ( 0.433 ) ) ),
  ModelParameter( name = "Vm",
                  distribution = LogNormal( mu = 1860, omega = ( 0 ) ) ),
  ModelParameter( name = "Clm",
                  distribution = LogNormal( mu = 53.6, omega = ( 0.499 ) ) ) )


# Error Model
errorModelRespPK1 = Proportional( output = "RespPK1", sigmaSlope = 0.0954  )
errorModelRespPK2 = Proportional( output = "RespPK2", sigmaSlope = 0.153  )
modelError = list( errorModelRespPK1, errorModelRespPK2 )

# =====================================================================================================
## administration
administrationCompC1 = Administration( outcome = "RespPK1", timeDose = c(0), dose = c(200) )

## sampling times
samplingTimesCompC1 = SamplingTimes( outcome = "RespPK1", samplings = c( 0.5, 170, 180, 192 ) )
samplingTimesCompC2 = SamplingTimes( outcome = "RespPK2", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationCompC1 ) ,
            samplingTimes    = list( samplingTimesCompC1, samplingTimesCompC2 ),
            initialCondition = list( "C1"= 0, "C2" = 0 ) )

# Design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

evaluationIndFIM_admin1 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      outputs =  list( "RespPK1"  = "C1", "RespPK2"  = "C2" ),
                                      designs = list( design1  ),
                                      odeSolverParameters = list( atol=1e-10, rtol=1e-10 ),
                                      fimType = "individual" )

evaluationIndFIM_admin1 = run( evaluationIndFIM_admin1 )

# =====================================================================================================
## administration
administrationCompC1 = Administration( outcome = "RespPK1", timeDose = c(0,20,100), dose = c(100,100,200) )

## sampling times
samplingTimesCompC1 = SamplingTimes( outcome = "RespPK1", samplings = c( 0.5, 170, 180, 192 ) )
samplingTimesCompC2 = SamplingTimes( outcome = "RespPK2", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationCompC1 ) ,
            samplingTimes    = list( samplingTimesCompC1, samplingTimesCompC2 ),
            initialCondition = list( "C1"= 0, "C2" = 0 ) )

# Design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

evaluationIndFIM_admin2 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      outputs =  list( "RespPK1"  = "C1", "RespPK2"  = "C2" ),
                                      designs = list( design1  ),
                                      odeSolverParameters = list( atol=1e-10, rtol=1e-10 ),
                                      fimType = "individual" )

evaluationIndFIM_admin2 = run( evaluationIndFIM_admin2 )

# =====================================================================================================
## administration
administrationCompC1 = Administration( outcome = "RespPK1", tau = c(24), dose = c(200) )

## sampling times
samplingTimesCompC1 = SamplingTimes( outcome = "RespPK1", samplings = c( 0.5, 170, 180, 192 ) )
samplingTimesCompC2 = SamplingTimes( outcome = "RespPK2", samplings = c( 0.5, 170, 180, 192 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationCompC1 ) ,
            samplingTimes    = list( samplingTimesCompC1, samplingTimesCompC2 ),
            initialCondition = list( "C1"= 0, "C2" = 0 ) )

# Design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

evaluationIndFIM_admin3 = Evaluation( name = "",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError = modelError,
                                      outputs =  list( "RespPK1"  = "C1", "RespPK2"  = "C2" ),
                                      designs = list( design1  ),
                                      odeSolverParameters = list( atol=1e-10, rtol=1e-10 ),
                                      fimType = "individual" )

evaluationIndFIM_admin3 = run( evaluationIndFIM_admin3 )

# Save results & Reports
outputPath = file.path("model_ode_pkpd_multiDoses_Metabolite_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

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
