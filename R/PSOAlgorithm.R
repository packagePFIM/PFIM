#' @title PSOAlgorithm Class
#' @name  PSOAlgorithm
#' @description
#' The \code{PSOAlgorithm} class is a subclass of \code{\link{Optimization}}
#' that implements the PSO metaheuristic. It optimizes experimental designs by
#' moving a "swarm" of candidate solutions (particles) through the search space.
#' @param maxIteration An integer specifying the maximum number of iterations
#' before the algorithm stops.
#' @param populationSize An integer specifying the number of particles in
#' the swarm. Larger populations explore the space better but increase
#' computation time.
#' @param seed A numeric value for the random number generator to ensure
#' reproducibility of the optimization results.
#' @param personalLearningCoefficient A numeric value (often denoted as \eqn{c_1})
#' that controls the "cognitive" component—how much the particle trusts its
#' own best experience.
#' @param globalLearningCoefficient A numeric value (often denoted as \eqn{c_2})
#' that controls the "social" component—how much the particle follows the
#' swarm's best experience.
#' @param showProcess A logical. If \code{TRUE}, the algorithm prints the
#' current best fitness and iteration progress to the R console.
#' @include Optimization.R
#' @inheritParams Optimization
#' @examples
#' \dontrun{
#'
#' # Examples from Vignette 2
#'
#' # Initializing the PSO algorithm for population FIM optimization
#' optimizationPSOPopFIM = Optimization(
#'   name                = "optimizationExamplePSO",
#'   modelFromLibrary    = modelFromLibrary,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   optimizer           = "PSOAlgorithm",
#'   optimizerParameters = list(
#'     maxIteration                = 100,   # number of swarm update cycles
#'     populationSize              = 50,    # number of particles
#'     personalLearningCoefficient = 2.05,  # c1: attraction toward personal best
#'     globalLearningCoefficient   = 2.05,  # c2: attraction toward global best
#'     seed                        = 42,    # reproducibility
#'     showProcess                 = FALSE  # suppress iteration-level output
#'   ),
#'   designs             = list(design2),
#'   fimType             = "population",
#'   outputs             = list("RespPK")
#' )
#'
#' # Run the PSO optimization and display the results
#' resultsPSOPopFIM = run(optimizationPSOPopFIM)
#' show(resultsPSOPopFIM)
#'
#' }
#' @template copyright
#' @export

PSOAlgorithm = new_class(
  "PSOAlgorithm",
  package = "PFIM",
  parent  = .Optimization_S7,
  properties = list(
    maxIteration                = new_property( class_double ,  default = 100 ),
    populationSize              = new_property( class_double ,  default = 50 ),
    seed                        = new_property( class_double,  default = 42 ),
    personalLearningCoefficient = new_property( class_double,  default = 2.05 ),
    globalLearningCoefficient   = new_property( class_double,  default = 2.05 ),
    showProcess                 = new_property( class_logical, default = FALSE )
  ),
  constructor = function(
    # ── PSO-specific properties ─────────────────────────────────────────────
    maxIteration                = 100,
    populationSize              = 50,
    seed                        = 42,
    personalLearningCoefficient = 2.05,
    globalLearningCoefficient   = 2.05,
    showProcess                 = FALSE,
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
      maxIteration                = maxIteration,
      populationSize              = populationSize,
      seed                        = seed,
      personalLearningCoefficient = personalLearningCoefficient,
      globalLearningCoefficient   = globalLearningCoefficient,
      showProcess                 = showProcess
    )
  }
)

# ==============================================================================
#' @rdname optimizeDesign
#' @name optimizeDesign
#' @export
# ==============================================================================

