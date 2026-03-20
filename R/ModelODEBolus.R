# ==============================================================================
# ==============================================================================
# ==============================================================================
#' @title ModelODEBolus Class
#' @name ModelODEBolus
#' @description The class \code{ModelODEBolus} is used to defined a model ode admin bolus.
#' @inheritParams ModelODE
#' @param modelODE An object \code{modelODE}.
#' @param doseEvent A dataframge given the doseEvent for the ode solver.
#' @param solverInputs A list giving the solver inputs.
#' @include ModelODE.R
#' @template copyright
#' @export

ModelODEBolus = new_class( "ModelODEBolus",
                           package = "PFIM",
                           parent = ModelODE,
                           properties = list(
                             modelODE = new_property(class_function, default = NULL),
                             doseEvent = new_property(class_list, default = list()),
                             solverInputs = new_property(class_list, default = list())
                           ))

# ==============================================================================
#' @rdname defineModelWrapper
#' @name defineModelWrapper
#' @export
# ==============================================================================

method( defineModelWrapper, ModelODEBolus ) = function( model, evaluation ) {

  # names of the equations and the variables
  equations = prop( evaluation, "modelEquations" )
  variableNames = str_remove( names( equations ), "Deriv_" )
  variableNamesDerivatives = paste( names( equations ), collapse = ", " )

  # outcomes with administration
  outcomesWithAdministration = evaluation %>%
    pluck( "designs" ) %>%
    map( ~ pluck( .x, "arms" ) ) %>%
    unlist() %>%
    map( ~ pluck( .x, "administrations" ) ) %>%
    unlist()%>%
    map( ~ pluck( .x, "outcome" ) ) %>%
    unlist()

  # arguments for the function
  parameters = prop( evaluation, "modelParameters" )
  parameterNames = map_chr( parameters, "name" )

  functionArguments = c( parameterNames, variableNames, "t" )
  functionArguments = unique( functionArguments )
  functionArgumentsSymbol = map( functionArguments, ~ as.symbol(.x) )

  # create body function
  equationsBody = map_chr( names( equations ), ~ sprintf( "%s = %s", .x, equations[[.x]] ) )

  functionBody = paste( equationsBody, collapse = "\n" )
  functionBody = sprintf( paste( "%s\nreturn(list(c(", variableNamesDerivatives, ")))", collapse = ", " ), functionBody )
  functionDefinition = sprintf( "function(%s) { %s }", paste( functionArguments, collapse = ", " ), functionBody )

  # define the model
  outputs = prop( evaluation, "outputs")
  prop( model, "outputFormula") = outputs
  prop( model, "outputNames") = names( outputs )
  prop( model, "outcomesWithAdministration") = outcomesWithAdministration
  prop( model, "wrapper" ) = eval( parse( text = functionDefinition ) )
  prop( model, "functionArguments" ) = functionArguments
  prop( model, "functionArgumentsSymbol" ) = functionArgumentsSymbol

  return( model )
}

# ==============================================================================
#' @title evaluate the initial conditions.
#' @name evaluateInitialConditions
#' @param arm A object of class \code{Arm} giving the arm.
#' @param model A object of class \code{Model} giving the model.
#' @param doseEvent A data frame giving the dose event for the ode solver.
#' @template copyright
#' @export
# ==============================================================================

method( evaluateInitialConditions, ModelODEBolus ) = function( model, arm, doseEvent ) {

  # assign dose values
  outcomesWithAdministration =  prop( model, "outcomesWithAdministration" )
  doseNames = map( outcomesWithAdministration, ~ paste0( "dose_", .x ) )
  doseValues = as.list( doseEvent[doseEvent$time == 0, "value"] )

  if ( length( doseValues ) == 1 )
  {
    doses = set_names( doseValues[1], doseNames[1] )
  }
  else
  {
    doses = set_names( doseValues, doseNames )
  }

  list2env( doses, envir = environment() )

  # assign mu values of the parameters
  initialConditions = prop( arm, "initialConditions")
  parameters = prop( model, "modelParameters")

  mu = set_names(
    map( parameters, ~ {
      pluck(.x, "distribution", "mu")
    }),
    map( parameters, ~ prop( .x, "name") )
  )

  list2env( mu, envir = environment())

  # evaluate the initial conditions
  initialConditions = map( initialConditions, ~ {

    if ( is.numeric(.x) ) {
      return(.x)
    } else {
      eval( parse( text = .x ) )
    }
  })%>%unlist()

  return( initialConditions )
}

# ==============================================================================
#' @rdname defineModelAdministration
#' @name defineModelAdministration
#' @export
# ==============================================================================

