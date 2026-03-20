# ==============================================================================
# ==============================================================================
# ==============================================================================
#' @title ModelAnalyticSteadyState Class
#' @name ModelAnalyticSteadyState
#' @description The class \code{ModelAnalyticSteadyState} is used to defined an analytic model in steady state.
#' @inheritParams ModelAnalytic
#' @param wrapperModelAnalytic Wrapper for the ode solver.
#' @param functionArgumentsModelAnalytic A list giving the functionArguments of the wrapper for the analytic model in steady state.
#' @param functionArgumentsSymbolModelAnalytic A list giving the functionArgumentsSymbol of the wrapper for the analytic model in steady state.
#' @param solverInputs A list giving the solver inputs.
#' @include Model.R
#' @template copyright
#' @export

ModelAnalyticSteadyState = new_class( "ModelAnalyticSteadyState", package = "PFIM", parent = ModelAnalytic,

                                      properties = list( wrapperModelAnalytic = new_property(class_list, default = list()),
                                                         functionArgumentsModelAnalytic = new_property(class_list, default = list()),
                                                         functionArgumentsSymbolModelAnalytic = new_property(class_list, default = list()),
                                                         solverInputs = new_property(class_list, default = list()) ) )

# ==============================================================================
#' @rdname defineModelWrapper
#' @name defineModelWrapper
#' @export
# ==============================================================================
method( defineModelWrapper, ModelAnalyticSteadyState ) = function( model, evaluation ) {

  # outcomes with administration
  outcomesWithAdministration = evaluation %>%
    pluck( "designs" ) %>%
    map( ~ pluck( .x, "arms" ) ) %>%
    unlist() %>%
    map( ~ pluck( .x, "administrations" ) ) %>%
    unlist()%>%
    map( ~ pluck( .x, "outcome" ) ) %>%
    unlist() %>% unique()

  # arguments for the function
  parameters = prop( evaluation, "modelParameters" )
  parameterNames = map_chr( parameters, "name" )
  doseNames = paste( "dose_", outcomesWithAdministration, sep = "" )
  timeNames = paste( "t_", outcomesWithAdministration, sep = "" )
  tauName = "tau"

  # names of the equations with admin and no admin
  equations = prop( evaluation, "modelEquations" )

  equationsWithAdmin = equations[ names( equations ) %in% outcomesWithAdministration ]
  equationsWithNoAdmin = equations[ !( names( equations ) %in% outcomesWithAdministration ) ]

  # outputs
  outputs = names( equations )
  outputNames = unlist( outputs )

  # outputs with / without admin
  indexOutputNoAdmin = which( !( names( equations ) %in% outcomesWithAdministration ) )
  outputNoAdmin = outputNames[ indexOutputNoAdmin ] %>% unlist()

  # outputForEvaluation
  outputsForEvaluation = prop( evaluation, "outputs" )
  # pk model
  if ( length(outputsForEvaluation ) == 1 )
  {
    outputAdmin = unlist(outputsForEvaluation[1])
    outputNoAdmin = c()
    # pkpd model
  }else if ( length(outputsForEvaluation ) == 2 )
  {
    outputAdmin = unlist(outputsForEvaluation[1])
    outputNoAdmin = unlist(outputsForEvaluation[2])
  }

  # wrapper for function with outcome administration

  # args for function with admin
  functionArgumentsWithAdmin = unique( c( doseNames, parameterNames, timeNames, tauName ) )
  functionArgumentsSymbolWithAdmin = map( functionArgumentsWithAdmin, ~ as.symbol(.x) )

  # create function with admin
  equationsBodyWithAdmin = map_chr( names( equationsWithAdmin ), ~ sprintf( "%s = %s", .x, equationsWithAdmin[[.x]] ) )
  equationsBodyWithAdmin = map2_chr( equationsBodyWithAdmin, timeNames, ~ str_replace_all( .x, "\\bt\\b", .y ) )

  functionBodyWithAdmin = paste( equationsBodyWithAdmin, collapse = "\n" )
  functionBodyWithAdmin = sprintf( paste( "%s\nreturn(list(c(", paste( outputAdmin, collapse = ", ") , ")))", collapse = ", " ), functionBodyWithAdmin )
  functionDefinitionWithAdmin = sprintf( "function(%s) { %s }", paste( functionArgumentsWithAdmin, collapse = ", " ), functionBodyWithAdmin )
  functionDefinitionWithAdmin = eval( parse( text = functionDefinitionWithAdmin ) )

  # wrapper for function outcome without administration

  # args for function without admin
  functionArgumentsWithNoAdmin = unique( c( outcomesWithAdministration, parameterNames, timeNames,tauName ) )
  functionArgumentsSymbolWithNoAdmin = map( functionArgumentsWithNoAdmin, ~ as.symbol(.x) )

  # create function without admin
  equationsBodyWithNoAdmin = map_chr( names( equationsWithNoAdmin ), ~ sprintf( "%s = %s", .x, equationsWithNoAdmin[[.x]] ) )
  equationsBodyWithNoAdmin = map2_chr( equationsBodyWithNoAdmin, timeNames, ~ str_replace( .x, "\\bt\\b", .y ) )
  functionBodyWithNoAdmin = paste( equationsBodyWithNoAdmin, collapse = "\n" )
  functionBodyWithNoAdmin = sprintf( paste( "%s\nreturn(list(c(", paste( outputNoAdmin, collapse = ", "), ")))", collapse = ", " ), functionBodyWithNoAdmin )
  functionDefinitionWithNoAdmin = sprintf( "function(%s) { %s }", paste( functionArgumentsWithNoAdmin, collapse = ", " ), functionBodyWithNoAdmin )
  functionDefinitionWithNoAdmin = eval( parse( text = functionDefinitionWithNoAdmin ) )

  prop( model, "wrapperModelAnalytic" ) = list( functionDefinitionWithAdmin = functionDefinitionWithAdmin,
                                                functionDefinitionWithNoAdmin = functionDefinitionWithNoAdmin )

  prop( model, "functionArgumentsModelAnalytic" ) = list( functionArgumentsWithAdmin = functionArgumentsWithAdmin,
                                                          functionArgumentsWithNoAdmin = functionArgumentsWithNoAdmin )

  prop( model, "functionArgumentsSymbolModelAnalytic" ) = list( functionArgumentsSymbolWithAdmin = functionArgumentsSymbolWithAdmin,
                                                                functionArgumentsSymbolWithNoAdmin = functionArgumentsSymbolWithNoAdmin )

  # define the model
  prop( model, "outputNames") = unlist( outputs )
  prop( model, "outcomesWithAdministration") = outcomesWithAdministration

  return( model )
}

