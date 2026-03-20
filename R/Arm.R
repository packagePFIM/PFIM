#' @title Arm Class
#' @name Arm
#'
#' @description
#' The \code{Arm} class represents an experimental group within a study. It
#' integrates all components of the design for that group, including the
#' sample size, dosing regimens, sampling schedules, and initial conditions
#' for ODE models.
#'
#' @slot name \code{character}. The unique identifier for the arm.
#' @slot size \code{numeric}. The number of subjects assigned to this arm.
#' @slot administrations \code{list}. A list of \code{Administration} objects.
#' @slot initialConditions \code{list}. A named list where keys are variable names
#' (strings) and values are their initial states (numeric).
#' @slot samplingTimes \code{list}. A list of \code{SamplingTimes} objects.
#'
#' @param name A string giving the name of the arm.
#' @param size An integer giving the number of subjects in the arm.
#' @param administrations A list of \code{Administration} objects defining the dosing.
#' @param initialConditions A named list of numeric values for ODE initial states.
#' @param samplingTimes A list of \code{SamplingTimes} objects defining the observations.
#' @param administrationsConstraints A list of \code{AdministrationsConstraints} objects.
#' @param samplingTimesConstraints A list of \code{SamplingTimesConstraints} objects.
#' @param evaluationModel A list containing the evaluation of the responses.
#' @param evaluationGradients A list containing the evaluation of the gradients.
#' @param evaluationVariance A list containing the evaluation of the variance.
#' @param evaluationFim An object of class \code{Fim} representing the Fisher Information Matrix.
#'
#' @return An object of class \code{Arm}.
#'
#' @include Model.R
#' @include Fim.R
#' @include MultiplicativeAlgorithm.R
#' @include FedorovWynnAlgorithm.R
#' @include SimplexAlgorithm.R
#' @include PSOAlgorithm.R
#' @include PGBOAlgorithm.R
#'
#' @examples
#'
#' # Note: The 'initialConditions' slot is strictly used for ODE-based model arms.
#' # For analytic (closed-form) solutions, this slot is ignored as the
#' # initial state is implicitly defined by the model equations.
#'
#' # 1. Define sampling times for PK and PD outcomes
#' samplingTimesRespPK = SamplingTimes(outcome = "RespPK",
#'                                      samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))
#'
#' samplingTimesRespPD = SamplingTimes(outcome = "RespPD",
#'                                      samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4))
#'
#' # 2. Define the administration (Dose of 20 at t=0)
#' adminRespPK = Administration(outcome = "RespPK", timeDose = 0, dose = 20)
#'
#' # 3. Define the study arm "0.2mg"
#' # Outcomes are linked to state variables: RespPK to Cc, RespPD to E.
#' arm = Arm(name = "0.2mg",
#'            size = 6,
#'            administrations = list(adminRespPK),
#'            samplingTimes   = list(samplingTimesRespPK, samplingTimesRespPD),
#'            initialConditions = list("Cc" = 0, "E" = 100))
#'
#' print(arm)
#'
#' @template copyright
#' @export

Arm = new_class("Arm", package = "PFIM",
                properties = list(
                  name                       = new_property(class_character, default = character(0)),
                  size                       = new_property(class_double,    default = numeric(0)),
                  administrations            = new_property(class_list,      default = list()),
                  initialConditions          = new_property(class_list,      default = list()),
                  samplingTimes              = new_property(class_list,      default = list()),
                  administrationsConstraints = new_property(class_list,      default = list()),
                  samplingTimesConstraints   = new_property(class_list,      default = list()),
                  evaluationModel            = new_property(class_list,      default = list()),
                  evaluationGradients        = new_property(class_list,      default = list()),
                  evaluationVariance         = new_property(class_list,      default = list()),
                  evaluationFim              = new_property(Fim,             default = NULL)
                ))

# ==============================================================================
# TYPE UNIONS  (must be defined before any new_generic that dispatches on them)
# ==============================================================================

