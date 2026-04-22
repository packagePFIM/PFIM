#' @title plot
#' @name plot
#'
#' @description
#' Generates plots for \code{Evaluation} or \code{Optimization} objects and
#' returns them as a named list. Dispatches automatically on the object class --
#' the user never needs to know which specific plot function to call.
#' Follows the same OO convention as \code{plot.lm} in base R.
#' For any other object type, falls through to \code{graphics::plot}.
#'
#' @param pfimobject An object of class \code{Evaluation} or \code{Optimization}.
#' @param plotOptions A \code{list} of graphical options forwarded to
#'   \code{plotEvaluation} and \code{plotSensitivityIndices}.
#'   Defaults to \code{list()}.
#' @param which \code{character} or \code{NULL}. Subset of plots to compute.
#'   Partial matching supported (like \code{plot.lm}).
#' @param thresholdWeights A numeric value for thresholding the weigth for the multiplicative algorithm.
#' @param thresholdFrequencies A numeric value for thresholding the weigth for the FedorovWynn algorithm.
#'   \itemize{
#'     \item \code{Evaluation}: any subset of
#'       \code{c("evaluation", "sensitivityIndices", "SE", "RSE")}.
#'     \item \code{Optimization}: any subset of
#'       \code{c("evaluation", "sensitivityIndices", "SE", "RSE",
#'               "weights", "frequencies")}.
#'   }
#'   \code{NULL} (default): all plots for the given class.
#' @param \dots Forwarded to \code{graphics::plot} for non-PFIM objects.
#'
#' @usage
#' plot(pfimobject, plotOptions = list(), which = NULL,
#'      thresholdWeights = 0, thresholdFrequencies = 0, ...)
#'
#' @return For PFIM objects: a named \code{list} of \code{ggplot2} objects.
#'   For other objects: the return value of \code{graphics::plot}.
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

.checkWhich = function(which, choices, cls) {
  bad = setdiff(which, choices)
  if (length(bad) > 0L)
    stop(sprintf(
      paste0("plot() -- invalid `which` value%s for a %s object: %s\n",
             "  Valid choices: %s"),
      if (length(bad) > 1L) "s" else "",
      cls,
      paste(sQuote(bad),     collapse = ", "),
      paste(sQuote(choices), collapse = ", ")
    ), call. = FALSE)
}

.checkThreshold = function(x, argname) {
  if (!is.numeric(x) || length(x) != 1L || is.na(x) || x < 0 || x >= 1)
    stop(sprintf(
      "plot() -- `%s` must be a single numeric in [0, 1], got: %s",
      argname, deparse(x)
    ), call. = FALSE)
}

plot = function(pfimobject,
                plotOptions          = list(),
                which                = NULL,
                thresholdWeights     = 0,
                thresholdFrequencies = 0,
                ...) {

  # -- Evaluation --------------------------------------------------------------
  if ("PFIM::Evaluation" %in% class(pfimobject)) {

    which = if (is.null(which)) .WHICH_EVALUATION else {
      .checkWhich(which, .WHICH_EVALUATION, "Evaluation")
      match.arg(which, choices = .WHICH_EVALUATION, several.ok = TRUE)
    }
    out = list()
    if ("evaluation"         %in% which) out$evaluation         = plotEvaluation(pfimobject, plotOptions)
    if ("sensitivityIndices" %in% which) out$sensitivityIndices = plotSensitivityIndices(pfimobject, plotOptions)
    if ("SE"                 %in% which) out$SE                 = plotSE(pfimobject)
    if ("RSE"                %in% which) out$RSE                = plotRSE(pfimobject)
    return(out)
  }

  # -- Optimization (toutes sous-classes : Multiplicative, FedorovWynn, PSO…) --
  if ("PFIM::Optimization" %in% class(pfimobject)) {

    which = if (is.null(which)) .WHICH_OPTIMIZATION else {
      .checkWhich(which, .WHICH_OPTIMIZATION, "Optimization")
      match.arg(which, choices = .WHICH_OPTIMIZATION, several.ok = TRUE)
    }

    if ("weights"     %in% which) .checkThreshold(thresholdWeights,     "thresholdWeights")
    if ("frequencies" %in% which) .checkThreshold(thresholdFrequencies, "thresholdFrequencies")

    optimisationDesign      = prop(pfimobject, "optimisationDesign")
    evaluationOptimalDesign = optimisationDesign$evaluationOptimalDesign

    out = list()
    if ("evaluation"         %in% which) out$evaluation         = plotEvaluation(evaluationOptimalDesign, plotOptions)
    if ("sensitivityIndices" %in% which) out$sensitivityIndices = plotSensitivityIndices(evaluationOptimalDesign, plotOptions)
    if ("SE"                 %in% which) out$SE                 = plotSE(pfimobject)
    if ("RSE"                %in% which) out$RSE                = plotRSE(pfimobject)
    if ("weights"            %in% which) out$weights            = plotWeights(pfimobject,     thresholdWeights     = thresholdWeights)
    if ("frequencies"        %in% which) out$frequencies        = plotFrequencies(pfimobject, thresholdFrequencies = thresholdFrequencies)
    return(out)
  }

  # -- Fallback ----------------------------------------------------------------
  graphics::plot(pfimobject, ...)
}
