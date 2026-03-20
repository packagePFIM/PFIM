#' @title AdministrationConstraints Class
#' @name AdministrationConstraints
#'
#' @description
#' The \code{AdministrationConstraints} class defines the space of admissible doses
#' for a specific model outcome. It is used by optimization algorithms to restrict
#' dosage inputs to a set of discrete candidate values.
#'
#' @slot outcome \code{character}. The name of the model output (e.g., "PK").
#' @slot doses \code{numeric vector}. A vector of authorized dose levels (discrete candidates).
#'
#' @param outcome A string identifying the target outcome for these constraints.
#' @param doses A numeric vector containing the candidate dose values.
#' @return An object of class \code{AdministrationConstraints}.
#'
#' @examples
#' # Define discrete dose candidates for a PK model outcome
#' administrationConstraintsRespK = AdministrationConstraints(
#'  outcome = "RespPK",
#'  doses   = list(0.2, 0.64, 2, 6.24, 11.24, 20) )
#' print( administrationConstraintsRespK )
#'
#' @template copyright
#' @export

AdministrationConstraints = new_class( "AdministrationConstraints",
                                       package = "PFIM",
                                       properties = list(
                                         outcome = new_property(class_character, default = character(0)),
                                         doses = new_property(class_list, default = list())
                                       ))
