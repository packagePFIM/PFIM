#' @title Fisher Information Matrix (FIM) Class
#' @name Fim
#'
#' @description
#' The \code{Fim} class represents the Fisher Information Matrix in the context of
#' population pharmacokinetics and pharmacodynamics. It acts as a container for
#' the numerical matrix and derived statistical metrics used to evaluate design
#' performance, such as parameter precision and shrinkage.
#
#' @param fisherMatrix A matrix giving the numerical values of the Fim.
#' @param shrinkage A vector giving the shrinkage values for the random effects.
#' @param fixedEffects A matrix giving the numerical values of the fixed effects of the Fim.
#' @param varianceEffects A matrix giving the numerical values of variance effects of the Fim.
#' @param SEAndRSE A data frame giving the calculated values of SE and RSE for parameters.
#' @param condNumberFixedEffects The condition number of the fixed effects portion of the Fim.
#' @param condNumberVarianceEffects The condition number of the variance effects portion of the Fim.
#'
#' @return An object of class \code{Fim}.
#'
#' @template copyright
#' @export

Fim = new_class("Fim", package = "PFIM",
                properties = list(
                  fisherMatrix = new_property(class_double, default = numeric(0)),
                  fixedEffects = new_property(class_double, default = numeric(0)),
                  varianceEffects = new_property(class_double, default = numeric(0)),
                  SEAndRSE = new_property(class_list, default = list()),
                  condNumberFixedEffects = new_property(class_double, default = 0.0),
                  condNumberVarianceEffects = new_property(class_double, default = 0.0),
                  shrinkage = new_property(class_double, default = numeric(0))
                ))

evaluateFim = new_generic( "evaluateFim", c( "fim", "model", "arm" ) )
evaluateVarianceFIM = new_generic( "evaluateVarianceFIM", c( "fim", "model", "arm" ) )
setEvaluationFim = new_generic( "setEvaluationFim", c( "fim" ) )
setOptimalArms = new_generic( "setOptimalArms", c( "fim", "optimizationAlgorithm" ) )
Dcriterion = new_generic( "Dcriterion", c( "fim" ) )
showFIM = new_generic( "showFIM", c( "fim" ) )
plotSEFIM = new_generic( "plotSEFIM", c( "fim", "evaluation" ) )
plotRSEFIM = new_generic( "plotRSEFIM", c( "fim", "evaluation" ) )
plotShrinkage = new_generic( "plotShrinkage", c( "fim" ,"evaluation" ) )
tablesForReport = new_generic( "tablesForReport", c( "fim", "evaluation" ) )
generateReportEvaluation = new_generic( "generateReportEvaluation", c( "fim" ) )

generateReportOptimization = new_generic(
  "generateReportOptimization",
  c("fim", "optimizationAlgorithm"),
  function(fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile) S7_dispatch()
)

# ==============================================================================
#' @title Dcriterion
#' @name Dcriterion
#' @description
#' Computes the D-criterion of the Fisher Information Matrix. The D-criterion is
#' calculated as the determinant of the FIM raised to the power of 1 over the
#' number of parameters.
#' @param fim An object of class \code{Fim}.
#' @return A double giving the D-criterion of the Fim.
#' @template copyright
#' @export
# ==============================================================================

method( Dcriterion, Fim ) = function( fim )
{
  fisherMatrix = prop( fim, "fisherMatrix" )
  Dcriterion = det(fisherMatrix)**(1/dim(fisherMatrix)[1])
  return(Dcriterion)
}