AdminSamplingAlgorithm  = new_union(MultiplicativeAlgorithm, FedorovWynnAlgorithm)
WindowSamplingAlgorithm = new_union(SimplexAlgorithm, PSOAlgorithm, PGBOAlgorithm)

# ==============================================================================
# GENERICS
# ==============================================================================

#' @title Evaluate an arm
#' @name evaluateArm
#' @description
#' Evaluates the model, gradients, variance, and FIM for an arm.
#' @param arm An object of class \code{Arm}.
#' @param model An object of class \code{Model}.
#' @param fim An object of class \code{Fim}.
#' @param ... Additional arguments
#' @return The \code{Arm} object with updated \code{evaluationModel},
#' \code{evaluationGradients}, \code{evaluationVariance}, and \code{evaluationFim}.
#' @template copyright
#' @export

evaluateArm = new_generic("evaluateArm", c("arm"),
                          function(arm, model, fim, ...) S7_dispatch())

# ==============================================================================
#' @title Extract sampling times and maximum sampling time
#' @name getSamplingData
#' @description
#' Returns structured sampling information from an arm, used internally
#' by plotting methods.
#' @param arm An object of class \code{Arm}.
#' @param ... Additional arguments.
#' @return A list with \code{samplingTimes}, \code{samplings} (named list of
#'   numeric vectors), and \code{samplingMax} (numeric scalar).
#' @template copyright
#' @export

getSamplingData = new_generic("getSamplingData", c("arm"))

# ==============================================================================
#' @title Update sampling times for plotting
#' @name updateSamplingTimes
#' @description
#' Replaces the arm's sampling times with a dense regular grid combined with
#' the original sampling points, enabling smooth curve rendering.
#' @param arm An object of class \code{Arm}.
#' @param samplingData The list output from \code{getSamplingData}.
#' @param ... Additional arguments
#' @return The updated \code{Arm} object.
#' @template copyright
#' @export

updateSamplingTimes = new_generic("updateSamplingTimes", c("arm"),
                                  function(arm, samplingData, ...) S7_dispatch())

# ==============================================================================
#' @title Process arm evaluation for response plots
#' @name processArmEvaluationResults
#' @description
#' Evaluates the model on a dense time grid and generates response plots
#' for a given arm, overlaying the design sampling points.
#' @param arm An object of class \code{Arm}.
#' @param model An object of class \code{Model}.
#' @param fim An object of class \code{Fim}.
#' @param designName A string giving the name of the design.
#' @param plotOptions A list with \code{unitTime} and \code{unitOutcomes}.
#' @param ... Additional arguments
#' @return A named list of \code{ggplot} objects per design and arm.
#' @template copyright
#' @export

processArmEvaluationResults = new_generic("processArmEvaluationResults", c("arm", "model", "fim"),
                                          function(arm, model, fim, designName, plotOptions, ...) S7_dispatch())

# ==============================================================================
#' @title Process arm evaluation for sensitivity index plots
#' @name processArmEvaluationSI
#' @description
#' Evaluates model gradients on a dense time grid and generates sensitivity
#' index plots (partial derivatives of responses with respect to parameters).
#' @param arm An object of class \code{Arm}.
#' @param model An object of class \code{Model}.
#' @param fim An object of class \code{Fim}.
#' @param designName A string giving the name of the design.
#' @param plotOptions A list with \code{unitTime} and \code{unitOutcomes}.
#' @param ... Additional arguments
#' @return A named list of \code{ggplot} objects per design, arm, output, and parameter.
#' @template copyright
#' @export

processArmEvaluationSI = new_generic("processArmEvaluationSI", c("arm", "model", "fim"),
                                     function(arm, model, fim, designName, plotOptions, ...) S7_dispatch())