# ==============================================================================
#' @rdname defineModelAdministration
#' @name defineModelAdministration
#' @export
# ==============================================================================

method( defineModelAdministration, ModelAnalyticSteadyState ) = function( model, arm ) {

  # administrations and outcome
  administrations = prop( arm, "administrations" )
  outcomesWithAdministration =  prop( model, "outcomesWithAdministration" )

  # sampling times
  samplingTimes = prop( arm, "samplingTimes" )

  # define the samplings for all response
  samplings = map( samplingTimes, ~ prop( .x, "samplings" ) ) %>% unlist() %>% sort() %>% unique()

  # define solverInputs
  solverInputs = map( administrations, function(  administration ) {

    timeDose = prop( administration, "timeDose" )
    tau = prop( administration, "tau" )
    dose = prop( administration, "dose" )
    maxSampling = max( samplings )

    if ( tau != 0 ) {
      timeDose = seq( 0, maxSampling, tau )
      dose = rep( dose, length( timeDose ) )
    }

    timeDose = timeDose %>%
      map( ~ ifelse( samplings - .x > 0, samplings - .x, samplings ) ) %>%
      reduce( cbind )

    indicesDoses = map_int( seq_len( nrow( timeDose ) ), ~{
      length( unique( timeDose[.x, ] ) )
    })

    list( data = data.frame( timeDose, indicesDoses ), dose = dose, tau = tau )

  }) %>% setNames( outcomesWithAdministration )

  prop( model, "samplings" ) = samplings
  prop( model, "solverInputs" ) = solverInputs

  return( model )
}

# ==============================================================================
#' @rdname evaluateModel
#' @name evaluateModel
#' @export
# ==============================================================================