method( optimizeDesign, list( .Optimization_S7, PSOAlgorithm ) ) = function( optimizationObject, optimizationAlgorithm ) {

  # parameters of the optimization algorithm
  optimizerParameters = prop( optimizationObject, "optimizerParameters")
  populationSize = optimizerParameters$populationSize
  maxIteration = optimizerParameters$maxIteration
  personalLearningCoefficient = optimizerParameters$personalLearningCoefficient
  globalLearningCoefficient = optimizerParameters$globalLearningCoefficient
  showProcess = optimizerParameters$showProcess
  seed = optimizerParameters$seed
  set.seed( seed )

  # get the designs
  designs = prop( optimizationObject, "designs" )
  design = pluck( designs, 1 )
  optimalDesign = design

  # check validity of the samplingTimesConstraints
  checkValiditySamplingConstraint( optimalDesign )

  # in case of partial sampling constraints set the new arms with the sampling constraints
  design = setSamplingConstraintForOptimization( optimalDesign )

  # get the arms
  arms = prop( optimalDesign, "arms" )

  # generate the initial population
  cost = list()
  bestCost = rep( Inf, populationSize )
  globalBestCost = Inf

  globalBestPosition = list()
  bestPosition = list()
  velocity = list()
  position = list()

  # get arm outcomes
  outcomes = map( set_names( arms, map_chr( arms, ~ prop( .x, 'name' ) ) ), ~ {
    map_chr( prop( .x, "samplingTimesConstraints" ), ~ prop( .x, "outcome"))
  })

  # constrictionFactor
  phi1 = personalLearningCoefficient
  phi2 = globalLearningCoefficient
  phi = phi1 + phi2
  kappa = 1
  constrictionFactor = 2*kappa / abs( 2 - phi - sqrt( phi * ( phi - 4 ) ) )

  for ( iterPop in 1:populationSize )
  {
    armsList = list()
    for ( arm in arms )
    {
      # Extract values from the arm object
      armName = prop( arm, 'name' )
      samplingTimes = prop( arm, "samplingTimes" )
      samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

      for ( samplingTimesConstraint in samplingTimesConstraints )
      {
        # Generate samplings based on SamplingConstraints
        samplingsFromSamplingConstraint = generateSamplingsFromSamplingConstraints( samplingTimesConstraint )

        outcome = prop( samplingTimesConstraint, "outcome" )

        # Set initial position for the outcome
        position[[armName]][[outcome]][[iterPop]] = samplingsFromSamplingConstraint

        # Set the best position for the outcome
        bestPosition[[armName]][[outcome]][[iterPop]] = samplingsFromSamplingConstraint

        # Set initial velocity for the outcome
        velocity[[armName]][[outcome]][[iterPop]] = 0.0

        samplingTimes = samplingTimes %>%
          modify_at(
            .at = which(map_chr(., ~ prop( .x, "outcome" ) ) == outcome),
            .f = ~ {
              prop(.x, "samplings") = samplingsFromSamplingConstraint
              .x
            })
      }
      prop(arm, "samplingTimes") = samplingTimes
      armsList = append( armsList, arm )
    }

    # set new arms
    prop( optimalDesign, "arms" ) = armsList

    # evaluate the FIMs
    evaluationFIM = Evaluation( name = "internalFimEvaluation",

                                modelEquations = prop( optimizationObject, "modelEquations" ),
                                modelParameters = prop( optimizationObject, "modelParameters" ),
                                modelError = prop( optimizationObject, "modelError" ),
                                fimType = prop( optimizationObject, "fimType" ),
                                outputs = prop( optimizationObject, "outputs" ),
                                designs = list( optimalDesign ),
                                odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

    evaluationFIM = run( evaluationFIM )

    # get D-criterion
    fim = prop( evaluationFIM, "fim" )
    cost[[ iterPop ]] = 1/Dcriterion( fim )

    # update bestPosition
    bestPosition = position

    # update bestCost
    bestCost[[ iterPop ]] = cost[[ iterPop ]]
    indexMinBestCost = which.min( unlist( bestCost ) )

    # update Global Best
    if ( bestCost[[ indexMinBestCost ]] < globalBestCost )
    {
      for ( arm in arms )
      {
        armName = prop( arm, "name")

        for ( outcome in outcomes[[ armName ]] )
        {
          globalBestPosition[[ armName ]][[ outcome ]] = bestPosition[[ armName ]][[ outcome ]][[ indexMinBestCost ]]
        }
      }
      globalBestCost = bestCost[[ indexMinBestCost ]]
    }
  } # end iterPop

  # Run the PSO
  for ( iteration in 1:maxIteration )
  {
    # show process
    if ( showProcess == TRUE )
    {
      message( paste0( "iter = ", iteration ) )
    }

    for ( iterPop in 1:populationSize )
    {
      # update Velocity

      for ( arm in arms )
      {
        armName = prop( arm, "name")

        for ( outcome in outcomes[[ armName ]] )
        {
          n = length( globalBestPosition[[ armName ]][[ outcome ]] )

          velocity[[ armName ]][[ outcome ]][[ iterPop ]] =
            constrictionFactor *
            ( velocity[[ armName ]][[ outcome ]][[ iterPop ]] +
                phi1 * runif(1,0,1) * ( bestPosition[[ armName ]][[ outcome ]][[ iterPop ]] - position[[ armName ]][[ outcome ]][[ iterPop ]] ) +
                phi2 * runif(1,0,1) * ( globalBestPosition[[ armName ]][[ outcome ]] - position[[ armName ]][[ outcome ]][[ iterPop ]] ) )
        }
      }

      # update Position
      for ( arm in arms )
      {
        armName = prop( arm, "name")

        for ( outcome in outcomes[[ armName ]] )
        {
          position[[ armName ]][[ outcome ]][[ iterPop ]] = position[[ armName ]][[ outcome ]][[ iterPop ]] + velocity[[ armName ]][[ outcome ]][[ iterPop ]]
          position[[ armName ]][[ outcome ]][[ iterPop ]] = sort( position[[ armName ]][[ outcome ]][[ iterPop ]] )
        }
      }

      # apply position limits
      for ( arm in arms )
      {
        armName = prop( arm, "name")
        samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

        for ( outcome in outcomes[[armName]] )
        {
          samplingTimesConstraint = keep( samplingTimesConstraints, ~ prop(.x,"outcome") == outcome ) %>% pluck(1)
          samplingsWindows = prop( samplingTimesConstraint, "samplingsWindows" )
          positionLength = length( position[[ armName ]][[ outcome ]][[ iterPop ]] )

          for( j in 1:positionLength )
          {
            distance = list()

            iter = 1
            for ( samplingsWindow in samplingsWindows )
            {
              tmp = map( samplingsWindow, ~ abs( .x - position[[armName]][[outcome]][[iterPop]][j] ) )

              distance[[iter]] = unlist( tmp )
              iter = iter+1
            }

            indDistanceMin = which.min( map_dbl( distance, ~ min(.x) ) )

            maxSamplings = max( samplingsWindows[[indDistanceMin]])
            minSamplings = min( samplingsWindows[[indDistanceMin]])

            position[[ armName ]][[ outcome ]][[ iterPop ]][ j ] = min( maxSamplings, position[[ armName ]][[ outcome ]][[ iterPop ]][ j ] )
            position[[ armName ]][[ outcome ]][[ iterPop ]][ j ] = max( minSamplings, position[[ armName ]][[ outcome ]][[ iterPop ]][ j ] )
          }
          position[[ armName ]][[ outcome ]][[ iterPop ]] = sort( position[[ armName ]][[ outcome ]][[ iterPop ]] )
        }
      }

      # constraints
      samplingConstraintsForMetaheuristic = list()

      for ( arm in arms )
      {
        armName = prop( arm, "name")
        samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

        # check the constraints on the samplings times
        for ( outcome in outcomes[[armName]] )
        {
          newSamplings = position[[ armName ]][[ outcome ]][[ iterPop ]]
          samplingTimesConstraint = keep( samplingTimesConstraints, ~ prop( .x,"outcome" ) == outcome ) %>% pluck(1)
          samplingConstraintsForMetaheuristic[[ armName ]][[ outcome ]] = checkSamplingTimeConstraintsForMetaheuristic( samplingTimesConstraint, arm, newSamplings, outcome )
        }
      }

      samplingConstraintsForMetaheuristic = unlist( samplingConstraintsForMetaheuristic )

      if( all( samplingConstraintsForMetaheuristic ) == TRUE )
      {
        arms = prop( optimalDesign, "arms")
        # set new sampling times
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
                  prop(.x, "samplings") = position[[armName]][[outcome]][[iterPop]]
                  .x
                })
          }
          prop(arm, "samplingTimes") = samplingTimes
          armsList = append( armsList, arm )
        }

        # set new arms to the design
        prop( optimalDesign, "arms" ) = armsList

        # set and evaluate new design with the constraints
        evaluationFIM = Evaluation( name = "internalFimEvaluation",
                                    modelEquations = prop( optimizationObject, "modelEquations" ),
                                    modelParameters = prop( optimizationObject, "modelParameters" ),
                                    modelError = prop( optimizationObject, "modelError" ),
                                    fimType = prop( optimizationObject, "fimType" ),
                                    outputs = prop( optimizationObject, "outputs" ),
                                    designs = list( optimalDesign ),
                                    odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

        evaluationFIM = run( evaluationFIM )

        # set the cost
        fim = prop( evaluationFIM, "fim" )

        cost[[ iterPop ]] = 1/Dcriterion( fim )

        if (is.nan( cost[[ iterPop ]]))
        {
          cost[[ iterPop ]] = Inf
        }

        if (is.nan( bestCost[[ iterPop ]]))
        {
          bestCost[[ iterPop ]] = Inf
        }

        # Update Personal Best
        if ( cost[[ iterPop ]] < bestCost[[ iterPop ]] )
        {
          for ( arm in arms )
          {
            armName = prop( arm, "name" )

            for ( outcome in outcomes[[armName]] )
            {
              bestPosition[[ armName ]][[ outcome ]][[ iterPop ]] = position[[ armName ]][[ outcome ]][[ iterPop ]]
            }
            bestCost[[ iterPop ]] = cost[[ iterPop ]]
          }

          indexMinBestCost = which.min( bestCost )

          if ( bestCost[[ indexMinBestCost ]] < globalBestCost )
          {
            for ( arm in arms )
            {
              armName = prop( arm, "name" )

              for ( outcome in outcomes[[armName]] )
              {
                globalBestPosition[[ armName ]][[ outcome ]] = bestPosition[[ armName ]][[ outcome ]][[ indexMinBestCost ]]
              }
            }
            globalBestCost = bestCost[[ indexMinBestCost ]]
          }
        }
      }
    } # end iter pop

    if ( showProcess == TRUE )
    {
      message( paste0( "globalBestCost = ", 1/globalBestCost ) )
    }
  } # end iteration

  # evaluate the optimal design
  evaluationOptimalDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( optimalDesign ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationOptimalDesign = run( evaluationOptimalDesign )

  # evaluate the initial design
  evaluationInitialDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( design ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationInitialDesign = run( evaluationInitialDesign )

  # set the results
  prop( optimizationObject, "optimisationDesign" ) = list( evaluationInitialDesign = evaluationInitialDesign, evaluationOptimalDesign = evaluationOptimalDesign )
  prop( optimizationObject, "optimisationAlgorithmOutputs" ) = list( "optimizationAlgorithm" = optimizationAlgorithm, "optimalArms" = armsList )
  return( optimizationObject )
}

# ==============================================================================
#' @rdname constraintsTableForReport
#' @name constraintsTableForReport
#' @export
# ==============================================================================

method( constraintsTableForReport, PSOAlgorithm ) = function( optimizationAlgorithm, arms  )
{
  armsConstraints = map(pluck(arms, 1), ~ getArmConstraints(.x, optimizationAlgorithm))
  armsConstraints = map_dfr(armsConstraints, ~ map_dfr(.x, ~ as.data.frame(.x, stringsAsFactors = FALSE)))

  # Rename columns
  colnames(armsConstraints) = c("Arms name", "Number of subjects", "Outcome",
                                "Initial samplings", "Samplings windows",
                                "Number of times by windows", "Min sampling")

  # Clean column "Min sampling"
  armsConstraints$`Min sampling` = gsub("[()]", "", armsConstraints$`Min sampling`)          # supprime les parenthèses
  armsConstraints$`Min sampling` = as.numeric(armsConstraints$`Min sampling`)                 # convertit en numérique
  armsConstraints$`Min sampling` = round(armsConstraints$`Min sampling`, 1)                   # arrondit à 0.1

  # Create Table
  armsConstraintsTable = kbl(armsConstraints,
                             align = c("l", "c", "c", "c", "c", "c", "c")) %>%
    kable_styling(bootstrap_options = c("hover"),
                  full_width = FALSE,
                  position = "center",
                  font_size = 13)

  return( armsConstraintsTable )
}
