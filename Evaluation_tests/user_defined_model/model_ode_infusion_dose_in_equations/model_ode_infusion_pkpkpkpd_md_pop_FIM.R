# Model equations
modelEquations = list( duringInfusion = list( "Deriv_C1" = "dose_RespPK1/(Tinf_RespPK1*V1) - (CL1/V1)*C1",
                                              "Deriv_C2" = "dose_RespPK2/(Tinf_RespPK2*V2) - (CL2/V2)*C2",
                                              "Deriv_C3" = "dose_RespPK3/(Tinf_RespPK3*V3) - (CL3/V3)*C3",
                                              "Deriv_E" = "Rin*( 1 - Imax1*C1/(C1+C501) - Imax2*C2/(C2+C502) - Imax3*C3/(C3+C503) ) - kout*E" ),

                       afterInfusion  = list( "Deriv_C1" = "- (CL1/V1)*C1" ,
                                              "Deriv_C2" = "- (CL2/V2)*C2" ,
                                              "Deriv_C3" = "- (CL3/V3)*C3" ,
                                              "Deriv_E" = "Rin*( 1 - Imax1*C1/(C1+C501) - Imax2*C2/(C2+C502) - Imax3*C3/(C3+C503) ) - kout*E" ) )

# model parameters
modelParameters = list(
  ModelParameter( name = "C501",
                  distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ),
  ModelParameter( name = "C502",
                  distribution = LogNormal( mu = 3.0, omega = sqrt( 0.05 ) ) ),
  ModelParameter( name = "C503",
                  distribution = LogNormal( mu = 3.0, omega = sqrt( 0.05 ) ) ),
  ModelParameter( name = "V1",
                  distribution = LogNormal( mu = 8.0, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "V2",
                  distribution = LogNormal( mu = 15.0, omega = sqrt( 0.1 ) ) ),
  ModelParameter( name = "V3",
                  distribution = LogNormal( mu = 5.0, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "CL1",
                  distribution = LogNormal( mu = 0.13, omega = sqrt( 0.06 ) ) ),
  ModelParameter( name = "CL2",
                  distribution = LogNormal( mu = 0.60, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "CL3",
                  distribution = LogNormal( mu = 0.40, omega = sqrt( 0.5 ) ) ),
  ModelParameter( name = "Rin",
                  distribution = LogNormal( mu = 5.40, omega = sqrt( 0.2 ) ) ),
  ModelParameter( name = "kout",
                  distribution = LogNormal( mu = 0.06, omega = sqrt( 0.02 ) ) ),
  ModelParameter( name = "Imax1",
                  distribution = LogNormal( mu = 0.8, omega = sqrt( 0 ) ) ),
  ModelParameter( name = "Imax2",
                  distribution = LogNormal( mu = 0.2, omega = sqrt( 0 ) ) ),
  ModelParameter( name = "Imax3",
                  distribution = LogNormal( mu = 0.6, omega = sqrt( 0 ) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK1", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPK2 = Proportional( output = "RespPK2", sigmaSlope = 0.15 )
errorModelRespPK3 = Combined1( output = "RespPK3", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD  = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1, errorModelRespPK2, errorModelRespPK3, errorModelRespPD )

# Administration
administrationRespPK1 = Administration( outcome = "RespPK1",
                                        Tinf = c(2,2),
                                        timeDose = c( 0,15 ),
                                        dose = c( 10,20 ) )

administrationRespPK2 = Administration( outcome = "RespPK2",
                                        Tinf = c(4,5),
                                        timeDose = c( 0,50 ),
                                        dose = c( 30,40 ) )

administrationRespPK3 = Administration( outcome = "RespPK3",
                                        Tinf = c(4,2,5),
                                        timeDose = c( 0,20,50 ),
                                        dose = c( 5,10,20 ) )

# Sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "RespPK1",
                                      samplings = c(0.5,1,2,6,9,12,24,36,48,72,96,120) )

samplingTimesRespPK2 = SamplingTimes( outcome = "RespPK2",
                                      samplings = c(0.5,1,2,4,6,12,24,36,48,72,96,120) )

samplingTimesRespPK3 = SamplingTimes( outcome = "RespPK3",
                                      samplings = c(0.5,1,2,4,6,12,24,36,48,72,96,120) )

samplingTimesRespPD = SamplingTimes( outcome = "RespPD",
                                     samplings = c(0,24,36,48,72,96,120) )

# Arms
arm1 = Arm( name = "BrasTest1",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2, administrationRespPK3 ) ,
            samplingTimes = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPK3, samplingTimesRespPD ),
            initialCondition = list( "C1" = 0, "C2" = 0, "C3" = 0, "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationPopFIM = Evaluation( name = "..",
                               modelEquations = modelEquations,
                               modelParameters = modelParameters,
                               modelError = modelError,
                               designs = list( design1 ),
                               fimType = "population",
                               outputs = list( "RespPK1"="C1", "RespPK2"= "C2", "RespPK3"= "C3", "RespPD" = "E" ),
                               odeSolverParameters = list( atol = 1e-10, rtol = 1e-10 ) )

evaluationPopFIM = run( evaluationPopFIM )

# Save results & Reports
outputPath = file.path("model_ode_infusion_pkpkpkpd_md_results")

outputFile = "popFIM.html"
outputFileRDS = "popFIM.rds"
saveRDS(evaluationPopFIM, file = file.path(outputPath, outputFileRDS))
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","","")  )
Report( evaluationPopFIM, outputPath, outputFile, plotOptions )
