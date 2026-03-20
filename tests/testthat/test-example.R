# PK MODELS

test_that("Linear1InfusionSingleDose_kV", {

modelFromLibrary = list("PKModel" = "Linear1BolusSingleDose_kV")

# model modelParameters
modelParameters = list(
  ModelParameter( name = "k", distribution = LogNormal( mu = 0.25, omega = sqrt(0.25) ) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 15, omega = sqrt(0.1) ) ) )

# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
modelError = list( errorModelRespPK )

# administration
administration = Administration( outcome = "RespPK", timeDose = c( 0 ), dose = c( 100 ) )

# sampling times
samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.33, 1.5, 5, 12 ) )

# arm
arm1 = Arm( name = "BrasTest", size = 200, administrations  = list( administration ) , samplingTimes    = list( samplingTimes ) )

# design
design1 = Design( name = "design1", arms = list( arm1 ) )

# Evaluation
evaluationFIM = Evaluation( name = "Linear1BolusSingleDose_kV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
                            designs = list( design1 ),
                            fimType = "population",
                            odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationFIM = run( evaluationFIM )
FisherMatrix = getFisherMatrix(evaluationFIM )
detPopulationFim =det(  FisherMatrix$fisherMatrix )
valueDetPopulationFim = 1456484950098966784
tol = 1e-6
expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol)
})

############################################################################################################################

test_that("Linear1BolusSingleDose_ClV", {

modelFromLibrary = list("PKModel" = "Linear1BolusSingleDose_ClV")

# model modelParameters
modelParameters = list( ModelParameter( name = "Cl", distribution = LogNormal( mu = 3.75, omega = sqrt(0.25) ) ),
                   ModelParameter( name = "V",  distribution = LogNormal( mu = 15, omega = sqrt(0.1) ) ) )

# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
modelError = list( errorModelRespPK )

# administration
administration = Administration( outcome = "RespPK", timeDose = c( 0 ), dose = c( 100 ) )
# sampling times
samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.33, 1.5, 5, 12 ) )
# arm
arm1 = Arm( name = "BrasTest",
            size = 200,
            administrations  = list( administration ) ,
            samplingTimes    = list( samplingTimes ) )

# design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# --------------------------------------
# Evaluation

# Evaluate the Fisher Information Matrix for the PopulationFIM
evaluationFIM = Evaluation( name = "Linear1BolusSingleDose_ClV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
                            designs = list( design1 ),
                            fimType = "population",
                            odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationFIM = run( evaluationFIM )

FisherMatrix = getFisherMatrix(evaluationFIM )
detPopulationFim =det(  FisherMatrix$fisherMatrix )
valueDetPopulationFim = 7292815928272215
tol = 1e-6
expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = )
})

test_that("Linear1InfusionSingleDose_kV", {

  # --------------------------------------
  # model definition


  modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_kV")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ) ),
    ModelParameter( name = "k",  distribution = LogNormal( mu = 0.6, omega = sqrt(0.09) ) )
  )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
  modelError = list( errorModelRespPK )

  # administration
  administration = Administration( outcome = "RespPK",  Tinf = c(2), timeDose = c( 0 ), dose = c( 30 ) )
  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 4, 8 ) )
  # arm
  arm1 = Arm( name = "BrasTest",
              size = 40,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1InfusionSingleDose_kV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim

  valueDetPopulationFim = 1976729482139640576.0
  tol = 1e-6
  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})


test_that("Model PK 1cpt : Linear1InfusionSingleDose_VCl", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_ClV") #Linear1InfusionSingleDose_VCl


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 2, omega = sqrt(0.09) ) )
  )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   Tinf = c(2),
                                   timeDose = c( 0 ),
                                   dose = c( 30 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 4, 8 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 40,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1InfusionSingleDose_ClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim


  valueDetPopulationFim = 155857928552697888.0

  tol = 1e-6

  expect_equal( detPopulationFim, valueDetPopulationFim, tolerance = tol )

})


