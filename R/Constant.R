#' @title Constant  Class
#' @name Constant
#'
#' @description
#' The \code{Constant} class defines an additive residual error model, where
#' the standard deviation (SD) of the error remains constant.
#'
#' @slot output \code{character}. The name of the model output.
#' @slot sigmaInter \code{numeric}. The additive residual error value.
#' @slot sigmaInterFixed \code{logical}. If \code{TRUE}, \code{sigmaInter} is not estimated.
#'
#' @param output A string specifying the name of the model output.
#' @param equation An expression representing the model error equation.
#' @param derivatives A list of derivatives for the model error equation.
#' @param sigmaInter A numeric value for the constant residual error component.
#' @param sigmaSlope A numeric value for the slope (defaulted to 0.0 for this model).
#' @param sigmaInterFixed Logical; indicates if \code{sigmaInter} is fixed (default FALSE).
#' @param sigmaSlopeFixed Logical; indicates if \code{sigmaSlope} is fixed (default FALSE).
#' @param cError A numeric power parameter (default 1.0).
#'
#' @return An object of class \code{Constant}.
#'
#' @include ModelError.R
#'
#'  @examples
#'
#' # Define a constant (additive) error model for a PK outcome "RespPK"
#' errorModelConstantRespPK = Constant(
#'   output     = "RespPK",
#'   sigmaInter = 1.0
#' )
#' print( errorModelConstantRespPK)
#'
#' @template copyright
#' @export

Constant = new_class("Constant", package = "PFIM", parent = ModelError,
                     properties = list(
                       output = new_property(class_character, default = character(0)),
                       equation = new_property(class_expression, default = expression(sigmaInter)),
                       derivatives = new_property(class_list, default = list()),
                       sigmaInter = new_property(class_double, default = 0.0),
                       sigmaSlope = new_property(class_double, default = 0.0),
                       sigmaInterFixed = new_property(class_logical, default = FALSE),
                       sigmaSlopeFixed = new_property(class_logical, default = FALSE),
                       cError = new_property(class_double, default = 1.0)
                     ),
                     constructor = function(output = character(0),
                                            equation = expression(sigmaInter),
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
