# Copyright (c) 2026-present Romain Leroux. All rights reserved.

#' @title ModelAnalytic Class
#' @name ModelAnalytic
#' @description The class \code{ModelAnalytic} is used to defined an analytic model.
#' @param wrapperModelAnalytic Wrapper for the ode solver.
#' @inheritParams Model
#' @param functionArgumentsModelAnalytic A list giving the functionArguments of the wrapper for the analytic model.
#' @param functionArgumentsSymbolModelAnalytic A list giving the functionArgumentsSymbol of the wrapper for the analytic model
#' @param solverInputs A list giving the solver inputs.
#' @include Model.R
#' @include ModelODE.R
#' @template copyright
#' @export

ModelAnalytic = new_class(
  "ModelAnalytic",
  package = "PFIM",
  parent = Model,

  properties = list(
    wrapperModelAnalytic = new_property(class_list, default = list()),
    functionArgumentsModelAnalytic = new_property(class_list, default = list()),
    functionArgumentsSymbolModelAnalytic = new_property(class_list, default = list()),
    solverInputs = new_property(class_list, default = list())
  ))

convertPKModelAnalyticToPKModelODE = new_generic( "convertPKModelAnalyticToPKModelODE", c( "pkModel" ) )

# ==============================================================================
#' @title define the model wrapper for the ode solver
#' @name defineModelWrapper
#' @param model An object of class \code{ModelAnalytic} that defines the model.
#' @param evaluation An object of class Evaluation that defines the evaluation
#' @return The model with wrapperModelAnalytic, functionArgumentsModelAnalytic, functionArgumentsSymbolModelAnalytic, outputNames, outcomesWithAdministration
#' @template copyright
#' @export
# ==============================================================================

method( defineModelWrapper, ModelAnalytic ) = function( model, evaluation ) {

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

  # names of the equations with admin and no admin
  equations = prop( evaluation, "modelEquations" )
  equationsWithAdmin = equations[ names( equations ) %in% outcomesWithAdministration ]
  equationsWithNoAdmin = equations[ !( names( equations ) %in% outcomesWithAdministration ) ]

  # output
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
  functionArgumentsWithAdmin = unique( c( doseNames, parameterNames, timeNames ) )
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
  functionArgumentsWithNoAdmin = unique( c( outcomesWithAdministration, parameterNames, timeNames ) )
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
#' @title Define the administration for an analytic model
#' @name defineModelAdministration
#' @param model An object of class \code{ModelAnalytic} that defines the model.
#' @param arm An object of class \code{Arm} that defines the arm.
#' @return The model with samplings, solverInputs
#' @template copyright
#' @export
# ==============================================================================

method( defineModelAdministration, ModelAnalytic ) = function( model, arm ) {

  # administrations and outcome
  administrations = prop( arm, "administrations" )
  outcomesWithAdministration =  prop( model, "outcomesWithAdministration" )
  # sampling times
  samplingTimes = prop( arm, "samplingTimes" )
  # define the samplings for all response
  samplings = map( samplingTimes, ~ prop( .x, "samplings" ) ) %>% unlist() %>% sort() %>% unique()
  # model outputs
  outputNames = prop( model, "outputNames" )
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

    # define the time doses
    timeDose = timeDose %>%
      map( ~ ifelse( samplings - .x > 0, samplings - .x, samplings ) ) %>%
      reduce( cbind )

    indicesDoses = if ( is.null( dim( timeDose ) ) ) {
      # dose unique
      indicesDoses = 1
    } else {
      # multi dose
      indicesDoses = map_int( seq_len( dim( timeDose )[1] ), ~{
        length( unique( timeDose[.x, ] ) )
      })
    }
    list( data = data.frame( timeDose, indicesDoses ), dose = dose )
  }) %>% setNames( outcomesWithAdministration )

  prop( model, "samplings" ) = samplings
  prop( model, "solverInputs" ) = solverInputs

  return( model )
}

# ==============================================================================
#' @title Evaluate the analytic model
#' @name evaluateModel
#' @param model An object of class \code{ModelAnalytic} that defines the model.
#' @param arm An object of class \code{Arm} that defines the arm.
#' @return A list of dataframes that contains the results for the evaluation of the model.
#' @template copyright
#' @export
# ==============================================================================