# ==============================================================================
#' @title Plot model responses for an arm
#' @name plotEvaluationResults
#' @description
#' Generates \code{ggplot2} line plots of model responses, overlaying design
#' sampling points in red on the secondary x-axis.
#' @param arm An object of class \code{Arm}.
#' @param evaluationModel A list of data frames from \code{evaluateModel}.
#' @param outputNames A list of strings giving the output names.
#' @param samplingData A list from \code{getSamplingData}.
#' @param designName A string giving the design name.
#' @param plotOptions A list with \code{unitTime} and \code{unitOutcomes}.
#' @param ... Additional arguments
#' @return A named list of \code{ggplot} objects.
#' @template copyright
#' @export

plotEvaluationResults = new_generic("plotEvaluationResults", c("arm"),
                                    function(arm, evaluationModel, outputNames, samplingData,
                                             designName, plotOptions, ...) S7_dispatch())

# ==============================================================================
#' @title Plot sensitivity indices for an arm
#' @name plotEvaluationSI
#' @description
#' Generates \code{ggplot2} line plots of the partial derivatives of model
#' responses with respect to population parameters (sensitivity indices).
#' @param arm An object of class \code{Arm}.
#' @param evaluationModelGradient A list of data frames from \code{evaluateModelGradient}.
#' @param parametersNames A character vector of parameter names.
#' @param outputNames A list of strings giving the output names.
#' @param samplingData A list from \code{getSamplingData}.
#' @param designName A string giving the design name.
#' @param plotOptions A list with \code{unitTime} and \code{unitOutcomes}.
#' @param ... Additional arguments
#' @return A named list of \code{ggplot} objects per output and parameter.
#' @template copyright
#' @export

plotEvaluationSI = new_generic("plotEvaluationSI", c("arm"),
                               function(arm, evaluationModelGradient, parametersNames, outputNames,
                                        samplingData, designName, plotOptions, ...) S7_dispatch())

# ==============================================================================
#' @title Extract arm data for reporting
#' @name getArmData
#' @description
#' Extracts arm-level design information (name, size, outcomes, doses, sampling
#' times) formatted for inclusion in HTML reports.
#' @param arm An object of class \code{Arm}.
#' @param ... Additional arguments.
#' @return A list of named lists, one per sampling outcome.
#' @template copyright
#' @export

getArmData = new_generic("getArmData", c("arm"))

# ==============================================================================
#' @title Get arm constraints for optimization algorithms
#' @name getArmConstraints
#' @description
#' Extracts administration and sampling time constraints formatted for the
#' \code{MultiplicativeAlgorithm}, \code{FedorovWynnAlgorithm},
#' \code{SimplexAlgorithm}, \code{PSOAlgorithm}, or \code{PGBOAlgorithm}.
#' @param arm An object of class \code{\link{Arm}}.
#' @param optimizationAlgorithm An object of class \code{MultiplicativeAlgorithm},
#' \code{FedorovWynnAlgorithm}, \code{SimplexAlgorithm}, \code{PSOAlgorithm}, or \code{PGBOAlgorithm}.
#' @param ... Additional arguments
#' @return A list of constraint entries, one per sampling outcome.
#' @template copyright
#' @export

getArmConstraints = new_generic("getArmConstraints", c("arm", "optimizationAlgorithm"),
                                function(arm, optimizationAlgorithm, ...) S7_dispatch())

# ==============================================================================
#' @title Get administration parameters of an arm
#' @name armAdministration
#' @description
#' Extracts dosing information (outcome, dose, time dose, tau, Tinf) for
#' each administration in the arm.
#' @param arm An object of class \code{Arm}.
#' @param ... Additional arguments.
#' @return A list of named lists, one per administration.
#' @template copyright
#' @export

armAdministration = new_generic("armAdministration", c("arm"))

# ==============================================================================
# INTERNAL HELPERS
# ==============================================================================

