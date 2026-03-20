#' @title Normal Class
#' @name Normal
#' @description The class \code{Normal} implements the Normal distribution.
#' @inheritParams Distribution
#' @include Distribution.R
#' @examples
#' # Set the Normal distribution for a parameter
#' normalDistribution = Normal(
#'   mu    = 0.74,
#'   omega = 0.316
#' )
#' # Display distribution summary
#' print(normalDistribution)
#' @template copyright
#' @export

Normal = new_class( "Normal", package = "PFIM", parent = Distribution )

method( adjustGradient, Normal ) = function( distribution, gradient ) { return( gradient ) }
