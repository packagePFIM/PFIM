#' @title Administration Class
#' @name Administration
#'
#' @description
#' The \code{Administration} class defines the dosing regimen for a specific
#' model outcome. It stores comprehensive information regarding dose amounts,
#' administration timings, infusion durations, and dosing intervals (tau).
#'
#' @slot outcome \code{character}. The name of the model output (e.g., "PK").
#' @slot timeDose \code{numeric vector}. The time points at which doses are administered.
#' @slot dose \code{numeric vector}. The amount of drug administered at each time point.
#' @slot Tinf \code{numeric vector}. The duration of the infusion (defaults to 0 for bolus).
#' @slot tau \code{numeric}. The dosing interval for repeated doses or steady-state calculations.
#'
#' @param outcome A string identifying the target outcome for the administration.
#' @param timeDose A numeric vector of dosing times.
#' @param dose A numeric vector of dose amounts.
#' @param Tinf A numeric vector specifying infusion durations.
#' @param tau A numeric value representing the dosing interval (for multiple doses).
#'
#' @return An object of class \code{Administration}.
#'
#' @examples
#'
#' # Example 1: Single bolus dose at time 0
#' administrationRespPK = Administration(
#'   outcome  = "RespPK",
#'   timeDose = 0,
#'   dose     = 0.2
#' )
#' print( administrationRespPK )
#'
#' # Example 2: Multiple doses at various times
#' administrationRespPK = Administration(
#'   outcome  = "RespPK",
#'   timeDose = c(0, 10, 20),
#'   dose     = c(0.1, 0.2, 0.3)
#' )
#' print( administrationRespPK )
#'
#' # Example 3: Multiple doses with a 2-hour infusion duration
#' administrationRespPK = Administration(
#'   outcome  = "RespPK",
#'   timeDose = c(0, 10, 20),
#'   dose     = c( 0.1, 0.2, 0.3),
#'   Tinf     = 2.0
#' )
#' print( administrationRespPK )
#'
#' # Example 4: Repeated dosing with a 5-hour interval (tau)
#' administrationRespPK = Administration(
#'   outcome = "RespPK",
#'   dose    = c(0.1, 0.2, 0.3),
#'   tau     = 5
#' )
#' print( administrationRespPK )
#'
#' @template copyright
#' @export

Administration = new_class("Administration",
                           package = "PFIM",
                           properties = list(
                             outcome = new_property(class_character, default = character(0)),
                             timeDose = new_property(class_double, default = numeric(0)),
                             dose = new_property(class_double, default = numeric(0)),
                             Tinf = new_property(class_double, default = numeric(0)),
                             tau = new_property(class_double, default = 0.0)
                           ))