#' @keywords internal
.buildAdminSamplingConstraints = function(arm) {
  armName = prop(arm, "name")
  armSize = prop(arm, "size")

  admins = list_flatten(map(prop(arm, "administrationsConstraints"), function(ac) {
    doses = paste0("(", paste(unlist(prop(ac, "doses")), collapse = ", "), ")")
    setNames(list(doses), prop(ac, "outcome"))
  }))

  map(prop(arm, "samplingTimesConstraints"), function(sc) {
    outcome    = prop(sc, "outcome")
    doseConstr = if (!is.null(admins[[outcome]])) admins[[outcome]] else "."
    list(
      "Arms name"                       = armName,
      "Number of subjects"              = armSize,
      "Outcome"                         = outcome,
      "Initial samplings"               = paste0("(", paste(prop(sc, "initialSamplings"), collapse = ", "), ")"),
      "Fixed times"                     = paste0("(", paste(prop(sc, "fixedTimes"),       collapse = ", "), ")"),
      "Number of samplings optimisable" = as.character(prop(sc, "numberOfsamplingsOptimisable")),
      "Dose constraints"                = doseConstr
    )
  })
}

#' @keywords internal
.buildWindowSamplingConstraints = function(arm) {
  armName = prop(arm, "name")
  armSize = prop(arm, "size")

  map(prop(arm, "samplingTimesConstraints"), function(sc) {
    list(
      "Arms name"                  = armName,
      "Number of subjects"         = armSize,
      "Outcome"                    = prop(sc, "outcome"),
      "Initial samplings"          = paste0("(", paste(prop(sc, "initialSamplings"), collapse = ", "), ")"),
      "Samplings windows"          = paste(map_chr(prop(sc, "samplingsWindows"),
                                                   ~ paste0("(", paste(., collapse = ","), ")")),
                                           collapse = ", "),
      "Number of times by windows" = paste0("(", paste(prop(sc, "numberOfTimesByWindows"), collapse = ", "), ")"),
      "Min sampling"               = paste0("(", paste(prop(sc, "minSampling"),            collapse = ", "), ")")
    )
  })
}

# ==============================================================================
# METHODS  (no roxygen here — already documented on new_generic above)
# ==============================================================================

method(evaluateArm, Arm) = function(arm, model, fim)
{
  model = defineModelAdministration(model, arm)
  prop(arm, "evaluationModel")     = evaluateModel(model, arm)
  prop(arm, "evaluationGradients") = evaluateModelGradient(model, arm)
  prop(arm, "evaluationVariance")  = evaluateModelVariance(model, arm)
  prop(arm, "evaluationFim")       = evaluateFim(fim, model, arm)
  return(arm)
}

method(armAdministration, Arm) = function(arm)
{
  armName = prop(arm, "name")
  armSize = round(prop(arm, "size"), 2)

  map(prop(arm, "administrations"), function(adm) {
    list(
      "Design name"        = "Design optimized",
      "Arms name"          = armName,
      "Number of subjects" = as.character(armSize),
      "Outcome"            = prop(adm, "outcome"),
      "Dose"               = as.character(prop(adm, "dose")),
      "Time of dose"       = if (length(prop(adm, "timeDose")) > 0) as.character(prop(adm, "timeDose")) else ".",
      "tau"                = as.character(prop(adm, "tau")),
      "Tinf"               = if (length(prop(adm, "Tinf"))    > 0) as.character(prop(adm, "Tinf"))    else "."
    )
  })
}

method(getArmConstraints, list(Arm, AdminSamplingAlgorithm)) = function(arm, optimizationAlgorithm)
  .buildAdminSamplingConstraints(arm)

method(getArmConstraints, list(Arm, WindowSamplingAlgorithm)) = function(arm, optimizationAlgorithm)
  .buildWindowSamplingConstraints(arm)

