#' @title ModelError Class
#' @name ModelError
#' @description The class \code{ModelError} is used to defined a model error.
#' @param output A string giving the model error output.
#' @param equation A expression giving the model error equation.
#' @param derivatives A list giving the derivatives of the model error equation.
#' @param sigmaInter A double giving the sigma inter.
#' @param sigmaSlope A double giving the sigma slope
#' @param sigmaInterFixed A boolean giving if the  sigma inter is fixed or not.
#' @param sigmaSlopeFixed A boolean giving if the  sigma slope is fixed or not.
#' @param cError A integer giving the power parameter.
#' @examples
#' # 1. Define an additive error model
#' # sigmaInter: intercept (additive), sigmaSlope: slope (proportional)
#' additiveError = ModelError(
#'   output     = "RespPK",
#'   sigmaInter = 0.1,
#'   sigmaSlope = 0.0
#' )
#' print(additiveError)
#'
#' # 2. Define a combined error model (Additive + Proportional)
#' combinedError = ModelError(
#'   output     = "RespPK",
#'   sigmaInter = 0.05,
#'   sigmaSlope = 0.15
#' )
#' print(combinedError)
#' @template copyright
#' @export

ModelError = new_class("ModelError", package = "PFIM",
                       properties = list(
                         output = new_property(class_character, default = "output"),
                         equation = new_property(class_expression, default = expression()),
                         derivatives = new_property(class_list, default = list()),
                         sigmaInter = new_property(class_double, default = 0.1),
                         sigmaSlope = new_property(class_double, default = 0.0),
                         sigmaInterFixed = new_property(class_logical, default = FALSE),
                         sigmaSlopeFixed = new_property(class_logical, default = FALSE),
                         cError = new_property(class_double, default = 1.0)
                       ),
                       constructor = function(output = "output",
                                              equation = expression(),
                                              derivatives = list(),
                                              sigmaInter = 0.1,
                                              sigmaSlope = 0.0,
                                              sigmaInterFixed = FALSE,
                                              sigmaSlopeFixed = FALSE,
                                              cError = 1.0) {
                         new_object(
                           output = output,
                           equation = equation,
                           derivatives = derivatives,
                           sigmaInter = sigmaInter,
                           sigmaSlope = sigmaSlope,
                           sigmaInterFixed = sigmaInterFixed,
                           sigmaSlopeFixed = sigmaSlopeFixed,
                           cError = cError,
                           .parent = environment()
                         )
                       })

evaluateErrorModelDerivatives = new_generic( "evaluateErrorModelDerivatives", c( "modelError" ) )
getModelErrorData = new_generic( "getModelErrorData", c( "modelError" ) )

# ==============================================================================
#' @title evaluate the derivatives of the model error.
#' @name evaluateErrorModelDerivatives
#' @param modelError An object \code{ModelError} that defines the model error.
#' @param evaluationModel A dataframe giving the outputs for the model evaluation.
#' @return The matrices sigmaDerivatives and errorVariance.
#' @template copyright
#' @export
# ==============================================================================

method( evaluateErrorModelDerivatives, ModelError ) = function( modelError, evaluationModel ) {

  sigmaInter = prop( modelError, "sigmaInter" )
  sigmaSlope = prop( modelError, "sigmaSlope" )

  equation = expression( ( sigmaInter + sigmaSlope * evaluationModel ) ** 2 )
  identityMatrix = diag( length( evaluationModel ) )

  modelErroParameterConditions = list(
    list( name = "sigmaInter", value = prop( modelError, "sigmaInter" ), fixed = prop( modelError, "sigmaInterFixed" ) ),
    list( name = "sigmaSlope", value = prop( modelError, "sigmaSlope" ), fixed = prop( modelError, "sigmaSlopeFixed" ) ) )

  sigmaDerivatives = modelErroParameterConditions %>%
    keep( ~ .x$value != 0 && ! .x$fixed ) %>%
    map(~ {
      sigmaDerivatives = eval( D( equation, .x$name ) ) * identityMatrix
      setNames( list(sigmaDerivatives ), .x$name )
    }) %>% flatten()

  errorVariance = ( sigmaInter + sigmaSlope * evaluationModel )**2 * identityMatrix

  return( list( sigmaDerivatives = sigmaDerivatives, errorVariance = errorVariance ) )
}

# ==============================================================================
#' @title get the parameters sigma slope and sigma inter (used for the report).
#' @name getModelErrorData
#' @param modelError An object \code{ModelError} that defines the model error.
#' @return A list of dataframe with outcome, type of model error and sigma slope and inter.
#' @template copyright
#' @export
# ==============================================================================

method( getModelErrorData, ModelError ) = function( modelError ) {
  modelErrorData = list(modelError) %>%
    map(function( model ) {
      list(
        outcome = prop( model, "output" ),
        type = str_remove(class(model)[1], "PFIM::"),
        sigmaSlope = as.character(prop(model, "sigmaSlope")),
        sigmaInter = as.character(prop(model, "sigmaInter"))
      )
    }) %>% map(~ as.data.frame(.x, stringsAsFactors = FALSE)) %>% list_rbind()
  return( modelErrorData )
}
