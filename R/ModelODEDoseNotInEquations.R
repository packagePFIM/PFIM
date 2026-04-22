# ==============================================================================
# ==============================================================================
#' @title ModelODEDoseNotInEquations Class
#' @name ModelODEDoseNotInEquations
#' @description
#' The \code{ModelODEDoseNotInEquations} class defines an ODE-based model where
#' doses are handled as discrete events rather than continuous functions within
#' the equations. This is typically used for bolus administrations where the
#' dose results in an instantaneous change in state variables.
#' @inheritParams ModelODE
#' @param modelODE An object of class \code{modelODE} defining the structural
#' differential equations.
#' @param doseEvent A \code{data.frame} containing the event schedule (time,
#' dose amount, compartment index) required by the ODE solver.
#' @param solverInputs A \code{list} providing specific configurations for the
#' numerical integrator, such as event-handling logic.
#' @include Model.R
#' @template copyright
#' @export

ModelODEDoseNotInEquations = new_class( "ModelODEDoseNotInEquations",
                                        package = "PFIM",
                                        parent = ModelODE,
                                        properties = list(
                                          modelODE = new_property(class_function, default = NULL ),
                                          doseEvent = new_property(class_list, default = list()),
                                          solverInputs = new_property(class_list, default = list())
                                        ))

# ==============================================================================
#' @rdname defineModelWrapper
#' @name defineModelWrapper
#' @export
# ==============================================================================

method( defineModelWrapper, ModelODEDoseNotInEquations ) = function( model, evaluation ) {

  # names of the equations and the variables
  equations = prop( evaluation, "modelEquations" )
  variableNames = str_remove( names( equations ), "Deriv_" )
  variableNamesDerivatives = paste( names( equations ), collapse = ", " )

  # outcomes with administration
  outcomes = evaluation %>%
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

  outputs = prop( evaluation, "outputs")
  prop( model, "outputFormula") = outputs
  prop( model, "outputNames") = names( outputs )
  prop( model, "wrapper" ) = eval( parse( text = functionDefinition ) )
  prop( model, "functionArguments" ) = functionArguments
  prop( model, "functionArgumentsSymbol" ) = functionArgumentsSymbol

  return( model )
}

# ==============================================================================
#' @rdname defineModelAdministration
#' @name defineModelAdministration
#' @export
# ==============================================================================

method( defineModelAdministration, ModelODEDoseNotInEquations ) = function( model, arm ) {

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

  # dose event: variable as compartment
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
    data.frame( var = rep( outcome, length( timeDose ) ), time = timeDose, value = dose, method = c( "add" ) )
  }) %>%
    reduce( rbind ) %>%
    .[ order( .$time ), ]

  # evaluate the initial conditions
  initialConditions = evaluateInitialConditions( model, arm )

  # Assign the values to variables in the current environment
  mu = set_names(
    map(parameters, ~ .x@distribution@mu),
    map(parameters, ~ .x@name)
  )

  list2env( mu, envir = environment() )

  # Compartments administered (must be in y for deSolve events to work)
  # Initialize them to 0; the dose at t=0 is added via doseEvent (method="add")
  initialConditionsAdmin = setNames(
    rep(0, length(unique(doseEvent$var))),
    unique(doseEvent$var)
  )

  # User-provided initial conditions override/supplement
  # Only keep admin compartments NOT already in user initialConditions
  missingAdmin = initialConditionsAdmin[ !names(initialConditionsAdmin) %in% names(initialConditions) ]

  initialConditions = c( missingAdmin, initialConditions )



  # function evaluation model
  modelODEDoseAsCmpt = function( samplingTimes, initialConditions, parameters )
  {
    with( as.list( c(  samplingTimes, initialConditions, parameters ) ),{

      # evaluate wrapper and  model outputs
      evaluationModel = do.call( wrapper, setNames( functionArgumentsSymbols, functionArguments ) )
      evaluationOutputs  = map( outputFormula, ~ eval( .x ) )

      return( c( evaluationModel , evaluationOutputs ) )
    })}

  # set the model
  prop( model, "initialConditions" ) = initialConditions
  prop( model, "samplings" ) = samplings
  prop( model, "modelODE" ) = modelODEDoseAsCmpt
  prop( model, "doseEvent" ) = doseEvent

  return( model )
}

# ==============================================================================
#' @rdname evaluateModel
#' @name evaluateModel
#' @export
# ==============================================================================

method( evaluateModel, ModelODEDoseNotInEquations ) = function( model, arm ) {

  initialConditions = prop( model, "initialConditions" )
  samplings = prop( model, "samplings" )
  modelODE = prop( model, "modelODE" )
  parameters = NULL
  odeSolverParameters = prop( model, "odeSolverParameters" )
  atol = odeSolverParameters$atol
  rtol = odeSolverParameters$rtol
  doseEvent = prop( model, "doseEvent" )
  outputNames = prop( model, "outputNames" )
  samplingTimes = prop( arm, "samplingTimes" )

  # model evaluation
  evaluationModelTmp = ode( initialConditions, samplings, modelODE, parameters, events = list( data = doseEvent ), atol = atol, rtol = rtol )
  evaluationModelTmp = evaluationModelTmp %>% data.frame()

  # filter sampling time
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

method( definePKModel, list( ModelODEDoseNotInEquations, PFIMProject ) ) = function( pkModel, pfimproject ) {
  pkModelEquations = prop( pkModel, "modelEquations")
  return( pkModelEquations )
}
