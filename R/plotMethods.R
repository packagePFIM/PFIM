#' @title plot
#' @name plot
#'
#' @description
#' Generates plots for \code{Evaluation} or \code{Optimization} objects and
#' returns them as a named list. S7 dispatches automatically on the object
#' class -- the user never needs to know which specific plot function to call.
#' Follows the same OO convention as \code{plot.lm} in base R.
#'
#' @param x An object of class \code{Evaluation} or \code{Optimization}.
#' @param plotOptions A \code{list} of graphical options forwarded to
#'   \code{plotEvaluation} and \code{plotSensitivityIndices}.
#'   Defaults to \code{list()}.
#' @param which \code{character}. Subset of plots to compute.
#'   Partial matching supported (like \code{plot.lm}).
#'   \itemize{
#'     \item \code{Evaluation}: any subset of
#'       \code{c("evaluation", "sensitivityIndices", "SE", "RSE")}.
#'     \item \code{Optimization}: any subset of
#'       \code{c("evaluation", "sensitivityIndices", "SE", "RSE",
#'               "weights", "frequencies")}.
#'   }
#'   Default: all plots for the given class.
#' @param \dots Additional arguments (ignored).
#'
#' @usage
#' plot(x, plotOptions = list(), which = NULL, ...)
#'
#' @return A named \code{list} of \code{ggplot2} objects.
#'
#' @examples
#' \dontrun{
#' results = run(evaluationPop)
#' p = plot(results,
#'          plotOptions = plotOptions,
#'          which       = c("evaluation", "sensitivityIndices", "SE", "RSE"))
#' p$SE
#'
#' opt = run(optimizationMult)
#' p = plot(opt,
#'          plotOptions = plotOptions,
#'          which       = c("evaluation", "SE", "RSE", "weights"))
#' p$weights
#' }
#'
#' @seealso \code{\link{plotEvaluation}}, \code{\link{plotSensitivityIndices}},
#'   \code{\link{plotSE}}, \code{\link{plotRSE}},
#'   \code{\link{plotWeights}}, \code{\link{plotFrequencies}}
#'
#' @include Evaluation.R
#' @include Optimization.R
#' @template copyright
#' @export
# ==============================================================================

.WHICH_EVALUATION   = c("evaluation", "sensitivityIndices", "SE", "RSE")
.WHICH_OPTIMIZATION = c("evaluation", "sensitivityIndices", "SE", "RSE",
                        "weights", "frequencies")

# Internal validator -- called before match.arg to give a clear PFIM error.
.checkWhich = function(which, choices, class) {
  bad = setdiff(which, choices)
  if (length(bad) > 0L)
    stop(sprintf(
      paste0(
        "plot() -- invalid `which` value%s for a %s object: %s\n",
        "  Valid choices: %s"
      ),
      if (length(bad) > 1L) "s" else "",
      class,
      paste(sQuote(bad), collapse = ", "),
      paste(sQuote(choices), collapse = ", ")
    ), call. = FALSE)
}

plot = new_generic("plot", "x", function(x, plotOptions = list(), which = NULL, ...) S7_dispatch())

# -- method(plot, Evaluation) -------------------------------------------------
method(plot, Evaluation) = function(x,
                                    plotOptions = list(),
                                    which       = .WHICH_EVALUATION,
                                    ...) {
  .checkWhich(which, .WHICH_EVALUATION, "Evaluation")
  which = match.arg(which, choices = .WHICH_EVALUATION, several.ok = TRUE)
  out   = list()
  if ("evaluation"         %in% which) out$evaluation         = plotEvaluation(x, plotOptions)
  if ("sensitivityIndices" %in% which) out$sensitivityIndices = plotSensitivityIndices(x, plotOptions)
  if ("SE"                 %in% which) out$SE                 = plotSE(x)
  if ("RSE"                %in% which) out$RSE                = plotRSE(x)
  out
}

# -- method(plot, .Optimization_S7) -------------------------------------------
method(plot, .Optimization_S7) = function(x,
                                          plotOptions = list(),
                                          which       = .WHICH_OPTIMIZATION,
                                          ...) {
  .checkWhich(which, .WHICH_OPTIMIZATION, "Optimization")
  which                   = match.arg(which, choices = .WHICH_OPTIMIZATION, several.ok = TRUE)
  optimisationDesign      = prop(x, "optimisationDesign")
  evaluationOptimalDesign = optimisationDesign$evaluationOptimalDesign
  out = list()
  if ("evaluation"         %in% which) out$evaluation         = plotEvaluation(evaluationOptimalDesign, plotOptions)
  if ("sensitivityIndices" %in% which) out$sensitivityIndices = plotSensitivityIndices(evaluationOptimalDesign, plotOptions)
  if ("SE"                 %in% which) out$SE                 = plotSE(x)
  if ("RSE"                %in% which) out$RSE                = plotRSE(x)
  if ("weights"            %in% which) out$weights            = plotWeights(x)
  if ("frequencies"        %in% which) out$frequencies        = plotFrequencies(x)
  out
}