method( defineModelAdministration, ModelODEBolus ) = function( model, arm ) {

  # administrations and samplings
  administrations = prop( arm, "administrations" )
  samplingTimes = prop( arm, "samplingTimes" )
  samplings = map( samplingTimes, ~ prop( .x, "samplings" ) ) %>% unlist()
  samplings = unique( c( 0.0, samplings ) )

  # model wrapper function
  wrapper = prop( model, "wrapper")

  # model parameters
  parameters = prop( model, "modelParameters" )

  # args for model evaluation
  functionArguments = prop( model, "functionArguments" )
  functionArgumentsSymbols = prop( model, "functionArgumentsSymbol" )

  # model outputs
  outputFormula = prop( model, "outputFormula" )
  outputFormula = map( outputFormula, ~ parse( text=.x ) )

  # dose event
  doseEvent = map( administrations, ~ {

    outcome = prop( .x, "outcome" )
    timeDose = prop( .x, "timeDose" )
    tau = prop( .x, "tau" )
    dose = prop( .x, "dose" )

    if ( tau !=0 )
    {
      timeDose = seq( 0, max( samplings ), tau )
      dose = rep( dose, length( timeDose ) )
    }

    data.frame(  var = rep( outcome, length( timeDose ) ) ,
                 time = timeDose,
                 value = dose,
                 method = ifelse( timeDose > 0, "add", "replace" ) )

  }) %>% reduce(rbind) %>% .[order(.$time), ]

  # evaluate the initial conditions
  initialConditions = evaluateInitialConditions( model, arm, doseEvent )

  # Assign the values to the parameters in the current environment
  mu = set_names(
    map(parameters, ~ .x@distribution@mu),
    map(parameters, ~ .x@name)
  )

  list2env( mu, envir = environment() )

  # update doseEvent with the initial conditions
  for ( iter in 1:dim( doseEvent )[1] )
  {
    initialConditionsTmp = prop( arm, "initialConditions")
    outcomeName = doseEvent$var[iter]
    doseName = paste0( "dose_", outcomeName )
    doseValue = doseEvent$value[iter]
    assign( doseName, doseValue )
    doseEvent$value[iter] = eval( parse ( text = initialConditionsTmp[[outcomeName]]))
  }

  # function evaluation model
  modelODEBolus = function( samplingTimes, initialConditions, parameters )
  {
    with( as.list( c(  samplingTimes, initialConditions, parameters ) ),{

      # evaluate wrapper
      evaluationModel = do.call( wrapper, setNames( functionArgumentsSymbols, functionArguments ) )

      # evaluate model outputs
      evaluationOutputs  = map( outputFormula, ~ eval( .x ) )

      return( c( evaluationModel , evaluationOutputs ) )
    })}

  prop( model, "initialConditions" ) = initialConditions
  prop( model, "samplings" ) = samplings
  prop( model, "modelODE" ) = modelODEBolus
  prop( model, "doseEvent" ) = doseEvent

  return( model )
}

# ==============================================================================
#' @rdname evaluateModel
#' @name evaluateModel
#' @export
# ==============================================================================

method( evaluateModel, ModelODEBolus ) = function( model, arm ) {

  initialConditions = prop( model, "initialConditions" )
  samplings = prop( model, "samplings" )
  modelODE = prop( model, "modelODE" )
  solverInputs = prop( model, "solverInputs" )
  odeSolverParameters = prop( model, "odeSolverParameters" )
  atol = odeSolverParameters$atol
  rtol = odeSolverParameters$rtol
  samplingTimes = prop( arm, "samplingTimes" )
  doseEvent = prop( model, "doseEvent" )
  outputNames = prop( model, "outputNames")
  parameters = prop( model, "modelParameters")

  evaluationModelTmp = ode( initialConditions, samplings, modelODE, parameters, events = list( data = doseEvent ), atol = atol, rtol = rtol )
  evaluationModelTmp = evaluationModelTmp %>% data.frame()

  # filter sampling time
  samplings = map( samplingTimes, ~ prop( .x, "samplings" ) ) %>% set_names( outputNames )

  evaluationModel = map(outputNames, ~ {
    time = evaluationModelTmp$time %in% samplings[[.x]]
    evaluationModelTmp[time, c("time", .x)]
  }) %>% setNames( outputNames )

  return( evaluationModel )
}

# ==============================================================================
#' @rdname definePKModel
#' @name definePKModel
#' @export
# ==============================================================================

method( definePKModel, list( ModelODEBolus, PFIMProject ) ) = function( pkModel, pfimproject ) {

  designs = prop( pfimproject, "designs" )
  variablesNames = designs %>% map(~ map( prop(.x,"arms"), ~ prop(.x,"initialConditions"))) %>% unlist() %>% names() %>% unique()
  variablesNamesToChange =  c("C1", "C2")

  pkModelEquations = prop( pkModel, "modelEquations") %>%
    imap(~reduce2(variablesNamesToChange, variablesNames, replaceVariablesLibraryOfModels, .init = .x)) %>%
    set_names( paste0("Deriv_",variablesNames ) )

  return( pkModelEquations )
}
