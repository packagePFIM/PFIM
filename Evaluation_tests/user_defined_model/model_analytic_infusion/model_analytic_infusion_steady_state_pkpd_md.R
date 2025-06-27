
# ----------------------------------------------------------------------------
# Model analytic infusion & multi-doses
# ----------------------------------------------------------------------------

modelEquations = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl * tau *(1 - exp(-Cl/V * t ) )",
                                              "RespPD" = "S0 + RespPK * Alin" ),

                       afterInfusion  = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl  * tau *(1 - exp(-Cl/V * Tinf_RespPK)) * (exp(-Cl/V * (t - Tinf_RespPK ) ) )",
                                              "RespPD" = "S0 + RespPK * Alin") )

# model parameters
modelParameters = list(
  ModelParameter( name = "V",    distribution = LogNormal( mu = 3.5, omega = 0.09 ) ),
  ModelParameter( name = "Cl",   distribution = LogNormal( mu = 2,   omega = 0.09 ) ),
  ModelParameter( name = "Alin", distribution = LogNormal( mu = 10,  omega = 0.5 ) ),
  ModelParameter( name = "S0",   distribution = LogNormal( mu = 0.1, omega = 0.0 )) )

# error model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 0.8 )
modelError = list( errorModelRespPK, errorModelRespPD )

# administration
administrationRespPK = Administration( outcome = "RespPK",
                                       Tinf = c(5),
                                       tau = c(5),
                                       dose = c( 20 ) )

# sampling times
samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 1, 2, 5, 7,8, 10,12,14, 15, 16, 20, 21, 30 ) )
samplingTimesRespPD = SamplingTimes( outcome = "RespPD", samplings = c( 0, 2, 10, 12, 14, 20, 30 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 40,
            administrations = list( administrationRespPK ) ,
            samplingTimes   = list( samplingTimesRespPK, samplingTimesRespPD ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# evaluation
evaluationPopFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK", "RespPD" ),
                               fimType = "population" )

evaluationPopFim = run( evaluationPopFim )

evaluationIndFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK", "RespPD" ),
                               fimType = "individual" )

evaluationIndFim = run( evaluationIndFim )

evaluationBayFim = Evaluation( name = "",
                               modelParameters = modelParameters,
                               modelEquations = modelEquations,
                               modelError =  modelError,
                               designs = list( design1 ),
                               outputs = list( "RespPK", "RespPD" ),
                               fimType = "Bayesian" )

evaluationBayFim = run( evaluationBayFim )

# Save results & Reports
outputPath = file.path("model_analytic_infusion_steady_state_pkpd_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

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