method(getArmData, Arm) = function(arm)
{
  armName = prop(arm, "name")
  armSize = round(prop(arm, "size"), 2)

  doseList = map(prop(arm, "administrations"), function(adm) {
    list(outcome = prop(adm, "outcome"), dose = prop(adm, "dose"))
  })

  doseDict = setNames(
    map(doseList, ~ paste(.x$dose, collapse = ", ")),
    map_chr(doseList, ~ .x$outcome)
  )

  samplingList     = prop(arm, "samplingTimes")
  samplingOutcomes = map_chr(samplingList, ~ prop(.x, "outcome"))
  samplingTimes    = map(samplingList,     ~ prop(.x, "samplings"))

  map2(samplingOutcomes, samplingTimes, function(outc, samps) {
    list(
      "Arms name"          = armName,
      "Number of subjects" = as.character(armSize),
      "Outcome"            = outc,
      "Dose"               = if (outc %in% names(doseDict)) doseDict[[outc]] else ".",
      "Sampling times"     = paste0("(", paste(round(samps, 2), collapse = ", "), ")")
    )
  })
}

method(getSamplingData, Arm) = function(arm)
{
  samplingTimes = prop(arm, "samplingTimes")
  samplings = map(samplingTimes, ~ prop(.x, "samplings")) %>%
    set_names(map_chr(samplingTimes, ~ prop(.x, "outcome")))
  samplingMax = samplings %>% list_c() %>% max()
  list(samplingTimes = samplingTimes, samplings = samplings, samplingMax = samplingMax)
}

method(updateSamplingTimes, Arm) = function(arm, samplingData)
{
  prop(arm, "samplingTimes") = map(samplingData$samplingTimes, function(samplingsPlot) {
    prop(samplingsPlot, "samplings") = sort(unique(c(
      list_c(samplingData$samplings),
      seq(0.0, samplingData$samplingMax, 0.05)
    )))
    return(samplingsPlot)
  })
  arm
}

method(processArmEvaluationResults, list(Arm, Model, Fim)) = function(arm, model, fim, designName, plotOptions)
{
  outputNames     = as.list(prop(model, "outputNames"))
  samplingData    = getSamplingData(arm)
  arm             = updateSamplingTimes(arm, samplingData)
  model           = defineModelAdministration(model, arm)
  evaluationModel = evaluateModel(model, arm)
  plots = plotEvaluationResults(arm, evaluationModel, outputNames, samplingData, designName, plotOptions)
  return(plots)
}

method(processArmEvaluationSI, list(Arm, Model, Fim)) = function(arm, model, fim, designName, plotOptions)
{
  outputNames     = as.list(prop(model, "outputNames"))
  samplingData    = getSamplingData(arm)
  arm             = updateSamplingTimes(arm, samplingData)
  model           = defineModelAdministration(model, arm)
  parametersNames = prop(model, "modelParameters") %>% map_chr(~ prop(.x, "name"))
  evaluationModelGradient = evaluateModelGradient(model, arm)
  timeSeq = seq(from = 0, by = 0.05, length.out = nrow(pluck(evaluationModelGradient, 1)))
  evaluationModelGradient = map2(outputNames, evaluationModelGradient, function(outputName, gradient) {
    data.frame(time = timeSeq, gradient)
  }) %>% set_names(outputNames)
  plots = plotEvaluationSI(arm, evaluationModelGradient, parametersNames, outputNames, samplingData, designName, plotOptions)
  return(plots)
}

