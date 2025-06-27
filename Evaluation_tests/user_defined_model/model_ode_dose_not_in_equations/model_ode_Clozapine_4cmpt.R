modelEquations = list(
  "Deriv_C1" = "-ka1*C1",
  "Deriv_C3" = "ka1/V3*C1 - Cl3*C3",
  "Deriv_C4" = "ka2/V4*C3 - Cl4*C4 + C1" ,
  "Deriv_C5" = "Rin *(1-(Imax3/(C3+C503))-(Imax4/(C4+C504)) )- kout*C5"    )

modelParameters = list(
  ModelParameter( name = "Cl3", distribution = LogNormal( mu = 10,   omega = 1.0 )),
  ModelParameter( name = "Cl4", distribution = LogNormal( mu = 20,   omega = 1.0 )),
  ModelParameter( name = "V3", distribution = LogNormal( mu = 50,    omega = 1.0 )),
  ModelParameter( name = "V4", distribution = LogNormal( mu = 100,   omega = 1.0 )),
  ModelParameter( name = "ka1", distribution = LogNormal( mu = 0.5,  omega = 0.433 )),
  ModelParameter( name = "ka2", distribution = LogNormal( mu = 1,    omega = 0.433 )),
  ModelParameter( name = "Imax3", distribution = LogNormal( mu = 0.8,omega = sqrt( 10 ))),
  ModelParameter( name = "Imax4", distribution = LogNormal( mu = 0.2,omega = sqrt( 10 ))),
  ModelParameter( name = "C503", distribution = LogNormal( mu = 2.2, omega = sqrt( 0.01 ))),
  ModelParameter( name = "Rin", distribution = LogNormal( mu = 1.0,  omega = sqrt( 0.2 ))),
  ModelParameter( name = "kout", distribution = LogNormal( mu = 0.06,omega = sqrt( 0.02 ))),
  ModelParameter( name = "C504", distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ))))

# Error Model
errorModelRespPK1 = Proportional( output = "RespPK1", sigmaSlope = 0.0954 )
errorModelRespPK2 = Proportional( output = "RespPK2", sigmaSlope = 0.0954 )
errorModelRespPD = Proportional( output = "RespPD", sigmaSlope = 0.153 )
modelError = list( errorModelRespPK1, errorModelRespPK2, errorModelRespPD )

# administration
administrationC1 = Administration( outcome = "C1", tau = c(24), dose = c(200) )

# sampling times
samplingTimesC3 = SamplingTimes( outcome = "C3", samplings = c( 0.5,1,2,6,9,12,24,36,48,72,96,120 ) )
samplingTimesC4 = SamplingTimes( outcome = "C4", samplings = c( 0.5,1,2,6,9,12,24,36,48,72,96,120 ) )
samplingTimesC5 = SamplingTimes( outcome = "C5", samplings = c( 0,24,36,48,72,96,120 ) )

# arms
arm1 = Arm( name = "BrasTest",
            size = 20,
            administrations  = list( administrationC1 ) ,
            samplingTimes    = list( samplingTimesC3, samplingTimesC4, samplingTimesC5 ),
            initialCondition = list( "C3" = 100, "C4" = 100, "C5" = 10 ) )

design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               designs = list( design1 ),
                               fimType = "population",
                               outputs = list( "RespPK1" = "C3",
                                               "RespPK2" = "C4",
                                               "RespPD" = "C5" ),
                               odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationPopFIM = run( evaluationPopFIM )

outputPath = file.path("model_ode_Clozapine_4cmpt_results")

# pop FIM
outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(evaluationPopFIM, file = file.path(outputPath, outputFileRDS))
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","")  )
Report( evaluationPopFIM, outputPath, outputFile, plotOptions )