test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kakV", {

  ## --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list( "PKModel" = "Linear1FirstOrderSingleDose_kakV" )

  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 2, omega = sqrt(1) ) ),
    ModelParameter( name = "k", distribution = LogNormal( mu = 0.25, omega = sqrt(0.25) ) ),
    ModelParameter( name = "V",  distribution = LogNormal( mu = 15, omega = sqrt(0.1) ) ) )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0 ),
                                   dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.33, 1.5, 5, 12 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 200,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes ) )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kakV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim

  valueDetPopulationFim = 293039672275859603466.0

  tol = 1e-6
  expect_equal( detPopulationFim, valueDetPopulationFim, tolerance = tol )

})


test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kaClV", {

  modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV")

  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 8, omega = sqrt(0.020) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) )
  )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
  modelError = list( errorModelRespPK )

  # administration
  administration = Administration( outcome = "RespPK", timeDose = c( 0 ),  dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 32,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes ) )

  # design
  design1 = Design( name = "design1", arms = list( arm1 ) )


  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  valueDetPopulationFim = 75038812388902169470420.0

  # Evaluate the Fisher Information Matrix for the individual FIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "individual",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detIndividualFim =det(  FisherMatrix$fisherMatrix )
  valueDetIndividualFim =  1532105538

  tol = 1e-6

  expect_equal( detPopulationFim, valueDetPopulationFim, tolerance = tol )
  expect_equal( detIndividualFim, valueDetIndividualFim, tolerance = tol )


})


# --------------------------------------
# model definition

# model equations
test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kaClV (BayesianFIM instead of PopulationFIM)", {
modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV")


# model modelParameters
modelParameters = list(
  ModelParameter( name = "V", distribution = LogNormal( mu = 8, omega = sqrt(0.020) ) ),
  ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
  ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) )
)

# Error Model
errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
modelError = list( errorModelRespPK )


# administration
administration = Administration( outcome = "RespPK",
                                 timeDose = c( 0 ),
                                 dose = c( 100 ) )

# sampling times
samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120) )

# arm
arm1 = Arm( name = "BrasTest",
            size = 32,
            administrations  = list( administration ) ,
            samplingTimes    = list( samplingTimes )
)

# design
design1 = Design( name = "design1",
                  arms = list( arm1 ) )

# --------------------------------------
# Evaluation

# Evaluate the Fisher Information Matrix for the PopulationFIM
evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                            modelFromLibrary = modelFromLibrary,
                            modelParameters = modelParameters,
                            modelError = modelError,
                            outputs = list( "RespPK" ),
                            designs = list( design1 ),
                            fimType = "Bayesian",
                            odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

evaluationFIM = run( evaluationFIM )

FisherMatrix = getFisherMatrix(evaluationFIM )
detBayesianFim =det(  FisherMatrix$fisherMatrix )
valueDetBayesianFim = 7349326.937090975232422
tol = 1e-6
expect_equal(valueDetBayesianFim,detBayesianFim, tolerance = tol )
})


test_that("Model PK 1cpt : Linear1InfusionSingleDose_ClV", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear1InfusionSingleDose_ClV")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 2, omega = sqrt(0.09) ) )
  )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
  modelError = list( errorModelRespPK )


  # administration

  administration = Administration( outcome = "RespPK",
                                   Tinf=c(2),
                                   tau=c(12),
                                   dose = c( 30  ) )



  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0, 1,2,5,7,8, 10,12,14, 15, 16, 20, 21, 30 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 40,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1InfusionSingleDose_ClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  valueDetPopulationFim = 15171420395090292736
  tol = 1e-6
  expect_equal(valueDetPopulationFim,detPopulationFim, tolerance = tol )

})

test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kaClV", {


  modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 8, omega = sqrt(0.020) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.13, omega = sqrt(0.06) ) ),
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.6, omega = sqrt(0.7) ) )
  )

  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0, 80, 160 ),
                                   dose = c( 100,100,100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c(  0.5, 1, 2, 6, 12, 48, 72, 120, 165, 220 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 32,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim = det(  FisherMatrix$fisherMatrix )
  valueDetPopulationFim = 23048351728920705368024

  # Evaluate the Fisher Information Matrix for the individual FIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "individual",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detIndividualFim =det(  FisherMatrix$fisherMatrix )
  valueDetIndividualFim =  618022401.4696867465973
  tol = 1e-6
  expect_equal( detPopulationFim, valueDetPopulationFim, tolerance = tol )
  expect_equal( detIndividualFim, valueDetIndividualFim, tolerance = tol )

})

