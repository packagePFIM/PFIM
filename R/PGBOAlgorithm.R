#' @title PGBOAlgorithm Class
#' @name PGBOAlgorithm
#' @description
#' The \code{PGBOAlgorithm} class implements a stochastic optimization routine based
#' on population genetics principles. It is designed to navigate complex design
#' spaces by simulating mutation, selection, and purging processes to maximize
#' the Fisher Information Matrix (FIM) criteria.
#' @include Optimization.R
#' @inheritParams Optimization
#' @param N A numeric value specifying the population size (number of individuals)
#' per generation.
#' @param muteEffect A numeric value (0-1) representing the mutation rate or the
#' intensity of the genetic mutation effect.
#' @param maxIteration An integer specifying the maximum number of generations
#' before the algorithm terminates.
#' @param purgeIteration An integer defining the frequency (in iterations) at
#' which "weak" individuals are removed from the population to maintain genetic fitness.
#' @param seed A numeric value for the random number generator to ensure
#' reproducibility of the optimization results.
#' @param showProcess A logical value; if \code{TRUE}, the algorithm prints
#' progress updates and fitness scores to the console.
#' @examples
#' \dontrun{
#'
#' # Examples from Vignette 2
#'
#' # Initializing the PGBO algorithm for population FIM optimization
#' optimizationPGBOPopFIM = Optimization(
#'   name                = "optimizationExamplePGBO",
#'   modelFromLibrary    = modelFromLibrary,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   optimizer           = "PGBOAlgorithm",
#'   optimizerParameters = list(
#'     N              = 30,    # population of 30 candidate designs
#'     muteEffect     = 0.65,  # mutation amplitude (65% of window width)
#'     maxIteration   = 1000,  # total evolutionary steps
#'     purgeIteration = 200,  # reinitialize worst solutions every 200 steps
#'     seed           = 42,
#'     showProcess    = FALSE
#'   ),
#'   designs             = list(design2),
#'   fimType             = "population",
#'   outputs             = list("RespPK")
#' )
#'
#' # Run the PGBO optimization and display the results
#' resultsPGBOPopFIM = run(optimizationPGBOPopFIM)
#' show(resultsPGBOPopFIM)
#'
#' }
#' @template copyright
#' @export

PGBOAlgorithm = new_class(
  "PGBOAlgorithm",
  package = "PFIM",
  parent  = .Optimization_S7,
  properties = list(
    N              = new_property( class_double,  default = 30 ),
    muteEffect     = new_property( class_double,  default = 0.65 ),
    maxIteration   = new_property( class_double,  default = 1000 ),
    purgeIteration = new_property( class_double,  default = 200 ),
    seed           = new_property( class_double,  default = 42 ),
    showProcess    = new_property( class_logical, default = FALSE )
  ),
  constructor = function(
    # ── PGBO-specific properties ─────────────────────────────────────────────
    N              = 30,
    muteEffect     = 0.65,
    maxIteration   = 1000,
    purgeIteration = 200,
    seed           = 42,
    showProcess    = FALSE,
    # ── Inherited Optimization properties (forwarded from the factory) ──────
    optimisationDesign           = list(),
    optimisationAlgorithmOutputs = list(),
    name                         = character(0),
    modelParameters              = list(),
    modelEquations               = list(),
    modelFromLibrary             = list(),
    modelError                   = list(),
    designs                      = list(),
    outputs                      = list(),
    fimType                      = character(0),
    odeSolverParameters          = list()
  ) {
    new_object(
      .parent = .Optimization_S7(
        optimisationDesign           = optimisationDesign,
        optimisationAlgorithmOutputs = optimisationAlgorithmOutputs,
        name                         = name,
        modelParameters              = modelParameters,
        modelEquations               = modelEquations,
        modelFromLibrary             = modelFromLibrary,
        modelError                   = modelError,
        designs                      = designs,
        outputs                      = outputs,
        fimType                      = fimType,
        odeSolverParameters          = odeSolverParameters
      ),
      N              = N,
      muteEffect     = muteEffect,
      maxIteration   = maxIteration,
      purgeIteration = purgeIteration,
      seed           = seed,
      showProcess    = showProcess
    )
  }
)

# ==============================================================================
#' @rdname optimizeDesign
#' @name optimizeDesign
#' @export
# ==============================================================================

