#' @title Design Class
#' @name Design
#'
#' @description
#' The \code{Design} class represents a full clinical trial design. It acts as a
#' container for multiple \code{Arm} objects and stores the population-level
#' Fisher Information Matrix (FIM) and evaluation results for the entire study.
#'
#' @slot name \code{character}. The name of the design.
#' @slot size \code{numeric}. Total number of subjects across all arms.
#' @slot arms \code{list}. A list containing the \code{Arm} objects.
#' @slot numberOfArms \code{numeric}. The count of arms in the design.
#' @slot fim \code{Fim}. The global Fisher Information Matrix for the design.
#'
#' @param name A string giving the name of the design.
#' @param size A numeric value representing the total number of subjects.
#' @param arms A list of \code{Arm} objects defining the different groups.
#' @param numberOfArms An integer giving the number of arms.
#' @param evaluationArms A list containing the evaluation results for each arm.
#' @param fim An object of class \code{Fim} giving the global FIM of the design.
#'
#' @return An object of class \code{Design}.
#'
#' @include Fim.R
#'
#' @examples
#'
#' # 1. Define sampling times for PK and PD outcomes
#' samplingTimesRespPK = SamplingTimes(outcome   = "RespPK",
#'                                      samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))
#'
#' samplingTimesRespPD = SamplingTimes(outcome   = "RespPD",
#'                                      samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))
#'
#' # 2. Define the administration (Dose of 20 at t=0)
#' adminRespPK = Administration(outcome = "RespPK", timeDose = 0, dose = 20)
#'
#' # 3. Define the study arm "0.2mg"
#' # Outcomes are linked to state variables: RespPK to Cc, RespPD to E.
#' arm02mg = Arm(name = "0.2mg",
#'                size = 6,
#'                administrations   = list(adminRespPK),
#'                samplingTimes     = list(samplingTimesRespPK, samplingTimesRespPD),
#'                initialConditions = list("Cc" = 0, "E" = 100))
#'
#' # 4. Create the Design object
#' # The arm defined above is included in the 'arms' list.
#' design1 = Design(name = "Design1",
#'                   arms = list(arm02mg))
#'
#' # Display the design summary
#' print(design1)
#'
#' @template copyright
#' @export

Design = new_class("Design", package = "PFIM",
                   properties = list(
                     name = new_property(class_character, default = character(0)),
                     size = new_property(class_double, default = 0.0),
                     arms = new_property(class_list, default = list()),
                     evaluationArms = new_property(class_list, default = list()),
                     numberOfArms = new_property(class_double, default = 0.0),
                     fim = new_property(Fim, default = NULL)
                   ))


evaluateDesign = new_generic( "evaluateDesign", c( "design" ) )
generateDosesCombination = new_generic( "generateDoseCombination", c( "design" ) )
generateSamplingTimesCombination = new_generic( "generateSamplingTimesCombination", c( "design" ) )
checkValiditySamplingConstraint = new_generic( "checkValiditySamplingConstraint", c( "design" ) )
setSamplingConstraintForOptimization = new_generic( "setSamplingConstraintForOptimization", c( "design" ) )

# ==============================================================================
#' @title Evaluation of a clinical design
#' @name evaluateDesign
#' @param design An object \code{Design} to evaluate.
#' @param model An object \code{Model} used for evaluation.
#' @param fim An object \code{Fim} to store results.
#' @return The \code{Design} object with evaluated arms and aggregated global FIM.
#' @template copyright
#' @export
# ==============================================================================

method( evaluateDesign, Design ) = function( design, model, fim ) {

  # evaluate the arms of each design
  arms = prop( design, "arms")
  prop( design, "evaluationArms") = arms %>% map( ~ evaluateArm( .x , model, fim ) )

  evaluationDesign = pluck( prop( design, "evaluationArms"),1)
  evaluationFim = prop( evaluationDesign, "evaluationFim" )

  prop( fim, "fisherMatrix" ) = prop( design, "evaluationArms" ) %>% map( ~ prop( prop( .x, "evaluationFim" ), "fisherMatrix" ) ) %>% reduce(`+`)
  prop( fim, "shrinkage" ) = prop( evaluationFim, "shrinkage" )
  prop( design, "fim" ) = fim

  return( design )
}

# ==============================================================================
#' @title Generate dose combinations for optimization
#' @name generateDosesCombination
#' @param design An object \code{Design}.
#' @return A list containing the combinations of doses and the total count.
#' @template copyright
#' @export
# ==============================================================================

