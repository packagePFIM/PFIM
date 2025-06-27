

modelEquations = list( duringInfusion = list( "Deriv_C1" = "dose_RespPK1/(Tinf_RespPK1*V1) - (CL1/V1)*C1",
                                         "Deriv_C2" = "dose_RespPK2/(Tinf_RespPK2*V2) - (CL2/V2)*C2",
                                         "Deriv_E" = "Rin*( 1 - Imax1*C1/(C1+C501) - Imax2*C2/(C2+C502) ) - kout*E" ),

                  afterInfusion  = list( "Deriv_C1" = "- (CL1/V1)*C1" ,
                                         "Deriv_C2" = "- (CL2/V2)*C2" ,
                                         "Deriv_E" =  "Rin*( 1 - Imax1*C1/(C1+C501) - Imax2*C2/(C2+C502) ) - kout*E" ) )

# model parameters
modelParameters = list(
  ModelParameter( name = "C501",
                  distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ),
  ModelParameter( name = "C502",
                  distribution = LogNormal( mu = 3.0, omega = sqrt( 0.05 ) ) ),
  ModelParameter( name = "V1",
                  distribution = LogNormal( mu = 8.0, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "V2",
                  distribution = LogNormal( mu = 15.0, omega = sqrt( 0.1 ) ) ),
  ModelParameter( name = "CL1",
                  distribution = LogNormal( mu = 0.13, omega = sqrt( 0.06 ) ) ),
  ModelParameter( name = "CL2",
                  distribution = LogNormal( mu = 0.60, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "Rin",
                  distribution = LogNormal( mu = 5.40, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "kout",
                  distribution = LogNormal( mu = 0.06, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "Imax1",
                  distribution = LogNormal( mu = 0.8, omega = sqrt( 0 ) ) ),
  ModelParameter( name = "Imax2",
                  distribution = LogNormal( mu = 0.2, omega = sqrt( 0 ) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK1", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPK2 = Proportional( output = "RespPK2", sigmaSlope = 0.15 )
errorModelRespPD  = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1, errorModelRespPK2, errorModelRespPD )

# Administration
administrationRespPK1 = Administration( outcome = "RespPK1",
                                        Tinf = c(2),
                                        timeDose = c( 0 ),
                                        dose = c( 100) )

administrationRespPK2 = Administration( outcome = "RespPK2",
                                        Tinf = c(4,4),
                                        timeDose = c( 0,50 ),
                                        dose = c( 150,100 ) )

# Sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "RespPK1",
                                      samplings = c(0.5,1,2,6,9,12,24,36,48,72,96,120) )

samplingTimesRespPK2 = SamplingTimes( outcome = "RespPK2",
                                      samplings = c(0.5,1,2,4,6,12,24,36,48,72,96,120) )

samplingTimesRespPD = SamplingTimes( outcome = "RespPD",
                                     samplings = c(0,24,36,48,72,96,120) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "C1" = 0, "C2" = 0, "E" = "Rin/kout" ) )


# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationBayFIM = Evaluation( name = "",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               designs = list( design1 ),
                               fimType = "Bayesian",
                               outputs = list( "RespPK1"="C1", "RespPK2"= "C2", "RespPD" = "E" ),
                               odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationBayFIM = run( evaluationBayFIM )

# Save results & Reports
outputPath = file.path( "model_ode_infusion_pkpkpd_md_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","")  )

outputFile = "BayFIM.html"
outputFileRDS = "BayFIM.rds"
saveRDS(evaluationBayFIM, file = file.path(outputPath, outputFileRDS))
Report( evaluationBayFIM, outputPath, outputFile, plotOptions )
