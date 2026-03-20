#' @title ModelInfusion Class
#' @name ModelInfusion
#' @description The class \code{ModelInfusion} is used to defined a model in infusion.
#' @inheritParams Model
#' @include Model.R
#' @include ModelAnalytic.R
#' @template copyright
#' @export

ModelInfusion = new_class( "ModelInfusion", package = "PFIM", parent = Model )

# ==============================================================================
#' @title conversion from analytic to ode
#' @name convertPKModelAnalyticToPKModelODE
#' @param pkModel An object of class \code{ModelInfusion} that defines the model.
#' @template copyright
#' @export
# ==============================================================================

method( convertPKModelAnalyticToPKModelODE, ModelInfusion ) = function( pkModel  ) {

  pkModelEquations = prop(pkModel, "modelEquations")

  pkModelEquations = list( duringInfusion = pkModelEquations$duringInfusion,
                           afterInfusion = pkModelEquations$afterInfusion )

  convertEquation = function( equation ) {
    dtEquationPKsubstitute = D( parse( text = equation ), "t")
    dtEquationPKsubstitute = str_c( deparse( dtEquationPKsubstitute ), collapse = "" )

    if ( str_detect( equation, "Cl" ) ) {
      return( str_c( dtEquationPKsubstitute, "+(Cl/V)*", equation, "- (Cl/V)*C1" ) )
    } else {
      return( str_c( dtEquationPKsubstitute, "+k*", equation, "- k*C1" ) )
    }
  }

  equations = map( pkModelEquations, convertEquation )
  equations = map( equations, str_replace_all, " ", "" )
  equations =  list( duringInfusion = list( "Deriv_C1" = equations$duringInfusion ),
                     afterInfusion = list( "Deriv_C1" = equations$afterInfusion ) )

  return( equations )
}