method( generateDosesCombination, Design ) = function( design ) {

  arms = prop( design, "arms" )
  armNames = map_chr( arms, ~ prop( .x, "name" ) )
  outcomes = map( arms, ~ map_chr(prop( .x, "administrationsConstraints" ), ~ prop( .x,"outcome" ) ) )

  # combination of the doses
  dosesForFIMsTmp = map( arms, ~ {
    administrationsConstraints = prop( .x, "administrationsConstraints" )
    armName = prop( .x, "name" )
    doses = map( administrationsConstraints, ~ {
      doses = prop( .x, "doses" )
    })
  }) %>% flatten() %>% expand.grid()

  # assign arm and responses names to each combination
  dosesForFIMs = list()
  iter = 1
  for ( arm in arms ) {
    administrations = prop( arm, "administrations")
    armName = prop( arm, "name")
    for ( administration in administrations ) {
      outcome = prop( administration, "outcome")
      dosesForFIMs[[armName]][[outcome]] = unlist(dosesForFIMsTmp[,iter])
      iter = iter + 1 } }
  return( c( dosesForFIMs, numberOfDoses = dim(dosesForFIMsTmp)[1] ) )
}

# ==============================================================================
#' @title Generate sampling time combinations
#' @name generateSamplingTimesCombination
#' @param design An object \code{Design}.
#' @return A list of possible sampling time combinations for each arm.
#' @template copyright
#' @export
# ==============================================================================

method( generateSamplingTimesCombination, Design ) = function( design ) {

  arms = prop( design, "arms" )
  armNames = map_chr( arms, ~ prop( .x, "name" ) )

  armResults = map( arms, function( arm ) {

    # Extract the relevant properties for each arm
    armName = prop( arm, "name" )
    samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )
    samplingTimes = prop( arm, "samplingTimes")
    outcomeNames = map_chr( samplingTimesConstraints, ~ prop( .x, "outcome" ) )

    # Generate all combinations of sampling times for the arm
    samplingTimesCombinations = map( samplingTimesConstraints, function( samplingTimesConstraint ) {
      initialSamplings = prop( samplingTimesConstraint, "initialSamplings" )
      fixedTimes = prop( samplingTimesConstraint, "fixedTimes" )
      numberOfSamplingsOptimisable = prop( samplingTimesConstraint, "numberOfSamplingsOptimisable" )
      availableSamplings = setdiff( initialSamplings, fixedTimes )
      combinations = combn( availableSamplings, numberOfSamplingsOptimisable - length( fixedTimes ), simplify = FALSE )

      # Generate all combinations of sampling times
      map( combinations, ~ c( fixedTimes, .x ) )
    })

    # Flatten the list and convert to a data frame
    samplingTimesCombinations = expand.grid( samplingTimesCombinations )
    colnames( samplingTimesCombinations ) = outcomeNames

    # Convert to a list of named lists
    samplingTimesCombinations = pmap( samplingTimesCombinations, ~ list( ... ) )

    # Map the sampling times combinations to the sampling times for each outcome
    samplingsForFIM = map( samplingTimesCombinations, function( samplingTimeCombination ) {
      map2( samplingTimes, outcomeNames, function( samplingTime, outcomeName ) {
        prop( samplingTime, "samplings" ) = sort( samplingTimeCombination[[outcomeName]] )
        samplingTime
      })
    })
  })
  set_names( armResults, armNames )
}

# ==============================================================================
#' @title Validate optimization constraints
#' @name checkValiditySamplingConstraint
#' @param design An object \code{Design}.
#' @return Returns nothing if valid, or stops with an error message if
#' the sampling window/delta constraints are mathematically impossible.
#' @template copyright
#' @export
#' ===================================================================

