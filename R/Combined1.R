#' @title Combined1 Class
#' @name Combined
#'
#' @description
#' The \code{Combined1} class defines a combined residual error model, which
#' incorporates both an additive and a proportional component.
#'
#' @slot output \code{character}. The name of the model output (e.g., "Cc").
#' @slot sigmaInter \code{numeric}. The additive (intercept) error component.
#' @slot sigmaSlope \code{numeric}. The proportional (slope) error component.
#' @slot sigmaInterFixed \code{logical}. If \code{TRUE}, the intercept is fixed.
#' @slot sigmaSlopeFixed \code{logical}. If \code{TRUE}, the slope is fixed.
#'
#' @param output A string specifying the model error output name.
#' @param equation An expression representing the model error equation.
#' @param derivatives A list of derivatives for the model error equation.
#' @param sigmaInter A numeric value for the additive component (default 0).
#' @param sigmaSlope A numeric value for the proportional component (default 0).
#' @param sigmaInterFixed Logical; indicates if \code{sigmaInter} is fixed (default FALSE).
#' @param sigmaSlopeFixed Logical; indicates if \code{sigmaSlope} is fixed (default FALSE).
#' @param cError A numeric power parameter (default 1.0).
#'
#' @return An object of class \code{Combined1}.
#'
#' @include ModelError.R
#'
#' #' @examples
#'
#' # Define a Combined1 error model for a PK outcomes "RespPK"
#' # sigmaInter = 0.5 (additive), sigmaSlope = sqrt(0.15) (proportional)
#' errorModelRespk = Combined1(
#'   output     = "RespPK",
#'   sigmaInter = 0.5,
#'   sigmaSlope = sqrt(0.15)
#' )
#'
#' print(errorModelRespk)
#'
#' @template copyright
#' @export

Combined1 = new_class("Combined1", package = "PFIM", parent = ModelError,
                      properties = list(
                        output = new_property(class_character, default = character(0)),
                        equation = new_property(class_expression, default = expression(sigmaInter + sigmaSlope * output)),
                        derivatives = new_property(class_list, default = list()),
                        sigmaInter = new_property(class_double, default = 0.0),
                        sigmaSlope = new_property(class_double, default = 0.0),
                        sigmaInterFixed = new_property(class_logical, default = FALSE),
                        sigmaSlopeFixed = new_property(class_logical, default = FALSE),
                        cError = new_property(class_double, default = 1.0)
                      ),
                      constructor = function(output = character(0),
                                             equation = expression(sigmaInter + sigmaSlope * output),
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
