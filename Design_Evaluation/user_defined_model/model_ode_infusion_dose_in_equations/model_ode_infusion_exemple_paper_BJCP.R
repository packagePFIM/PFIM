
modelEquations = list(duringInfusion = list("Deriv_X" = "dose_X/Tinf_X-ka*X",
                                       "Deriv_A" = "ka*X-ke*A",
                                       "Deriv_T" = "s-T*(e*W+d)",
                                       "Deriv_I" = "e*W*T-delta*I",
                                       "Deriv_W" = "qc*(1-((max(A/Vd, 0))^n/((max(A/Vd, 0))^n+(EC50)^n)))*I-c*W" ),

                 afterInfusion = list("Deriv_X" = "-ka*X",
                                      "Deriv_A" = "ka*X-ke*A",
                                      "Deriv_T" = "s-T*(e*W+d)",
                                      "Deriv_I" = "e*W*T-delta*I",
                                      "Deriv_W" = "qc*(1-((max(A/Vd, 0))^n/((max(A/Vd, 0))^n+(EC50)^n)))*I-c*W" ) )
modelParameters = list(
  ModelParameter( name = "ka",
                  distribution = LogNormal( mu = 0.8, omega = sqrt(0.25) )),

  ModelParameter( name = "ke",
                  distribution = LogNormal( mu = 0.15, omega = sqrt(0.25) )),

  ModelParameter( name = "Vd",
                  distribution = LogNormal( mu = 100, omega = sqrt(0.25) )),

  ModelParameter( name = "EC50",
                  distribution = LogNormal( mu = 0.12, omega = sqrt(0.25) )),

  ModelParameter( name = "n",
                  distribution = LogNormal( mu = 2, omega = sqrt(0.25) )),

  ModelParameter( name = "delta",
                  distribution = LogNormal( mu = 0.2, omega = sqrt(0.25) )),

  ModelParameter( name = "c",
                  distribution = LogNormal( mu = 7, omega = sqrt(0.25) )))

qc = 100
d = 0.001
e = 1e-7
s = 20000
# ModelParameter( name = "qc", value = 100 )
# ModelParameter( name = "d", value = 0.01 )
# ModelParameter( name = "e", value = 1e-7 )
# ModelParameter( name = "s", value = 20000 )

# Error Model ---> outputs/outcome names

#*****# changement outcome and "outputs
errorModelC = Constant( output = "C", sigmaInter = sqrt(0.04) )
errorModellog10W = Constant( output = "Wout", sigmaInter = sqrt(0.04) )
modelError = list( errorModelC, errorModellog10W )

# administration
administrationX = Administration( outcome = "X", Tinf = c(1), tau = 7, dose = c( 180 ) )

## sampling times
samplingTimesC = SamplingTimes( outcome = "A",      samplings = c( 0,0.25,0.5,1,2,3,4,7,10,14,21,28 ) )
samplingTimeslog10W = SamplingTimes( outcome = "W", samplings = c( 0,0.25,0.5,1,2,3,4,7,10,14,21,28 ) )

## arms
arm1 = Arm( name = "Arm1",
            size = 30,
            administrations = list( administrationX ) ,
            samplingTimes   = list( samplingTimesC, samplingTimeslog10W ),
            initialCondition = list( "X" = 0,
                                     "A" = 0,
                                     "T" = "(c*delta)/(qc*e)",
                                     "I" = "(s*e*qc-d*c*delta)/(qc*delta*e)",
                                     "W" = "(s*e*qc-d*c*delta)/(c*delta*e)" ) )

# Design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# evaluation
evaluationPopFIM = Evaluation( name = "",

                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,

                               outputs = list(
                                 "C" = "A/Vd",
                                 "Wout" = "log10(W)" ),

                               designs = list( design1  ),

                               fimType = "population",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM = run( evaluationPopFIM )


# evaluation
evaluationIndFIM = Evaluation( name = "",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               outputs = list( "C" = "A/Vd", "Wout" = "log10(W)" ),
                               designs = list( design1  ),
                               fimType = "individual",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationIndFIM = run( evaluationIndFIM )

# evaluation
evaluationBayFIM = Evaluation( name = "",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               outputs = list( "C" = "A/Vd", "Wout" = "log10(W)" ),
                               designs = list( design1  ),
                               fimType = "Bayesian",
                               odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationBayFIM = run( evaluationBayFIM )

# Save results & Reports
outputPath = file.path("model_ode_infusion_exemple_paper_BJCP_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","")  )

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(evaluationPopFIM, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM, outputPath, outputFile, plotOptions )

outputFile = "indFIM.html"
outputFileRDS = "indFIM.rds"
saveRDS(evaluationBayFIM, file = file.path(outputPath, outputFileRDS))
Report( evaluationIndFIM, outputPath, outputFile, plotOptions )

outputFile = "BayFIM.html"
outputFileRDS = "BayFIM.rds"
saveRDS(evaluationBayFIM, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM, outputPath, outputFile, plotOptions )

