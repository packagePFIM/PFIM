#' @title Proportional Class
#' @name Proportional
#' @description
#' The \code{Proportional} class defines a proportional residual error model,
#' where the standard deviation of the error is proportional to the
#' predicted value.
#' @slot output \code{character}. The name of the model output (e.g., "RespPK").
#' @slot sigmaSlope \code{numeric}. The proportional error component (slope).
#' @slot sigmaSlopeFixed \code{logical}. If \code{TRUE}, the slope is fixed.
#' @param output A string specifying the name of the model output (e.g., "RespPK").
#' @param equation An \code{expression} defining the error model relationship.
#' @param derivatives A \code{list} containing the analytic derivatives of the error equation.
#' @param sigmaInter A \code{numeric} specifying the additive error component (intercept).
#' @param sigmaSlope A \code{numeric} specifying the proportional error component (slope).
#' @param sigmaInterFixed A \code{logical} indicating if the intercept parameter is fixed.
#' @param sigmaSlopeFixed A \code{logical} indicating if the slope parameter is fixed.
#' @param cError A \code{numeric} representing the power parameter (typically 1.0).
#' @return An object of class \code{Proportional}.
#' @include ModelError.R
#' @examples
#' # Define a proportional error model for a PK output "RespPK"
#' errorModelRespPK = Proportional(
#'   output     = "RespPK",
#'   sigmaSlope = 0.10
#' )
#'
#' # Display the proportional error model summary
#' print(errorModelRespPK)
#' @template copyright
#' @export

Proportional = new_class("Proportional", package = "PFIM", parent = ModelError,
                         properties = list(
                           output = new_property(class_character, default = character(0)),
                           equation = new_property(class_expression, default = expression(sigmaSlope)),
                           derivatives = new_property(class_list, default = list()),
                           sigmaInter = new_property(class_double, default = 0.0),
                           sigmaSlope = new_property(class_double, default = 0.0),
                           sigmaInterFixed = new_property(class_logical, default = FALSE),
                           sigmaSlopeFixed = new_property(class_logical, default = FALSE),
                           cError = new_property(class_double, default = 1.0)
                         ),
                         constructor = function(output = character(0),
                                                equation = expression(sigmaSlope),
                                                derivatives = list(),
                                                sigmaInter = 0.0,
                                                sigmaSlope = 0.0,
                                                sigmaInterFixed = FALSE,
                                                sigmaSlopeFixed = FALSE,
                                                cError = 1.0) {
                           new_object(.parent = ModelError,
                                      output = output,
                                      equation = equation,
                                      derivatives = derivatives,
                                      sigmaInter = sigmaInter,
                                      sigmaSlope = sigmaSlope,
                                      sigmaInterFixed = sigmaInterFixed,
                                      sigmaSlopeFixed = sigmaSlopeFixed,
                                      cError = cError)
                         })
