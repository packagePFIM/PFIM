#' @title Model Class
#' @name Model
#' @description
#' The \code{Model} class represents and stores all information required to define
#' a structural model (PK, PD, or PKPD). This includes model parameters,
#' differential equations (ODEs), and the residual error model.
#' @param name A \code{character} vector specifying the name of the model.
#' @param modelParameters A \code{list} of objects defining the model parameters.
#' @param samplings A \code{numeric} vector specifying the planned sampling times.
#' @param modelEquations A \code{list} containing the system of equations (analytical or ODEs).
#' @param wrapper A \code{function} wrapper used to interface the model (defaults to \code{function() NULL}).
#' @param outputFormula A \code{list} of mathematical formulas for the model outputs.
#' @param outputNames A \code{character} vector defining the names of the output variables.
#' @param variableNames A \code{character} vector defining the names of the state variables.
#' @param outcomesWithAdministration A \code{character} vector specifying outcomes associated with drug administration.
#' @param outcomesWithNoAdministration A \code{character} vector specifying outcomes without drug administration.
#' @param modelError A \code{list} defining the residual error model structure.
#' @param odeSolverParameters A \code{list} of parameters for the ODE solver (e.g., \code{atol}, \code{rtol}).
#' @param parametersForComputingGradient A \code{list} of parameters required for numerical gradient computation.
#' @param initialConditions A \code{numeric} vector specifying the initial state of the system.
#' @param functionArguments A \code{character} vector of arguments required by the model function.
#' @param functionArgumentsSymbol A \code{list} of symbols representing the function arguments.
#' @template copyright
#' @export

Model = new_class("Model", package = "PFIM",

                  properties = list(
                    name = new_property(class_character, default = character(0)),
                    modelParameters = new_property(class_list, default = list()),
                    samplings = new_property(class_numeric, default = numeric(0)),
                    modelEquations = new_property(class_list, default = list()),
                    wrapper = new_property(class_function, default = NULL ),
                    outputFormula = new_property(class_list, default = list()),
                    outputNames = new_property(class_character, default = character(0)),
                    variableNames = new_property(class_character, default = character(0)),
                    outcomesWithAdministration = new_property(class_character, default = character(0)),
                    outcomesWithNoAdministration = new_property(class_character, default = character(0)),
                    modelError = new_property(class_list, default = list()),
                    odeSolverParameters = new_property(class_list, default = list()),
                    parametersForComputingGradient = new_property(class_list, default = list()),
                    initialConditions = new_property(class_double, default = numeric(0)),
                    functionArguments = new_property(class_character, default = character(0)),
                    functionArgumentsSymbol = new_property(class_list, default = list())
                  ) )

defineModelWrapper = new_generic( "defineModelWrapper", c( "model" ) )
defineModelAdministration = new_generic( "defineModelAdministration", c( "model" ) )
evaluateModel = new_generic( "evaluateModel", c( "model" ) )
evaluateModelGradient = new_generic( "evaluateModelGradient", c( "model" ) )
evaluateModelVariance = new_generic( "evaluateModelVariance", c( "model"  ) )
evaluateInitialConditions = new_generic( "evaluateInitialConditions", c( "model"  ) )
finiteDifferenceHessian = new_generic( "finiteDifferenceHessian", c( "model" ) )
definePKModel = new_generic( "definePKModel", c( "pkModel", "pfimproject") )
definePKPDModel = new_generic( "definePKPDModel", c("pkModel", "pdModel", "pfimproject"))

# ==============================================================================
#' @title Compute the Hessian
#' @name finiteDifferenceHessian
#' @description
#' Prepares the necessary parameters and data structures for the computation of
#' gradients and the Hessian matrix via the finite difference method. This includes
#' calculating inverse column scales (\code{XcolsInv}), shifted parameter values,
#' and step size fractions.
#' @param model An object of class \code{\link{Model}} containing the structural
#' and error model definitions.
#' @return Returns the \code{Model} object with the updated slot
#' \code{parametersForComputingGradient}, now containing:
#' \itemize{
#'   \item \code{XcolsInv}: The inverse of the column scaling factors.
#'   \item \code{shifted}: The perturbed parameter values for finite differences.
#'   \item \code{frac}: The fractional step size used for the perturbations.
#' }
#' @template copyright
#' @export
# ==============================================================================

method( finiteDifferenceHessian, Model ) = function( model ) {

  pars = map( prop( model, "modelParameters" ), ~ {
    distribution = prop( .x, "distribution")
    mu = prop( distribution, "mu" )
  })%>% unlist() %>% as.numeric()
  minAbsPar = 0
  .relStep = .Machine$double.eps^(1/3)
  npar = length(pars)
  incr = pmax(abs(pars), minAbsPar) * .relStep
  baseInd = diag(npar)
  frac = c(1, incr, incr^2)
  cols = list(0, baseInd, -baseInd)

  for ( i in seq_along(pars)[ -npar ] ) {
    cols = c( cols, list( baseInd[ , i ] + baseInd[ , -(1:i) ] ) )
    frac = c( frac, incr[ i ] * incr[ -(1:i) ] ) }

  indMat = do.call( "cbind", cols )
  shifted = pars + incr * indMat
  indMat = t( indMat )
  Xcols = list( 1, indMat, indMat^2 )

  for ( i in seq_along(pars)[ - npar ] ) {
    Xcols = c( Xcols, list( indMat[ , i ] * indMat[ , -(1:i) ] ) ) }

  XcolsInv = solve( do.call( "cbind", Xcols ) )
  prop( model, 'parametersForComputingGradient' ) = list( XcolsInv = XcolsInv, shifted = shifted, frac = frac )
  return( model )
}

