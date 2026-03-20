#' @title ModelParameter Class
#' @name ModelParameter
#' @description
#' The \code{ModelParameter} class defines the characteristics of a model parameter,
#' including its identifier (name), statistical distribution (mean and variance),
#' and the estimation status of its components.
#' @slot name \code{character}. A unique string identifying the parameter.
#' @slot distribution \code{Distribution}. An object of class \code{Distribution}
#' defining the statistical law (e.g., Log-Normal, Normal).
#' @slot fixedMu \code{logical}. If \code{TRUE}, the population mean is
#' fixed and will not be estimated.
#' @slot fixedOmega \code{logical}. If \code{TRUE}, the inter-individual
#' variability (omega) is fixed and will not be estimated.
#' @param name The parameter name (string).
#' @param distribution A \code{Distribution} object.
#' @param fixedMu Logical; indicates if the mean is fixed. Defaults to \code{FALSE}.
#' @param fixedOmega Logical; indicates if the variance is fixed. Defaults to \code{FALSE}.
#' @return An object of class \code{ModelParameter}.
#' @examples
#' # 1. Clearance with estimated mean and estimated variance (mu and omega)
#' clEstimated = ModelParameter(
#'   name         = "Cl",
#'   distribution = LogNormal(mu = 0.28, omega = 0.456),
#'   fixedMu      = FALSE,
#'   fixedOmega   = FALSE
#' )
#' print(clEstimated)
#'
#' # 2. Clearance with fixed mean and fixed variance
#' # Useful for parameters known from literature (e.g., mu = log(20) approx 2.99)
#' clFixed = ModelParameter(
#'   name         = "Cl",
#'   distribution = LogNormal(mu = 2.99, omega = 0.1),
#'   fixedMu      = TRUE,
#'   fixedOmega   = TRUE
#' )
#' print(clFixed)
#' @template copyright
#' @export

ModelParameter = new_class( "ModelParameter",
                            package = "PFIM",
                            properties = list(
                              name = new_property(class_character, default = character(0)),
                              distribution =  new_property(Distribution, default = NULL),
                              fixedMu = new_property(class_logical, default = FALSE),
                              fixedOmega = new_property(class_logical, default = FALSE)))

getModelParametersData = new_generic( "getModelParametersData", c( "modelParameter" ) )

# ==============================================================================
#' @title Extract Model Parameter Data for Reporting
#' @name getModelParametersData
#' @description
#' The \code{getModelParametersData} function retrieves and summarizes the properties
#' of all parameters within a \code{Model} object. It compiles their statistical
#' characteristics—including distribution types, population means, and variability—into
#' a structured \code{data.frame} suitable for display or export.
#' @param model A \code{Model} object containing a collection of \code{ModelParameter} instances.
#' @return A \code{data.frame} with the following columns:
#' \itemize{
#'   \item \code{Parameter}: The unique identifier of the parameter (e.g., "Cl", "V").
#'   \item \code{Distribution}: The statistical law applied (e.g., "Normal", "Log-Normal").
#'   \item \code{Mu}: The population mean value.
#'   \item \code{Fixed_Mu}: Logical; \code{TRUE} if the mean is fixed (not estimated).
#'   \item \code{Omega}: The inter-individual variability (IIV) value.
#'   \item \code{Fixed_Omega}: Logical; \code{TRUE} if the variance is fixed.
#' }
#' @template copyright
#' @export
# ==============================================================================

method( getModelParametersData, ModelParameter ) = function( modelParameter ) {

  modelParametersData = list(modelParameter) %>%
    map(function(parameter) {
      dist = prop(parameter, "distribution")
      list(
        Parameters = prop(parameter, "name"),
        mu = as.character(prop(dist, "mu")),
        omega2 = as.character(prop(dist, "omega")^2),
        Distribution = str_remove(class(dist)[1], "PFIM::"),
        mu_fixed = as.character(prop(parameter, "fixedMu")),
        omega2_fixed = as.character(prop(parameter, "fixedOmega"))
      )
    }) %>%
    map(~ as.data.frame(.x, stringsAsFactors = FALSE)) %>%
    list_rbind()

  return( modelParametersData )

}