method( evaluateModel, ModelAnalyticSteadyState ) = function( model, arm ) {

  # parameters
  parameters = prop( model, "modelParameters")
  # administrations
  outcomesWithAdministration =  prop( model, "outcomesWithAdministration" )
  # outputs
  outputNames = prop( model, "outputNames" )
  # sampling time for model
  samplings = prop( model, "samplings" )
  # solver inputs for time dose and indice dose
  solverInputs = prop( model, "solverInputs")

  # model wrapper model analytic
  wrapperModelAnalytic = prop( model, "wrapperModelAnalytic")
  functionDefinitionWithAdmin = wrapperModelAnalytic$functionDefinitionWithAdmin
  functionDefinitionWithNoAdmin = wrapperModelAnalytic$functionDefinitionWithNoAdmin

  # args for model evaluation function with administration
  functionArguments = prop( model, "functionArgumentsModelAnalytic" )
  functionArgumentsWithAdmin = functionArguments$functionArgumentsWithAdmin
  functionArgumentsWithNoAdmin = functionArguments$functionArgumentsWithNoAdmin

  # args for model evaluation function without administration
  functionArgumentsSymbols = prop( model, "functionArgumentsSymbolModelAnalytic" )
  functionArgumentsSymbolWithAdmin = functionArgumentsSymbols$functionArgumentsSymbolWithAdmin
  functionArgumentsSymbolWithNoAdmin = functionArgumentsSymbols$functionArgumentsSymbolWithNoAdmin

  # Assign the values to variables in the current environment
  mu = set_names(
    map( prop( model, "modelParameters" ), ~ {
      distribution = prop( .x, "distribution")
      prop( distribution, "mu" )
    }),
    map( parameters, ~ prop( .x, "name") )
  )

  list2env( mu, envir = environment() )

  # evaluate analytic model
  evaluationModelTmp = map( seq_along( samplings ), function( iterTime ) {

    evaluationOutcome = map( outcomesWithAdministration, function( outcomeWithAdministration ) {

      data = solverInputs[[outcomeWithAdministration]]$data
      dose = solverInputs[[outcomeWithAdministration]]$dose
      tau = solverInputs[[outcomeWithAdministration]]$tau

      indicesDoses = data$indicesDoses[iterTime]
      time = data[iterTime, 1:indicesDoses]
      doses = dose[1:indicesDoses]

      evaluationOutcomeWithAdmin = sum( map_dbl( seq_len( indicesDoses ), function( indiceDose ) {
        assign( paste0( "dose_", outcomeWithAdministration ), doses[indiceDose] )
        assign( paste0( "t_", outcomeWithAdministration ), time[indiceDose] )
        do.call( functionDefinitionWithAdmin, setNames( functionArgumentsSymbolWithAdmin, functionArgumentsWithAdmin ) ) %>% unlist()
      }))

      # assign values to response PK
      assign( outcomeWithAdministration, evaluationOutcomeWithAdmin )

      # evaluation function response PD
      evaluationOutcomeWithNoAdmin = do.call( functionDefinitionWithNoAdmin, setNames( functionArgumentsSymbolWithNoAdmin, functionArgumentsWithNoAdmin ) ) %>% unlist()

      # test if response PD or not
      if ( is.null( evaluationOutcomeWithNoAdmin ) )
      {
        evaluationOutcome = data.frame( evaluationOutcomeWithAdmin )
      }else{
        evaluationOutcome = data.frame( evaluationOutcomeWithAdmin, evaluationOutcomeWithNoAdmin )
      }
    })

    return( evaluationOutcome )
  }) %>% flatten() %>% reduce( rbind ) %>% cbind( samplings, . ) %>% setNames( c( "time", outputNames ) )

  # filter sampling time
  samplingTimes = prop( arm, "samplingTimes" )
  samplings = map( samplingTimes, ~ prop( .x, "samplings" ) ) %>% set_names( outputNames )

  evaluationModel = list()
  for ( outputName in outputNames )
  {
    time = evaluationModelTmp$time %in% samplings[[outputName]]
    evaluationModel[[outputName]] = evaluationModelTmp[ time , c( "time", outputName ) ]
  }

  return( evaluationModel )
}

# ==============================================================================
#' @rdname definePKModel
#' @name definePKModel
#' @export
# ==============================================================================

method( definePKModel, list( ModelAnalyticSteadyState, PFIMProject ) ) = function( pkModel, pfimproject ) {
  pkModelEquations = prop( pkModel, "modelEquations")
  return( pkModelEquations )
}

# ==============================================================================
#' @rdname definePKPDModel
#' @name definePKPDModel
#' @export
# ==============================================================================

method( definePKPDModel, list( ModelAnalyticSteadyState, ModelAnalytic, PFIMProject ) ) = function( pkModel, pdModel, pfimproject ) {
  pkModelEquations = prop( pkModel, "modelEquations")
  pdModelEquations = prop( pdModel, "modelEquations")
  equations = c( pkModelEquations, pdModelEquations )
  return( equations )
}

# ==============================================================================
#' @rdname definePKPDModel
#' @name definePKPDModel
#' @export
# ==============================================================================

method( definePKPDModel, list( ModelAnalyticSteadyState, class_any, PFIMProject ) ) = function( pkModel, pdModel, pfimproject ) {

  # PKPD model equations
  pkModelEquations = convertPKModelAnalyticToPKModelODE( pkModel )
  pdModelEquations = prop( pdModel, "modelEquations")
  equations = c( pkModelEquations, pdModelEquations )

  # get the initial conditions to get variable names
  designs = prop( evaluation, "designs" )
  variablesNames = designs %>% map(~ map( prop(.x,"arms"), ~ prop(.x,"initialConditions"))) %>% unlist() %>% names() %>% unique()
  variablesNamesToChange =  c("RespPK", "E")

  # modify variable names in the model equations
  equations = equations %>% imap( ~ reduce2( variablesNamesToChange, variablesNames, replaceVariablesLibraryOfModels, .init = .x ) ) %>% set_names( paste0( "Deriv_", variablesNames ) )
  return( equations )
}
