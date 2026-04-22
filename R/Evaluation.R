# Copyright (c) 2026-present Romain Leroux. All rights reserved.

#' @title Evaluation Class
#' @name Evaluation
#'
#' @description
#' The `Evaluation` class represents and stores all information required to
#' evaluate a clinical trial design. It serves as the main interface for
#' calculating the Fisher Information Matrix (FIM), Standard Errors (SE),
#' and other design criteria.
#'
#' @slot evaluationDesign \code{list}. Stores the results of the design evaluation.
#'
#' @param evaluationDesign A list containing the evaluation results of the design.
#'
#' @inheritParams PFIMProject
#'
#' @return An object of class \code{Evaluation}.
#'
#' @include PFIMProject.R
#'
#' @examples
#' \dontrun{
#'
#' # Example: Evaluation of the Population Fisher Information Matrix (FIM)
#' # extracted from Vignette n°1.
#'
#' evaluationPop = Evaluation(
#'   name                = "evaluation_example",
#'   modelEquations      = modelEquations,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#'   designs             = list(design1),
#'   fimType             = "population",
#'   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
#' )
#'
#' # Display the results (Standard Errors, RSE, etc.)
#' show(evaluationPop)
#'
#' }
#'
#' @template copyright
#' @export

Evaluation = new_class(
  "Evaluation",
  package = "PFIM",
  parent  = PFIMProject,
  properties = list(
    evaluationDesign    = new_property(class_list,      default = list()),
    name                = new_property(class_character, default = character(0)),
    modelParameters     = new_property(class_list,      default = list()),
    modelEquations      = new_property(class_list,      default = list()),
    modelFromLibrary    = new_property(class_list,      default = list()),
    modelError          = new_property(class_list,      default = list()),
    designs             = new_property(class_list,      default = list()),
    outputs             = new_property(class_list,      default = list()),
    fimType             = new_property(class_character, default = character(0)),
    odeSolverParameters = new_property(class_list,      default = list())
  ),
  validator = function(self) {
    errors = character(0)
    validFimTypes = c("population", "individual", "Bayesian")
    if (length(prop(self, "fimType")) > 0L && !(prop(self, "fimType") %in% validFimTypes))
      errors = c(errors, sprintf(
        "@fimType must be one of: %s. Got: '%s'.",
        paste(validFimTypes, collapse = ", "), prop(self, "fimType")
      ))
    if (length(prop(self, "designs")) == 0L)
      errors = c(errors, "@designs must contain at least one design.")
    hasEquations = length(prop(self, "modelEquations"))  > 0L
    hasFromLib   = length(prop(self, "modelFromLibrary")) > 0L
    if (!hasEquations && !hasFromLib)
      errors = c(errors, "Either @modelEquations or @modelFromLibrary must be provided.")
    if (length(prop(self, "modelParameters")) == 0L)
      errors = c(errors, "@modelParameters must contain at least one parameter.")
    if (length(prop(self, "modelError")) == 0L)
      errors = c(errors, "@modelError must contain at least one error model.")
    if (length(prop(self, "outputs")) == 0L)
      errors = c(errors, "@outputs must contain at least one output.")
    if (length(errors) == 0L) NULL else errors
  },
  constructor = function(
    evaluationDesign    = list(),
    name                = character(0),
    modelParameters     = list(),
    modelEquations      = list(),
    modelFromLibrary    = list(),
    modelError          = list(),
    designs             = list(),
    outputs             = list(),
    fimType             = character(0),
    odeSolverParameters = list()
  ) {
    new_object(
      .parent             = PFIMProject(name = name),
      evaluationDesign    = evaluationDesign,
      name                = name,
      modelParameters     = modelParameters,
      modelEquations      = modelEquations,
      modelFromLibrary    = modelFromLibrary,
      modelError          = modelError,
      designs             = designs,
      outputs             = outputs,
      fimType             = fimType,
      odeSolverParameters = odeSolverParameters
    )
  }
)

# ==============================================================================
# the internal helpers
# ==============================================================================

#' @keywords internal
.buildModel = function(pfimproject) {
  pfimproject %>%
    defineModelType() %>%
    finiteDifferenceHessian() %>%
    defineModelWrapper(pfimproject)
}

