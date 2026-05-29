library(PFIM)

# ======================================================================================================
# PFIM 7.1 — Design optimisation for a 1-compartment PK model with first-order absorption
#
# Objective: find the 3 optimal sampling times (among 0.5, 2, 4, 6, 8h)
#            for a PK model with covariates (Sex on V) and occasion covariate
#            (Treatment on Cl in an AB/BA cross-over), with IOV on all parameters.
#
# Algorithm: Multiplicative — maximises the D-criterion of the FIM
#            by searching for the optimal combination of elementary designs.
# ======================================================================================================

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

samplingTimesRespPK = SamplingTimes(
  outcome   = "RespPK",
  samplings = c( 0.5,2,4,6,8 )
)

administrationConstraintsRespPK = AdministrationConstraints( outcome = "RespPK", doses = list( 30 ) )

samplingConstraintsRespPK = SamplingTimeConstraints(
  outcome                      = "RespPK",
  initialSamplings             = c( 0.5,2,4,6,8),
  numberOfsamplingsOptimisable = 3
)

arm1 = Arm( name = "BrasTest1",
            size = 40,
            administrations = list( administrationRespPK ),
            samplingTimes   = list( samplingTimesRespPK ),
            administrationsConstraints = list( administrationConstraintsRespPK ),
            samplingTimesConstraints = list( samplingConstraintsRespPK ) )


design1 = Design( name = "design1", arms = list( arm1 ) )

modelParameters = list(
ModelParameter( name = "ka", distribution = LogNormal( mu = 1,   omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "V",  distribution = LogNormal( mu = 3.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) ),
  ModelParameter( name = "Cl", distribution = LogNormal( mu = 0.5, omega = sqrt(0.09) ), gamma = sqrt(0.0225) )

)

# Covariable FIXE (Covariate) : Sex sur V
sex = Covariate(
  name                  = "Sex",
  categories            = c( "M", "F" ),
  categoriesProportions = c( 0.5, 0.5 ),
  effects               = list( "F" = c( "V" = log(1.2) ) )
)

# Covariable d'occassion : Treatment sur Cl
treatment = Covariate(
  name                 = "Treatment",
  categories           = c( "A", "B" ),
  sequences            = list( c("A","B"), c("B","A") ),
  sequencesProportions = c( 0.5, 0.5 ),
  effects              = list( "B" = c( "Cl" = log(1.1) ) )
)

# Optimization
optimization = Optimization( name = "...",
                             modelEquations = modelEquations,
                             modelParameters = modelParameters,
                             modelCovariates = list( sex, treatment ),
                             modelCovariatesEquation = "exponential",
                             numberOfOccasions       = 2,
                             modelError = modelError,
                             optimizer = "MultiplicativeAlgorithm",
                             optimizerParameters = list( lambda = 0.99,
                                                         numberOfIterations = 1000,
                                                         weightThreshold = 0.01,
                                                         delta = 1e-04, showProcess = T ),
                             designs = list( design1 ),
                             fimType = "population",
                             outputs = list( "RespPK" = "RespPK" ) )

optimizationFIM = run( optimization )

show( optimizationFIM )
