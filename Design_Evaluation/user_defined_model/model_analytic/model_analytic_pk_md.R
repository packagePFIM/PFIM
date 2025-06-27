# model equations
modelEquations = list(  "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V * t) - exp(-ka * t))")

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 8, omega = 0.02 ),  fixedMu=TRUE ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 0.13, omega = 0.06 ) ),
  ModelParameter( name = "ka",   distribution = LogNormal( mu = 1.6, omega = 0.1 ) ) )

# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )

# administration
administrationRespPK = Administration( outcome = "RespPK", tau = c( 10 ), dose = c( 20 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 2, 3, 8, 12, 24, 36, 50, 72, 120 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK ) )

# design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluations
evaluationPopFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = 'population' )

evaluationPopFim = run( evaluationPopFim )

evaluationIndFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = 'individual' )

evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = 'Bayesian' )

evaluationBayFim = run( evaluationBayFim )

# Save results & Reports
outputPath = file.path("model_analytic_pk_results")
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

