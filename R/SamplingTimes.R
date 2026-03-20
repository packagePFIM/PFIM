#' @title SamplingTimes Class
#' @name SamplingTimes
#' @description
#' The \code{SamplingTimes} class defines the specific time points at which
#' observations are collected for a given model outcome. In multi-response
#' models, this class allows each outcome (e.g., PK and PD) to have its own
#' independent sampling schedule.
#' @slot outcome \code{character}. The name of the model output (e.g., "RespPK").
#' @slot samplings \code{numeric vector}. The sequence of observation time points.
#' @param outcome A \code{string} specifying the name of the model output
#' (e.g., "RespPK", "Metabolite").
#' @param samplings A \code{numeric vector} representing the sampling schedule.
#' @return An object of class \code{SamplingTimes}.
#' @examples
#' # Define a PK sampling schedule
#' samplingTimesRespPK = SamplingTimes(
#'   outcome   = "RespPK",
#'   samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4)
#' )
#'
#' # Display the sampling schedule summary
#' print(samplingTimesRespPK)
#' @template copyright
#' @export

SamplingTimes = new_class("SamplingTimes",
                          package = "PFIM",
                          properties = list(
                            outcome = new_property(class_character, default = character(0)),
                            samplings = new_property(class_double, default = numeric(0))
                          ))