method(plotEvaluationResults, Arm) = function(arm, evaluationModel, outputNames, samplingData, designName, plotOptions)
{
  plotOptions = lapply(plotOptions, function(x) if (is.null(x)) " " else x)
  unitXAxis   = plotOptions$unitTime
  unitYAxis   = setNames(plotOptions$unitOutcomes, unlist(outputNames))
  armName     = prop(arm, "name")
  plotList    = list()
  plotList[[designName]] = list()
  plotList[[designName]][[armName]] = list()

  plots = map2(outputNames, samplingData$samplings, function(outputName, sampling) {
    data           = evaluationModel[[outputName]]
    samplingPoints = data[data$time %in% sampling, ]
    ggplot(data, aes(x = time, y = .data[[outputName]])) +
      geom_line() +
      geom_point(data = samplingPoints, aes(x = time, y = .data[[outputName]]), color = "red") +
      labs(
        x = paste0("Time (", unitXAxis, ")\n\nDesign: ", sub("_", " ", designName), "      Arm: ", armName),
        y = paste0(outputName, " (", unitYAxis[[outputName]], ")\n")
      ) +
      scale_x_continuous(
        breaks   = pretty_breaks(n = 10),
        sec.axis = sec_axis(~ . * 1, breaks = round(sampling, 2), name = "Sampling times")
      ) +
      scale_y_continuous(breaks = pretty_breaks(n = 10)) +
      theme(
        legend.position      = "none",
        axis.title.x.top     = element_text(color = "red", vjust = 2.0),
        axis.text.x.top      = element_text(angle = 90, hjust = 0, color = "red"),
        plot.title           = element_text(size = 16, hjust = 0.5),
        axis.title.x         = element_text(size = 16),
        axis.title.y         = element_text(size = 16),
        axis.text.x          = element_text(size = 16, angle = 90, vjust = 0.5),
        axis.text.y          = element_text(size = 16, angle = 0,  vjust = 0.5, hjust = 0.5),
        strip.text.x         = element_text(size = 16)
      )
  })
  plotList[[designName]][[armName]] = set_names(plots, outputNames)
  return(plotList)
}

method(plotEvaluationSI, Arm) = function(arm, evaluationModelGradient, parametersNames, outputNames, samplingData, designName, plotOptions)
{
  unitXAxis = plotOptions$unitTime
  armName   = prop(arm, "name")
  plotList  = list()
  plotList[[designName]] = list()
  plotList[[designName]][[armName]] = list()

  plots = map2(outputNames, samplingData$samplings, function(outputName, sampling) {
    gradientData = evaluationModelGradient[[outputName]]
    minYAxis     = min(gradientData[, parametersNames], na.rm = TRUE)
    maxYAxis     = max(gradientData[, parametersNames], na.rm = TRUE)

    map(parametersNames, function(parameterName) {
      data = as_tibble(gradientData[, c("time", parameterName)])
      names(data)[2] = "parameterValue"
      samplingPoints = data[data$time %in% sampling, ]

      ggplot(data, aes(x = time, y = parameterValue)) +
        geom_line() +
        geom_point(data = samplingPoints, color = "red") +
        labs(
          y = paste0("df/d", parameterName),
          x = paste0(
            "Time (", unitXAxis, ")\n\n",
            "Design: ", gsub("_", " ", designName), "   ",
            "Arm: ", armName, "   ",
            "Output: ", outputName, "   ",
            "Parameter: ", parameterName
          )
        ) +
        scale_x_continuous(
          breaks   = pretty_breaks(n = 10),
          sec.axis = sec_axis(~., breaks = round(sampling, 2), name = "Sampling times")
        ) +
        scale_y_continuous(
          breaks = pretty_breaks(n = 10),
          limits = c(minYAxis, maxYAxis)
        ) +
        theme(
          legend.position  = "none",
          axis.title.x.top = element_text(color = "red", vjust = 2.0),
          axis.text.x.top  = element_text(angle = 90, hjust = 0, color = "red"),
          plot.title       = element_text(size = 16, hjust = 0.5),
          axis.title.x     = element_text(size = 16),
          axis.title.y     = element_text(size = 16),
          axis.text.x      = element_text(size = 16, angle = 90, vjust = 0.5),
          axis.text.y      = element_text(size = 16),
          strip.text.x     = element_text(size = 16)
        )
    })
  })
  plotList[[designName]][[armName]] = map2(outputNames, plots, ~ setNames(.y, parametersNames)) %>%
    set_names(outputNames)
  return(plotList)
}