method( optimizeDesign, list( .Optimization_S7, PGBOAlgorithm ) ) = function( optimizationObject, optimizationAlgorithm ) {

  results = list()
  # designs

  designs = prop( optimizationObject, "designs" )
  design = pluck( designs, 1 )

  # check validity of the samplingTimesConstraints
  checkValiditySamplingConstraint( design )

  # in case of partial sampling constraints set the new arms with the sampling constraints
  design = setSamplingConstraintForOptimization( design )

  # get the arms
  arms = prop( design, "arms" )

  # get arm outcomes
  outcomes = map( set_names( arms, map_chr( arms, ~ prop( .x, 'name' ) ) ), ~ {
    map_chr( prop( .x, "samplingTimesConstraints" ), ~ prop( .x, "outcome") )
  })

  # set size for checking the constraints
  numberOfArms = length( arms )
  numberOutcomesArmsInConstraints = sum( lengths( outcomes ) )

  # initialize best design
  initialDesign = design
  designA = design
  best = design

  # get pgbo parameters
  optimizerParameters = prop( optimizationObject, "optimizerParameters")
  N = optimizerParameters$N
  muteEffect = optimizerParameters$muteEffect
  maxIteration = optimizerParameters$maxIteration
  purgeIteration = optimizerParameters$purgeIteration
  showProcess = optimizerParameters$showProcess
  seed = optimizerParameters$seed
  set.seed( seed )

  # Generate the initial solution
  samplingInitialSolution = list()

  # Generate the initial solution
  armsList = list()

  for ( arm in arms )
  {
    # Extract values from the arm object
    armName = prop( arm, 'name' )
    samplingTimes = prop( arm, "samplingTimes" )
    samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

    for ( samplingTimesConstraint in samplingTimesConstraints )
    {
      # Generate samplings based on samplingConstraints
      outcome = prop( samplingTimesConstraint, "outcome" )
      samplingInitialSolution[[ armName ]][[ outcome ]]  = generateSamplingsFromSamplingConstraints( samplingTimesConstraint )

      # Set initial position for the outcome
      samplingTimes = samplingTimes %>%
        modify_at(
          .at = which( map_chr(., ~ prop( .x, "outcome" ) ) == outcome ),
          .f = ~ {
            prop(.x, "samplings") = samplingInitialSolution[[ armName ]][[ outcome ]]
            .x
          })
    }
    prop( arm, "samplingTimes" ) = samplingTimes
    armsList = append( armsList, arm )
  }

  # set new arms
  prop( design, "arms" ) = armsList

  # evaluate the FIMs
  evaluationFIM = Evaluation( name = "internalFimEvaluation",
                              modelEquations = prop( optimizationObject, "modelEquations" ),
                              modelParameters = prop( optimizationObject, "modelParameters" ),
                              modelError = prop( optimizationObject, "modelError" ),
                              fimType = prop( optimizationObject, "fimType" ),
                              outputs = prop( optimizationObject, "outputs" ),
                              designs = list( design ),
                              odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationFIM = run( evaluationFIM )

  fim = prop( evaluationFIM, "fim" )

  d = 1/Dcriterion( fim )

  if ( is.finite(d) == FALSE )
  {
    d = 10e6
  }

  # set the PGBO parameters
  fitBase = 0.03
  theta = -log10( fitBase ) / d
  fitA = 10**( -theta * d )
  fitBest = fitA

  # Run PGBO
  arms = prop( designA, "arms" )

  samplingTimesArms = list()

  for ( iteration in 1:maxIteration )
  {
    # Boolean checking constraints in for while
    foundSamplingWithConstraints = FALSE

    while ( foundSamplingWithConstraints == FALSE )
    {
      # select arm
      indexArm = sample( numberOfArms, 1 )
      arm = arms[[indexArm]]
      armName = prop( arm, "name" )

      # sampling constraints
      samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

      # get samplings
      numberOfOutcome = length( outcomes[[armName]] )
      indexOutcome = sample( numberOfOutcome, 1 )
      outcome = outcomes[[armName]][indexOutcome]

      samplings = prop( arm, "samplingTimes" ) %>%
        keep( ~ prop( .x, "outcome" ) == outcome ) %>%
        pluck(1) %>%
        prop( "samplings" )

      # sampling time mutation
      indexSamplings = sample( length( samplings ), 1 )

      if ( runif( 1 ) < 0.8 )
      {
        samplings[indexSamplings] = samplings[indexSamplings] + rcauchy(1)*muteEffect
      } else{
        samplings = samplings + rnorm( length( samplings ) )*muteEffect
      }

      samplings = sort( samplings )

      # check sampling time constraints
      samplingTimesConstraint = keep( samplingTimesConstraints, ~ prop( .x,"outcome" ) == outcome ) %>% pluck(1)
      samplingConstraintsForMetaheuristic = checkSamplingTimeConstraintsForMetaheuristic( samplingTimesConstraint, arm, samplings, outcome )

      if( all( unlist( samplingConstraintsForMetaheuristic ) ) == TRUE )
      {
        samplingTime = prop( arm, "samplingTimes" ) %>% keep( ~ prop( .x, "outcome" ) == outcome ) %>% pluck(1)
        prop( samplingTime, "samplings" ) = samplings
        samplingTimesArms[[armName]][[outcome]] = samplingTime
      }

      # check if all constraints TRUE and number of constraints = nb Arm * nb Response
      if ( length( unlist( samplingTimesArms ) ) == numberOutcomesArmsInConstraints )
      {
        foundSamplingWithConstraints = TRUE
      }
    } # end while

    armsList = list()
    for ( arm in arms )
    {
      armName = prop(arm, 'name')
      samplingTimes = prop(arm, "samplingTimes")

      for ( outcome in outcomes[[armName]] )
      {
        samplingTimes = samplingTimes %>%
          modify_at(
            .at = which( map_chr(., ~ prop( .x, "outcome" ) ) == outcome),
            .f = ~ {
              prop(.x, "samplings") = prop( samplingTimesArms[[armName]][[outcome]], "samplings")
              .x
            })
      }
      prop(arm, "samplingTimes") = samplingTimes
      armsList = append( armsList, arm )
    }

    prop( designA, "arms" ) = armsList

    # Evaluation
    designB = designA

    evaluationFIM = Evaluation( name = "internalFimEvaluation",
                                modelEquations = prop( optimizationObject, "modelEquations" ),
                                modelParameters = prop( optimizationObject, "modelParameters" ),
                                modelError = prop( optimizationObject, "modelError" ),
                                fimType = prop( optimizationObject, "fimType" ),
                                outputs = prop( optimizationObject, "outputs" ),
                                designs = list( designB ),
                                odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

    evaluationFIM = run( evaluationFIM )

    # set the cost
    fim = prop( evaluationFIM, "fim" )

    d = 1/Dcriterion( fim )

    if ( is.finite(d) == FALSE )
    {
      d = 10e6
    }

    fitB = 10**( -theta * d )

    # Update
    if ( !is.nan(fitB) && fitB > 0 )
    {
      if ( fitA == fitB )
      {
        proba = 1/N
      }
      else
      {
        f = fitA/fitB
        proba = 1 - f**2
        proba = proba / (1 - f**( 2*N ) )

        if ( is.nan(proba) )
        {
          proba = 0
        }
      }

      if (runif(1) < proba)
      {
        fitA = fitB
        designA = designB

        if ( fitBest < 1/d )
        {
          fitBest = 1/d
          best = designA

          if ( showProcess == TRUE )
          {
            # iteration and Dcriteria
            message( paste0('Iteration = ',iteration))
            message( paste0('Criterion = ',1/d))
          }
        }
      }
    }

    # Purge
    if ( iteration%%purgeIteration == 0 )
    {
      d = - log10( fitA ) / theta
      theta = -log10( fitBase ) / d
      fitA = fitBase
    }

  } # end iteration

  # evaluate the optimal design
  evaluationOptimalDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( best ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationOptimalDesign = run( evaluationOptimalDesign )

  # evaluate the initial design
  evaluationInitialDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( initialDesign ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationInitialDesign = run( evaluationInitialDesign )

  # set the results in evaluation
  prop( optimizationObject, "optimisationDesign" ) = list( evaluationInitialDesign = evaluationInitialDesign, evaluationOptimalDesign = evaluationOptimalDesign )
  prop( optimizationObject, "optimisationAlgorithmOutputs" ) = list( "optimizationAlgorithm" = optimizationAlgorithm, "optimalArms" = armsList )
  return( optimizationObject )
}

# ==============================================================================
#' @rdname constraintsTableForReport
#' @name constraintsTableForReport
#' @export
# ==============================================================================

method( constraintsTableForReport, PGBOAlgorithm ) = function( optimizationAlgorithm, arms  )
{
  armsConstraints = map( pluck( arms, 1 ) , ~ getArmConstraints( .x, optimizationAlgorithm ) )
  armsConstraints = map_dfr( armsConstraints, ~ map_dfr(.x, ~ as.data.frame(.x, stringsAsFactors = FALSE)))
  colnames( armsConstraints ) = c( "Arms name" , "Number of subjects", "Outcome", "Initial samplings", "Samplings windows", "Number of times by windows","Min sampling" )
  armsConstraintsTable = kbl( armsConstraints, align = c( "l","c","c","c","c","c","c") ) %>% kable_styling( bootstrap_options = c( "hover" ), full_width = FALSE, position = "center", font_size = 13 )
  return( armsConstraintsTable )
}
