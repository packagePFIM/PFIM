modelEquations = list(  "Deriv_Cc1" = "-Cl/V * Cc1",
                        "Deriv_Cc2" = "-Cl/V * Cc2",
                        "Deriv_E" = "Rin * ( 1-((Imax1*(Cc1/V) )/( (Cc1/V)+C501 )+Imax2*(Cc2/V) /( (Cc2/V)+C502 ) ) ) - kout*E" )

# model parameters
modelParameters = list(

  ModelParameter( name = "V",
                  distribution = LogNormal( mu = 8, omega = sqrt(0.02) ) ),

  ModelParameter( name = "Cl",
                  distribution = LogNormal( mu = 0.13, omega = sqrt( 0.06 ) ) ),

  ModelParameter( name = "Rin",
                  distribution = LogNormal( mu = 5.4, omega = sqrt( 0.2 ) ) ),

  ModelParameter( name = "kout",
                  distribution = LogNormal( mu = 0.06, omega = sqrt( 0.02 ) ) ),

  ModelParameter( name = "Imax1",
                  distribution = LogNormal( mu = 0.5, omega = sqrt(0.1) ) ),

  ModelParameter( name = "Imax2",
                  distribution = LogNormal( mu = 0.5, omega = sqrt(0.1) ) ),

  ModelParameter( name = "C501",
                  distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ) ,

  ModelParameter( name = "C502",
                  distribution = LogNormal( mu = 1.2, omega = sqrt( 0.01 ) ) ) )

# Error Model
errorModelRespPK1 = Combined1( output = "RespPK1", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPK2 = Combined1( output = "RespPK2", sigmaInter = 0.6, sigmaSlope = 0.07 )
errorModelRespPD = Constant( output = "RespPD", sigmaInter = 4 )
modelError = list( errorModelRespPK1, errorModelRespPK2, errorModelRespPD )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", timeDose = c(0), dose = c( 30 ) )
administrationRespPK2 = Administration( outcome = "Cc2", timeDose = c(0), dose = c( 80 ) )

# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin1 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin1 = run( evaluationPopFIM_admin1 )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", timeDose = c(0,40), dose = c( 80,30 ) )
administrationRespPK2 = Administration( outcome = "Cc2", timeDose = c(0), dose = c( 80 ) )

# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin2 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin2 = run( evaluationPopFIM_admin2 )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", tau = c(30), dose = c( 50 ) )
administrationRespPK2 = Administration( outcome = "Cc2", timeDose = c(0), dose = c( 80 ) )

# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin3 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin3 = run( evaluationPopFIM_admin3 )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", tau = c(30), dose = c( 50 ) )
administrationRespPK2 = Administration( outcome = "Cc2", timeDose = c(0,40), dose = c( 80,30 ) )

# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin4 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin4 = run( evaluationPopFIM_admin4 )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", timeDose = c(0,30), dose = c( 80,30 ) )
administrationRespPK2 = Administration( outcome = "Cc2", timeDose = c(0,40), dose = c( 80,30 ) )


# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin5 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin5 = run( evaluationPopFIM_admin5 )

# =====================================================================================================================
# Administrations
administrationRespPK1 = Administration( outcome = "Cc1", tau = c(10), dose = c( 50 ) )
administrationRespPK2 = Administration( outcome = "Cc2", tau = c(30), dose = c( 50 ) )

# sampling times
samplingTimesRespPK1 = SamplingTimes( outcome = "Cc1",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPK2 = SamplingTimes( outcome = "Cc2",
                                      samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

samplingTimesRespPD = SamplingTimes( outcome = "E",
                                     samplings = c( 0,24,36,48,72,96,120 ) )

## arms
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations = list( administrationRespPK1, administrationRespPK2 ) ,
            samplingTimes   = list( samplingTimesRespPK1, samplingTimesRespPK2, samplingTimesRespPD ),
            initialCondition = list( "Cc1" = "dose_Cc1/V",
                                     "Cc2" = "dose_Cc2/V",
                                     "E" = "Rin/kout" ) )

# Design
design1 = Design( name = "design1", arms = list( arm1 ) )

evaluationPopFIM_admin6 = Evaluation( name = "PKPD_ODE_multi_doses_compartment_Clozapine",
                                      modelEquations = modelEquations,
                                      modelParameters = modelParameters,
                                      modelError =  modelError,
                                      designs = list( design1 ),
                                      fimType = "population",
                                      outputs = list( "RespPK1" = "Cc1",  "RespPK2" = "Cc2", "RespPD" = "E" ),
                                      odeSolverParameters = list( atol = 1e-12, rtol = 1e-12 ) )

evaluationPopFIM_admin6 = run( evaluationPopFIM_admin6 )

# Save results & Reports
outputPath = file.path("model_ode_pkpkpd_Bolus_results")
plotOptions = list( unitTime = c(""), unitOutcomes = c("","","")  )

outputFile = "popFIM_admin1.html"
outputFileRDS = "popFIM_admin1.rds"
saveRDS(evaluationPopFIM_admin1, file = file.path(outputPath, outputFileRDS))

Report( evaluationPopFIM_admin1, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin2.html"
outputFileRDS = "popFIM_admin2.rds"
saveRDS(evaluationPopFIM_admin2, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin2, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin3.html"
outputFileRDS = "popFIM_admin3.rds"
saveRDS(evaluationPopFIM_admin3, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin3, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin4.html"
outputFileRDS = "popFIM_admin4.rds"
saveRDS(evaluationPopFIM_admin4, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin4, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin5.html"
outputFileRDS = "popFIM_admin5.rds"
saveRDS(evaluationPopFIM_admin5, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin5, outputPath, outputFile, plotOptions )

outputFile = "popFIM_admin6.html"
outputFileRDS = "popFIM_admin6.rds"
saveRDS(evaluationPopFIM_admin6, file = file.path(outputPath, outputFileRDS))
Report( evaluationPopFIM_admin6, outputPath, outputFile, plotOptions )