method( evaluateModel, ModelAnalytic ) = function( model, arm ) {

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
    map(parameters, ~ .x@distribution@mu),
    map(parameters, ~ .x@name)
  )

  list2env( mu, envir = environment() )

  # evaluate analytic model
  evaluationModelTmp = map( seq_along( samplings ), function( iterTime ) {

    evaluationOutcome = map( outcomesWithAdministration, function( outcomeWithAdministration ) {

      data = solverInputs[[outcomeWithAdministration]]$data
      dose = solverInputs[[outcomeWithAdministration]]$dose

      indicesDoses = data$indicesDoses[iterTime]
      time = data[iterTime, 1:indicesDoses]
      doses = dose[1:indicesDoses]

      evaluationOutcomeWithAdmin = sum( map_dbl( seq_len( indicesDoses ), function( indiceDose ) {

        assign( paste0( "t_", outcomeWithAdministration ), time[indiceDose] )
        assign( paste0( "dose_", outcomeWithAdministration ), doses[indiceDose] )

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
#' @title Conversion from analytic PK model to ODE PK model
#' @name convertPKModelAnalyticToPKModelODE
#' @param pkModel An object of class \code{ModelAnalytic} that defines the model.
#' @return A character string containing the ODE equation derived from the analytic expression.
#' @template copyright
#' @export
# ==============================================================================

method( convertPKModelAnalyticToPKModelODE, ModelAnalytic ) = function( pkModel  ) {

  pkModelEquations = prop( pkModel, "modelEquations")
  dtEquationPKsubstitute = D( parse( text = pkModelEquations ), "t" )
  dtEquationPKsubstitute = str_c( deparse( dtEquationPKsubstitute ), collapse = "" )
  pkModelEquations =  pluck( pkModelEquations, 1 )

  if ( str_detect( pkModelEquations, "Cl" ) )
  {
    pkModelEquations = str_c( dtEquationPKsubstitute, "+(Cl/V)*", pkModelEquations, "- (Cl/V)*RespPK" )
  } else {
    pkModelEquations = str_c( dtEquationPKsubstitute, "+k*", pkModelEquations, "- k*RespPK" )
  }
  pkModelEquations = str_replace_all( pkModelEquations, " ", "" )
  pkModelEquations = paste( Simplify( pkModelEquations ) )

  return( pkModelEquations )
}

# ==============================================================================
#' @title Define a PK model from library of model
#' @name definePKModel
#' @param pkModel An object of class \code{ModelAnalytic} that defines the PK model.
#' @param pfimproject An object of class \code{PFIMProject} that defines the pfimproject.
#' @template copyright
#' @export
# ==============================================================================

method( definePKModel, list( ModelAnalytic, PFIMProject ) ) = function( pkModel, pfimproject ) {
  pkModelEquations = prop( pkModel, "modelEquations")
  return( pkModelEquations )
}

# ==============================================================================
#' @title Define a PKPD model from library of model
#' @name definePKPDModel
#' @param pkModel An object of class \code{ModelAnalytic} that defines the PK model.
#' @param pdModel An object of class \code{ModelAnalytic} that defines the PD model.
#' @param pfimproject An object of class \code{PFIMProject} that defines the pfimproject.
#' @template copyright
#' @export
# ==============================================================================

method( definePKPDModel, list( ModelAnalytic, ModelAnalytic, PFIMProject ) ) = function( pkModel, pdModel, pfimproject ) {
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

method( definePKPDModel, list( ModelAnalytic, class_any, PFIMProject ) ) = function( pkModel, pdModel, pfimproject ) {

  # PKPD model equations
  pkModelEquations = convertPKModelAnalyticToPKModelODE( pkModel )
  pdModelEquations = prop( pdModel, "modelEquations")
  equations = c( pkModelEquations, pdModelEquations )

  # get the initial conditions to get variable names
  designs = prop( pfimproject, "designs" )
  variablesNames = designs %>% map(~ map( prop(.x,"arms"), ~ prop(.x,"initialConditions"))) %>% unlist() %>% names() %>% unique()
  variablesNamesToChange =  c("RespPK", "E")

  # modify variable names in the model equations
  equations = equations %>% imap( ~ reduce2( variablesNamesToChange, variablesNames, replaceVariablesLibraryOfModels, .init = .x ) ) %>% set_names( paste0( "Deriv_", variablesNames ) )

  return( equations )
}