# ==============================================================================
#' @title Evaluate Model Variance and Sigma Derivatives
#' @name evaluateModelVariance
#' @description
#' Evaluates the residual error variance of the model and computes the
#' partial derivatives with respect to the variance parameters (\eqn{\sigma}).
#' @param model An object of class \code{\link{Model}} defining the structural
#' and residual error models.
#' @param arm An object of class \code{\link{Arm}} defining the design (sampling
#' times and doses) for a specific group.
#' @return A \code{list} containing:
#' \itemize{
#'   \item \code{errorVariance}: A numeric vector or matrix representing the
#'   evaluated residual variance.
#'   \item \code{sigmaDerivatives}: The derivatives of the variance with
#'   respect to the \eqn{\sigma} parameters.
#' }
#' @template copyright
#' @export
# ==============================================================================

method( evaluateModelVariance, Model ) = function( model, arm ) {

  modelErrors = prop( model, "modelError")
  evaluationModel = prop( arm, "evaluationModel")
  samplings = prop( model, "samplings" )
  outputNames = prop( model, "outputNames")

  # model derivatives
  evaluateErrorModelDerivatives = map( modelErrors, ~ {
    outcome = prop( .x, "output" )
    if ( outcome %in% outputNames ) {
      evaluateErrorModelDerivatives( .x, evaluationModel[[outcome]][,outcome] )
    } }) %>% compact() %>% set_names( outputNames )

  # compute error variance
  errorVariance = map( evaluateErrorModelDerivatives, ~{ bdiag( .x$errorVariance ) } ) %>% bdiag()

  # sigmaDerivatives
  totalNumberOfSamplings = map_int( evaluationModel, ~length( .x[["time"]] ) ) %>% sum()

  sigmaDerivatives = list()
  iter = 1
  for ( outputName in outputNames )
  {
    samplings = evaluationModel[[outputName]][["time"]]
    for( evaluateErrorModelDerivative in evaluateErrorModelDerivatives[[outputName]]$sigmaDerivatives )
    {
      sigmaDerivativesMatrix = matrix( 0, ncol = totalNumberOfSamplings, nrow = totalNumberOfSamplings )

      range = iter:( iter + length( samplings ) - 1 )
      sigmaDerivativesMatrix[ range, range ] = evaluateErrorModelDerivative
      sigmaDerivatives = c( sigmaDerivatives, list( sigmaDerivativesMatrix ) )
    }
    iter = iter + length( samplings )
  }
  return( list( errorVariance = errorVariance, sigmaDerivatives = sigmaDerivatives ) )
}

# ==============================================================================
#' @title evaluate the gradient of the model
#' @name evaluateModelGradient
#' @description
#' Computes the numerical gradient of the model response with respect to the
#' structural parameters using the finite difference method.
#' @param model An object \code{Model} that defines the model.
#' @param arm A object \code{Arm} giving the arm
#' @return A data frame that contains the gradient of the model.
#' @template copyright
#' @export
# ==============================================================================

method( evaluateModelGradient, Model ) = function( model, arm ) {

  # parameters
  parameters = prop( model, "modelParameters" )
  parameterNames = map( parameters, ~ prop( .x, "name") ) %>% unlist()
  outputNames = prop( model, "outputNames")

  # parameters for computing the gradients
  parametersForComputingGradient = prop( model, "parametersForComputingGradient" )
  XcolsInv = parametersForComputingGradient$XcolsInv
  shiftedParameters = parametersForComputingGradient$shifted
  frac = parametersForComputingGradient$frac

  # evaluation for gradients computing
  evaluationModel = map( seq( ncol( shiftedParameters ) ), function( iter ) {
    parameters = map2( parameters, shiftedParameters[,iter], function( parameter, newMu ) {
      distribution = prop( parameter, "distribution" )
      prop( distribution, "mu" ) = newMu
      prop( parameter, "distribution" ) = distribution
      return( parameter )
    })
    #  evaluate model with updated parameter
    prop( model, "modelParameters" ) = parameters
    model = defineModelAdministration( model, arm )
    evaluateModel( model, arm )
  })

  # evaluate the gradients
  evaluationGradients = map( outputNames, function( outputName ) {
    output = map( evaluationModel, function( evaluation ) {
      evaluation[[outputName]][, 2] }) %>% as.data.frame() %>% t(.)
  })

  gradients = map( evaluationGradients, function( evaluationGradient ) {
    gradients = XcolsInv %*% evaluationGradient / frac
    gradients = t( gradients )[, 2:( 1 + length( parameters ) ) ]
    gradients = as.data.frame( matrix( gradients, ncol = length( parameters ) ) )
    colnames( gradients ) = parameterNames
    return( gradients)
  } ) %>% setNames( outputNames )

  return( gradients )
}

# ==============================================================================
#' @title: replace variable in the LibraryOfModels
#' @name replaceVariablesLibraryOfModels
#' @description
#' A utility function designed to rename or replace variable names within
#' model strings (e.g., library equations). It ensures safe replacement
#' by protecting reserved mathematical terms and keywords.
#' @param text the text
#' @param old old string
#' @param new new string
#' @return text with new string
#' @template copyright
#' @export
# ==============================================================================

replaceVariablesLibraryOfModels = function(text, old, new) {
  protected_terms = c("dose_", "Tinf_", "Emax")
  if(any(str_detect(old, fixed(protected_terms)))) {
    return(text)
  }
  protected_pattern = paste0("(?<!", paste0(protected_terms, collapse = "|"), ")")
  if(old == "RespPK") {
    str_replace_all(text, paste0(protected_pattern, old, "\\b"), new)
  } else {
    str_replace_all(text, regex(paste0("\\b", old, "\\b")), new)
  }
}
