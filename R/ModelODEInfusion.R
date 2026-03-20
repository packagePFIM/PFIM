# ==============================================================================
#' @title ModelODEInfusion Class
#' @name ModelODEInfusion
#' @description
#' The \code{ModelODEInfusion} class is specifically designed to define ODE-based
#' models for infusion-type administrations. It extends the \code{ModelInfusion}
#' properties to handle continuous drug delivery through differential equations.
#' @inheritParams ModelInfusion
#' @include ModelInfusion.R
#' @template copyright
#' @export

ModelODEInfusion = new_class( "ModelODEInfusion", package = "PFIM", parent = ModelInfusion )

# ==============================================================================
#' @rdname evaluateInitialConditions
#' @name evaluateInitialConditions
#' @export
# ==============================================================================

method( evaluateInitialConditions, ModelODEInfusion ) = function( model, arm ) {

  initialConditions = prop( arm, "initialConditions")
  parameters = prop( model, "modelParameters")

  # assign mu values of the parameters
  mu = set_names(
    map( parameters, ~ {
      pluck(.x, "distribution", "mu")
    }),
    map( parameters, ~ prop( .x, "name") )
  )

  list2env( mu, envir = environment())

  # evaluate the initial conditions
  initialConditions = map( initialConditions, ~ {

    if ( is.numeric(.x) ) {
      return(.x)
    } else {
      eval( parse( text = .x ) )
    }
  })%>%unlist()

  return( initialConditions )
}
