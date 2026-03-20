#' @title Distribution Class
#' @name Distribution
#'
#' @description
#' The \code{Distribution} class is an abstract base class used to represent
#' statistical distributions for model parameters.
#'
#' @slot name \code{character}. The name of the distribution (e.g., "Normal", "LogNormal").
#' @slot mu \code{numeric}. The mean value or fixed effect of the parameter.
#' @slot omega \code{numeric}. The standard deviation or variance of the random effect.
#'
#' @param name A string specifying the distribution type.
#' @param mu A double representing the fixed effect value.
#' @param omega A double representing the random effect intensity.
#'
#' @return An object of class \code{Distribution}.
#'
#' @template copyright
#' @export

Distribution = new_class("Distribution",
                         package = "PFIM",
                         properties = list(
                           name  = new_property(class_character, default = character(0)),
                           mu    = new_property(class_double,    default = 0.0),
                           omega = new_property(class_double,    default = 0.0)
                         ) )

adjustGradient = new_generic( "adjustGradient", c( "distribution" ) )