###################################################################################################################################


test_that("Model PK 2cpts : Linear2BolusSingleDose_ClQV1V2", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear2BolusSingleDose_ClQV1V2")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.4, omega = sqrt(0.2) ) ),
    ModelParameter( name = "V1", distribution = LogNormal( mu = 10, omega = sqrt(0.1) ) ),
    ModelParameter( name = "Q", distribution = LogNormal( mu = 2, omega = sqrt(0.05) ) ),
    ModelParameter( name = "V2", distribution = LogNormal( mu = 50, omega = sqrt(0.4) ) )

  )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.6, sigmaSlope = 0.07 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0 ),
                                   dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 32,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear2BolusSingleDose_ClQV1V2",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  valueDetPopulationFim =  45852890814.07175445557
  tol = 1e-6
  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})

###################################################################################################################################


test_that("Model PK 2cpts : Linear2BolusSingleDose_kk12k21V", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear2BolusSingleDose_kk12k21V")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "k", distribution = LogNormal( mu = 0.25, omega = sqrt(0.25) ) ),
    ModelParameter( name = "V", distribution = LogNormal( mu = 15.00, omega = sqrt(0.10) ) ),
    ModelParameter( name = "k12",  distribution = LogNormal( mu = 1.00, omega = sqrt(0.40) ) ),
    ModelParameter( name = "k21",  distribution = LogNormal( mu = 0.80, omega = sqrt(0.30) ) )
  )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0 ),
                                   dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK",
                                 samplings = c(0.33, 1.5, 3, 5, 8, 12 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 200,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear2BolusSingleDose_kk12k21V",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK"),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )



  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim

  valueDetPopulationFim =  1733176644421398016.0

  tol = 1e-6

  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )


})

###################################################################################################################################


test_that("Model PK 1cpt : MichaelisMenten1FirstOrderSingleDose_kaVmKmV", {

  # --------------------------------------
  # model definition

  # model equations


  modelFromLibrary = list("PKModel" = "MichaelisMenten1FirstOrderSingleDose_kaVmKmV")

  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "ka", distribution = LogNormal( mu = 1.0, omega = sqrt(0.20) ) ),
    ModelParameter( name = "V", distribution = LogNormal( mu = 15.00, omega = sqrt(0.25) ) ),
    ModelParameter( name = "Vm",  distribution = LogNormal( mu = 0.08, omega = sqrt(0.10) ) ),
    ModelParameter( name = "Km",  distribution = LogNormal( mu = 0.40, omega = sqrt(0.30) ) ) )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0 ),
                                   dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK",
                                 samplings = c( 0, 0.33, 1.5, 3, 5, 8, 11, 12 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 200,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes ) ,
              initialCondition = list( "C1" = 0 ) )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "MichaelisMenten1FirstOrderSingleDose_kaVmKmV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" = "C1" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )


  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim

  valueDetPopulationFim = 592523761240

  tol = 1e-6

  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})


test_that("Model PK 1cpt : MichaelisMenten1BolusSingleDose_VmKm", {

  # model equations

  modelFromLibrary = list("PKModel" = "MichaelisMenten1BolusSingleDose_VmKm")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "Vm",  distribution = LogNormal( mu = 0.08, omega = sqrt(0.10) ) ),
    ModelParameter( name = "Km",  distribution = LogNormal( mu = 0.40, omega = sqrt(0.30) ) )
  )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.5, sigmaSlope = 0.15 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "C1", timeDose = c( 0 ), dose = c( 100 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "C1",
                                 samplings = c( 0, 0.5, 1, 2, 6, 9, 12, 24, 36, 48, 72, 96, 120 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 200,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes ) ,
              initialCondition = list( "C1" = 0 ) )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "MichaelisMenten1BolusSingleDose_VmKm",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" = "C1" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )


  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  valueDetPopulationFim = 0.015545625761308865323
  tol = 1e-6
  expect_equal( detPopulationFim, valueDetPopulationFim, tolerance = tol )

})


