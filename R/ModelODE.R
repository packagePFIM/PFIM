# ==============================================================================
#' @title ModelODE Class
#' @name ModelODE
#' @description The class \code{ModelODE} is used to defined a ode model.
#' @title ModelODE
#' @inheritParams Model
#' @include Model.R
#' @template copyright
#' @export

ModelODE = new_class( "ModelODE", package = "PFIM", parent = Model )

# ==============================================================================
#' @rdname evaluateInitialConditions
#' @name evaluateInitialConditions
#' @export
# ==============================================================================

method( evaluateInitialConditions, ModelODE ) = function( model, arm ) {

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
