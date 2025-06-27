modelEquations = list( "RespPK" = "dose_RespPK / V * ka/(ka - k) * (exp(-k * t)/(1-exp(-k*tau)) - exp(-ka * t)/(1-exp(-ka*tau)))" )

modelParameters = list(
  ModelParameter( name = "V",
                  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ),
                  fixedMu=TRUE ),
  ModelParameter( name = "k",
                  distribution = LogNormal( mu = 1.04, omega = sqrt(0.05) ) ),
  ModelParameter( name = "ka",
                  distribution = LogNormal( mu = 1.6, omega = sqrt(0.1) ) ) )
# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )

# administration & multi-doses
administrationRespPK = Administration( outcome = "RespPK", dose = c(100), tau = c(48) )

## sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c(0, 2, 3, 8, 12, 24, 36, 50, 72, 120) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK ) )

arm2 = Arm( name = "BrasTest2",
            size = 32,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK ) )

# Design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# evaluation
evaluationPopFim = Evaluation( name = " ",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = "population" )
evaluationPopFim = run( evaluationPopFim )

evaluationIndFim = Evaluation( name = " ",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType =  "individual" )
evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = " ",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK" ),
                               fimType = "Bayesian" )
evaluationBayFim = run( evaluationBayFim )

# Save results & Reports
outputPath = file.path("model_analytic_pk_steady_state_md_results")
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








