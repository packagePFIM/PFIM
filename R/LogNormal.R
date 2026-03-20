#' @title LogNormal Class
#' @name LogNormal
#' @description The class \code{LogNormal} implements the LogNormal distribution.
#' @inheritParams Distribution
#' @include Distribution.R
#' @examples
#' # Set a Log-Normal distribution for a population parameter
#' distribution = LogNormal(mu = 0.74, omega = 0.316)
#' print(distribution)
#' @template copyright
#' @export

LogNormal = new_class( "LogNormal", package = "PFIM", parent = Distribution )

#' @title Adjust the gradient for the log normal distribution.
#' @name adjustGradient
#' @param distribution An object \code{Distribution} giving the distribution.
#' @param gradient The gradient of the model responses.
#' @return The adjusted gradient of the model responses.
#' @export

method( adjustGradient, LogNormal ) = function( distribution, gradient ) {
  gradient = gradient * prop( distribution, "mu" )
  return( gradient ) }