#' @keywords internal
.buildModelErrorTable = function(pfimproject) {
  modelErrorData = map_dfr(
    map(prop(pfimproject, "modelError"), getModelErrorData),
    ~ as.data.frame(.x, stringsAsFactors = FALSE)
  )
  colnames(modelErrorData) = c("Output", "Type", "$\\sigma_{slope}$", "$\\sigma_{inter}$")
  kbl(modelErrorData, align = c("c", "c", "c", "c")) %>%
    kable_styling(bootstrap_options = "hover", full_width = FALSE,
                  position = "center", font_size = 13)
}

#' @keywords internal
.buildModelParametersTable = function(pfimproject) {
  modelParametersData = map_dfr(
    map(prop(pfimproject, "modelParameters"), getModelParametersData),
    ~ as.data.frame(.x, stringsAsFactors = FALSE)
  )
  colnames(modelParametersData) = c(
    "Parameter", "$\\mu$", "$\\omega$", "Distribution",
    paste0("$\\mu$", " fixed"), paste0("$\\omega$", " fixed")
  )
  kbl(modelParametersData, align = c("l", "l", "l", "c", "c", "c")) %>%
    kable_styling(bootstrap_options = "hover", full_width = FALSE,
                  position = "center", font_size = 13)
}

#' @keywords internal
.buildAdministrationTable = function(arms) {
  administrationData = map_dfr(
    list_flatten(map(pluck(arms, 1), armAdministration)),
    ~ as.data.frame(.x, stringsAsFactors = FALSE)
  )
  colnames(administrationData) = c(
    "Design name", "Arms name", "Number of subject",
    "Outcome", "Dose", "Time dose", "$\\tau$", "$T_{inf}$"
  )
  kbl(administrationData, align = c("l", "l", "l", "c", "c", "c", "c")) %>%
    kable_styling(bootstrap_options = "hover", full_width = FALSE,
                  position = "center", font_size = 13)
}

#' @keywords internal
.buildInitialDesignTable = function(arms) {
  initialDesignData = map_dfr(
    list_flatten(map(pluck(arms, 1), getArmData)),
    ~ as.data.frame(.x, stringsAsFactors = FALSE)
  )
  colnames(initialDesignData) = c(
    "Arms name", "Number of subjects", "Outcome", "Dose", "Sampling times"
  )
  kbl(initialDesignData, align = c("l", "c", "c", "c")) %>%
    kable_styling(bootstrap_options = "hover", full_width = FALSE,
                  position = "center", font_size = 13)
}

# ==============================================================================
# the methods
# ==============================================================================

method(run, Evaluation) = function(pfimproject)
{
  if (length(prop(pfimproject, "modelFromLibrary")) != 0)
    prop(pfimproject, "modelEquations") = defineModelEquationsFromLibraryOfModel(pfimproject)

  model = .buildModel(pfimproject)
  fim   = defineFim(pfimproject)

  designs          = prop(pfimproject, "designs")
  evaluationDesign = map(designs, ~ evaluateDesign(.x, model, fim))
  prop(pfimproject, "evaluationDesign") = evaluationDesign

  # FIM on the project defaults to the first design;
  # all designs accessible via prop(result, "evaluationDesign").
  prop(pfimproject, "fim") = prop(pluck(evaluationDesign, 1L), "fim")

  return(pfimproject)
}

# ==============================================================================

method(getFisherMatrix, Evaluation) = function(pfimproject)
{
  fim = setEvaluationFim(prop(pfimproject, "fim"), pfimproject)
  list(
    fisherMatrix    = prop(fim, "fisherMatrix"),
    fixedEffects    = prop(fim, "fixedEffects"),
    varianceEffects = prop(fim, "varianceEffects")
  )
}

# ==============================================================================

method(show, Evaluation) = function(pfimproject)
{
  fim = prop( pfimproject, "fim" )
  fim = setEvaluationFim( fim, pfimproject )
  showFIM( fim )
}

# ==============================================================================

