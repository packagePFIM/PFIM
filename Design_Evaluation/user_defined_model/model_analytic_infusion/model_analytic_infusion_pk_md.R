# ----------------------------------------------------------------------------
# Model analytic infusion pk & multi-doses
# ----------------------------------------------------------------------------

modelEquations = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl *(1 - exp(-Cl/V * t ) )" ),
                       afterInfusion  = list( "RespPK" = "(1 - exp(-Cl/V * t ) )" ) )

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 3.5, omega = 0.09 ) ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 2,   omega = 0.09 ) ) )

# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
modelError = list( errorModelRespPK )

# administration
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(2, 5),
                                       timeDose = c( 0, 10 ),
                                       dose = c( 5, 15 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 1, 2, 5, 7,8, 10,12,14, 15, 16, 20, 21, 30 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 40,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# evaluation
evaluationPopFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = "population" )

evaluationPopFim = run( evaluationPopFim )

evaluationIndFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = "individual" )

evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = "Bayesian" )

evaluationBayFim = run( evaluationBayFim )

# Save results & Reports
outputPath = file.path("model_analytic_infusion_pk_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("")  )

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(evaluationPopFim, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFim, outputPath, outputFile, plotOptions )

outputFile = "indFIM.html"
outputFileRDS = "indFIM.rds"
saveRDS( evaluationIndFim, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFim, outputPath, outputFile, plotOptions )

outputFile = "BayFIM.html"
outputFileRDS = "BayFIM.rds"
saveRDS( evaluationBayFim, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFim, outputPath, outputFile, plotOptions )

