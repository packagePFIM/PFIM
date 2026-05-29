library(PFIM)

modelEquations = list(
  "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V * t) - exp(-ka * t))"
)

modelError = list(
  Constant( output = "RespPK", sigmaInter = 0.1 )
)

administrationRespPK = Administration(
  outcome  = "RespPK",
  timeDose = c(0),
  dose     = c(30)
)

samplingTimesRespPK = SamplingTimes( outcome = "RespPK", samplings = c( 0, 2, 3, 8, 12, 24, 36, 50, 72, 120 ) )

samplingConstraintsRespPK  = SamplingTimeConstraints( outcome = "RespPK",
                                                      initialSamplings = c( 0, 2, 3, 8, 12, 24, 36, 50, 72, 120 ),
                                                      samplingsWindows = list( c(0,24), c(35,130) ),
                                                      numberOfTimesByWindows = c(6,4),
                                                      minSampling = c(1,2) )
arm1 = Arm( name = "BrasTest1",
            size = 100,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ) )


design1 = Design( name = "design1", arms = list( arm1 ) )

modelParameters = list(
  ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) )

)

sex = Covariate(
  name                  = "Sex",
  categories            = c( "M", "F" ),
  categoriesProportions = c( 0.5, 0.5 ),
  effects               = list( "F" = c( "V" = log(1.2) ) )
)

treatment = Covariate(
  name                 = "Treatment",
  categories           = c( "A", "B" ),
  sequences            = list( c("A","B"), c("B","A") ),
  sequencesProportions = c( 0.5, 0.5 ),
  effects              = list( "B" = c( "Cl" = log(1.1) ) )
)

# optimizationPopFIM
optimization = Optimization( name = "...",
                             modelEquations = modelEquations,
                             modelParameters = modelParameters,
                             modelCovariates = list( sex, treatment ),
                             modelCovariatesEquation = "exponential",
                             numberOfOccasions       = 2,
                             modelError = modelError,
                             optimizer = "SimplexAlgorithm",
                             optimizerParameters = list( pctInitialSimplexBuilding = 20,
                                                         maxIteration = 200,
                                                         tolerance = 1e-6,
                                                         showProcess = TRUE  ),
                             designs = list( design1 ),
                             fimType = "population",
                             outputs = list( "RespPK" = "RespPK" ) )

optimizationFIM = run( optimization )

show( optimizationFIM )