###################################################################################################################################


test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kaClV", {

  modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV")

  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 63.000, omega = 0 ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.513, omega = 0 ) ),
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.050, omega = sqrt(0.1) ) )
  )

  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0, sigmaSlope = 0.0676 )
  modelError = list( errorModelRespPK )

  administration = Administration( outcome = "RespPK", timeDose = c( 0 ), dose = c( 5500 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.01, 1, 3, 5, 7, 10, 13, 17, 24 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 25,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim


  valueDetPopulationFim = 88354126194397.8

  tol = 1e-6

  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})

###################################################################################################################################


test_that("Model PK 1cpt : Linear1FirstOrderSingleDose_kaClV", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear1FirstOrderSingleDose_kaClV")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "V", distribution = LogNormal( mu = 3.5, omega =  sqrt( 0.09 ) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 2.0, omega =  sqrt( 0.09 ) ) ),
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.0, omega = sqrt(0.09) ) )
  )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0.1, sigmaSlope = 0.1 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   timeDose = c( 0,12,24,36,48 ),
                                   dose = c( 30,30,30,30,30 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.5, 1, 4, 8, 12.5, 13, 16, 20, 24.5, 25, 28, 32, 36.5, 37, 40, 44, 48.5, 49, 52, 56 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 40,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSingleDose_kaClV",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  # get the determinant of the Fisher matrix
  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim

  valueDetPopulationFim = 2835909452801529708800884.0

  tol = 1e-6

  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})

###################################################################################################################################


test_that("Model PK 1cpt : Linear1FirstOrderSteadyState_kaClVtau", {

  # --------------------------------------
  # model definition

  # model equations

  modelFromLibrary = list("PKModel" = "Linear1FirstOrderSteadyState_kaClVtau")


  # model modelParameters
  modelParameters = list(
    ModelParameter( name = "ka",  distribution = LogNormal( mu = 1.050, omega = sqrt(0.1) ) ),
    ModelParameter( name = "Cl",  distribution = LogNormal( mu = 0.513, omega =  0 ) ),
    ModelParameter( name = "V", distribution = LogNormal( mu = 63.000, omega =  0 ) )
  )


  # Error Model
  errorModelRespPK = Combined1( output = "RespPK", sigmaInter = 0, sigmaSlope = 0.0676 )
  modelError = list( errorModelRespPK )


  # administration
  administration = Administration( outcome = "RespPK",
                                   tau = c(24),
                                   dose = c( 5500 ) )

  # sampling times
  samplingTimes = SamplingTimes( outcome = "RespPK", samplings = c( 0.01, 1, 3, 5, 7, 10, 13, 17, 24 ) )

  # arm
  arm1 = Arm( name = "BrasTest",
              size = 25,
              administrations  = list( administration ) ,
              samplingTimes    = list( samplingTimes )
  )

  # design
  design1 = Design( name = "design1",
                    arms = list( arm1 ) )

  # --------------------------------------
  # Evaluation

  # Evaluate the Fisher Information Matrix for the PopulationFIM
  evaluationFIM = Evaluation( name = "Linear1FirstOrderSteadyState_kaClVtau",
                              modelFromLibrary = modelFromLibrary,
                              modelParameters = modelParameters,
                              modelError = modelError,
                              outputs = list( "RespPK" ),
                              designs = list( design1 ),
                              fimType = "population",
                              odeSolverParameters = list( atol = 1e-8, rtol = 1e-8 ) )

  evaluationFIM = run( evaluationFIM )

  # get the determinant of the Fisher matrix
  FisherMatrix = getFisherMatrix(evaluationFIM )
  detPopulationFim =det(  FisherMatrix$fisherMatrix )
  detPopulationFim


  valueDetPopulationFim = 119307107145

  tol = 1e-6

  expect_equal(detPopulationFim,valueDetPopulationFim, tolerance = tol )

})


############################################################################################################################
# END CODE
############################################################################################################################