method( checkValiditySamplingConstraint, Design ) = function( design ) {

  arms = prop( design, "arms" )

  walk ( arms, function( arm ) {
    armName = prop( arm, "name" )

    # get the outcomes
    samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )
    outcomes = map( samplingTimesConstraints, ~ prop( .x, "outcome" ) ) %>% unlist()

    # get samplings window constraints
    samplingsWindow = map( samplingTimesConstraints, ~ prop( .x, "samplingsWindows" ) ) %>% setNames( outcomes )

    # get numberOfTimesByWindows constraints
    numberOfTimesByWindows = map( samplingTimesConstraints, ~ prop( .x, "numberOfTimesByWindows" ) ) %>% setNames( outcomes )

    # get minimal time step for each windows
    minSampling = map( samplingTimesConstraints, ~ prop( .x, "minSampling" ) ) %>% setNames( outcomes )

    inputRandomSpaced = list()
    samplingTimesArms = list()

    walk ( outcomes, function( outcome ) {
      intervalsConstraints = list()

      # get samplingTimes and samplings
      samplingTimes = prop( arm, "samplingTimes")
      samplings = map( samplingTimes, ~ if ( prop( .x, "outcome") == outcome ) prop(.x ,"samplings" ) ) %>% compact() %>% unlist()

      minSamplingAndNumberOfTimesByWindows = as.data.frame( list( minSampling[[outcome]], numberOfTimesByWindows[[outcome]] ) )
      tmp = t( as.data.frame(samplingsWindow[[outcome]] ) )
      inputRandomSpaced[[outcome]] = as.data.frame( do.call( "cbind", list( tmp, minSamplingAndNumberOfTimesByWindows ) ) )

      colnames( inputRandomSpaced[[outcome]] ) = c("min","max","delta","n")
      rownames( inputRandomSpaced[[outcome]] ) = NULL

      if ( sum( numberOfTimesByWindows[[outcome]] ) != length( samplings ) ) {
        print ( " ==================================================================================================== ")
        print( paste0( " The sampling times constraint is not possible for arm ", armName, " and outcome ", outcome ) )
        print ( " ==================================================================================================== ")
        stop() }

      walk( seq_len( length( inputRandomSpaced[[outcome]]$n)), function( iter ) {
        min = inputRandomSpaced[[outcome]]$min[iter]
        max = inputRandomSpaced[[outcome]]$max[iter]
        delta = inputRandomSpaced[[outcome]]$delta[iter]
        n = inputRandomSpaced[[outcome]]$n[iter]

        distance = max-min-(n-1)*delta

        if ( distance < 0 ) {
          print ( " ==================================================================================================== ")
          print( paste0( " The sampling times constraint is not possible for arm ", armName, " and outcome ", outcome ) )
          print ( " ==================================================================================================== ")
          stop() }
      })
    })
  })
}

# ==============================================================================
#' @title Initialize sampling constraints
#' @name setSamplingConstraintForOptimization
#' @param design An object \code{Design}.
#' @return The \code{Design} object with updated \code{samplingTimesConstraints}.
#' @template copyright
#' @export
# ==============================================================================

method( setSamplingConstraintForOptimization, Design ) = function( design ) {

  arms = prop( design, "arms" )

  arms = map ( arms, function( arm )
  {
    # get the outcomes in the sampling times
    samplingTimes = prop( arm, "samplingTimes" )
    outcomes = map_chr( samplingTimes, ~ prop( .x, "outcome" ) )

    # set the sampling time constraints for missing outcomes ie from its sampling times
    samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )
    outcomesSamplingTimesConstraints = map_chr( samplingTimesConstraints, ~ prop( .x, "outcome" ) )
    outcomesSamplingNotInTimesConstraints = outcomes[!outcomes %in% outcomesSamplingTimesConstraints]

    if ( length( outcomesSamplingNotInTimesConstraints ) !=0 )
    {
      samplingTimesConstraints = map( outcomesSamplingNotInTimesConstraints, function( outcomeSamplingNotInTimesConstraints )
      {
        samplings = map( samplingTimes, ~ if ( prop( .x, "outcome") == outcomeSamplingNotInTimesConstraints ) prop(.x ,"samplings" ) ) %>% compact() %>% unlist()

        newSamplingTimeConstraints  = SamplingTimeConstraints( outcome = outcomeSamplingNotInTimesConstraints,
                                                               initialSamplings = samplings,
                                                               samplingsWindows = list( c( min( samplings ), max( samplings ) ) ),
                                                               numberOfTimesByWindows = length( samplings ),
                                                               minSampling = 0 )

        samplingTimesConstraints = append( samplingTimesConstraints, newSamplingTimeConstraints )
      }) %>% reduce(c(.))
    }
    prop( arm, "samplingTimesConstraints" ) = samplingTimesConstraints
    return(arm)
  })

  # set the design with arms
  prop( design, "arms" ) = arms
  return( design )
}