method(plotEvaluation, Evaluation) = function(pfimproject, plotOptions)
{
  designs    = prop(pfimproject, "designs")
  model      = .buildModel(pfimproject)
  fim        = defineFim(pfimproject)
  design     = pluck(designs, 1)
  designName = prop(design, "name")
  arms       = prop(design, "arms")

  allPlots = map(arms, ~ processArmEvaluationResults(.x, model, fim, designName, plotOptions))
  setNames(
    list(allPlots %>% map(~ .x[[designName]]) %>% list_flatten()),
    designName
  )
}

# ==============================================================================

method(plotSensitivityIndices, Evaluation) = function(pfimproject, plotOptions)
{
  designs    = prop(pfimproject, "designs")
  model      = .buildModel(pfimproject)
  fim        = defineFim(pfimproject)
  design     = pluck(designs, 1)
  designName = prop(design, "name")
  arms       = prop(design, "arms")

  allPlots = map(arms, ~ processArmEvaluationSI(.x, model, fim, designName, plotOptions))
  setNames(
    list(allPlots %>% map(~ .x[[designName]]) %>% list_flatten()),
    designName
  )
}

# ==============================================================================

method(plotSE, Evaluation) = function(pfimproject)
{
  plotSEFIM(prop(pfimproject, "fim"), pfimproject)
}

# ==============================================================================

method(plotRSE, Evaluation) = function(pfimproject)
{
  plotRSEFIM(prop(pfimproject, "fim"), pfimproject)
}


# ==============================================================================

# ==============================================================================

method(getSE, Evaluation) = function(pfimproject)
{
  prop(setEvaluationFim(prop(pfimproject, "fim"), pfimproject), "SEAndRSE")$SE
}

# ==============================================================================

method(getRSE, Evaluation) = function(pfimproject)
{
  prop(setEvaluationFim(prop(pfimproject, "fim"), pfimproject), "SEAndRSE")$RSE
}

# ==============================================================================

method(getShrinkage, Evaluation) = function(pfimproject)
{
  prop(setEvaluationFim(prop(pfimproject, "fim"), pfimproject), "shrinkage")
}

# ==============================================================================

method(getDeterminant, Evaluation) = function(pfimproject)
{
  det(getFisherMatrix(pfimproject)$fisherMatrix)
}

# ==============================================================================

method(getDcriterion, Evaluation) = function(pfimproject)
{
  Dcriterion(setEvaluationFim(prop(pfimproject, "fim"), pfimproject))
}

# ==============================================================================

method(getCorrelationMatrix, Evaluation) = function(pfimproject)
{
  cov2cor(solve(getFisherMatrix(pfimproject)$fisherMatrix))
}

# ==============================================================================

method(Report, Evaluation) = function(pfimproject, outputPath, outputFile, plotOptions)
{
  projectName       = prop(pfimproject, "name")
  evaluationOutputs = prop(pfimproject, "outputs")
  designs           = prop(pfimproject, "designs")
  arms              = map(designs, ~ prop(.x, "arms"))

  modelEquations        = prop(.buildModel(pfimproject), "modelEquations")
  fim                   = setEvaluationFim(prop(pfimproject, "fim"), pfimproject)
  fimInitialDesignTable = tablesForReport(fim, pfimproject)

  reportData = list(
    evaluationOutputs      = evaluationOutputs,
    modelEquations         = modelEquations,
    modelErrorTable        = .buildModelErrorTable(pfimproject),
    modelParametersTable   = .buildModelParametersTable(pfimproject),
    administrationTable    = .buildAdministrationTable(arms),
    initialDesignTable     = .buildInitialDesignTable(arms),
    fimInitialDesignTable  = fimInitialDesignTable,
    plotsEvaluation        = plotEvaluation(pfimproject, plotOptions),
    plotSensitivityIndices = plotSensitivityIndices(pfimproject, plotOptions),
    plotSE                 = plotSE(pfimproject),
    plotRSE                = plotRSE(pfimproject),
    fim                    = fim,
    pfimproject            = pfimproject,
    projectName            = projectName
  )

  generateReportEvaluation(fim, reportData, outputPath = outputPath, outputFile = outputFile)
}
