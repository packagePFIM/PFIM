#' @title PFIMProject Class
#' @name PFIMProject
#' @description
#' The `PFIMProject` class is the central orchestrator for a Population Fisher
#' Information Matrix (PFIM) analysis. It encapsulates all necessary components
#' for design evaluation or optimization, including structural models, statistical
#' parameters, experimental designs, and optimization settings.
#' @param name A string representing the name of the project or evaluation study.
#' @param modelEquations A list containing the mathematical equations of the model.
#' @param modelFromLibrary A list specifying the pre-defined model selected from the PFIM library.
#' @param modelParameters A list defining the fixed effects and random effects (variances) of the model.
#' @param modelError A list specifying the residual error model (e.g., constant, proportional, or combined).
#' @param optimizer A string identifying the optimization algorithm to be used (e.g., "Simplex", "Fedov").
#' @param optimizerParameters A list of settings for the chosen optimizer (e.g., iterations, tolerance).
#' @param outputs A list defining the observation variables or responses of the model.
#' @param designs A list of `Design` objects representing the experimental protocols to be evaluated.
#' @param fimType A string specifying the FIM calculation method (e.g., "Population", "Individual", "Bayesian").
#' @param fim An object of class \code{Fim} representing the computed Fisher Information Matrix.
#' @param odeSolverParameters A list containing technical settings for the ODE solver, such as \code{atol} and \code{rtol}.
#' @slot name \code{character}
#' @slot modelEquations \code{list}
#' @slot modelFromLibrary \code{list}
#' @slot modelParameters \code{list}
#' @slot modelError \code{list}
#' @slot optimizer \code{character}
#' @slot optimizerParameters \code{list}
#' @slot outputs \code{list}
#' @slot designs \code{list}
#' @slot fimType \code{character}
#' @slot fim \code{Fim}
#' @slot odeSolverParameters \code{list}
#' @include Fim.R
#' @template copyright
#' @export

PFIMProject = new_class("PFIMProject", package = "PFIM",
                        properties = list(
                          name = new_property(class_character, default = character(0)),
                          modelEquations = new_property(class_list, default = list()),
                          modelFromLibrary = new_property(class_list, default = list()),
                          modelParameters = new_property(class_list, default = list()),
                          modelError = new_property(class_list, default = list()),
                          optimizer = new_property(class_character, default = character(0)),
                          optimizerParameters = new_property(class_list, default = list()),
                          outputs = new_property(class_list, default = list()),
                          designs = new_property(class_list, default = list()),
                          fimType = new_property(class_character, default = character(0)),
                          fim = new_property(Fim, default = NULL),
                          odeSolverParameters = new_property(class_list, default = list())
                        ))

# ==============================================================================
# the new_generic
# ==============================================================================

# ==============================================================================
#' @title run
#' @name run
#' @description
#' This function performs the evaluation or the optimization of a experimental design
#' based on the settings provided in a \code{PFIMProject} object.
#' @param pfimproject An object of class \code{PFIMProject} containing the
#' project settings, model definitions, and design parameters.
#' @param ... Additional arguments.
#' @examples
#' \dontrun{
#' # Execute the evaluation process
#' results = run(evaluationPopObject)
#' }
#' @template copyright
#' @export
# ==============================================================================

run = new_generic( "run", "pfimproject" )

# ==============================================================================
#' @title getFisherMatrix
#' @name getFisherMatrix
#' @description
#' Extracts partitioned components of the FIM for an \code{Evaluation} object.
#' @param pfimproject An object of class \code{Evaluation}.
#' @param ... Additional arguments.
#' @return A \code{list} with \code{fisherMatrix}, \code{fixedEffects},
#'   and \code{varianceEffects}.
#' @examples
#' \dontrun{
#' fisherMatrixComponents = getFisherMatrix(evaluationPopulationFIMResults)
#' # Access specific matrices
#' FIM             = fisherMatrixComponents$fisherMatrix
#' fixedEffects    = fisherMatrixComponents$fixedEffects
#' varianceEffects = fisherMatrixComponents$varianceEffects
#' }
#' @template copyright
#' @export
# ==============================================================================

getFisherMatrix = new_generic( "getFisherMatrix", c( "pfimproject" ) )

# ==============================================================================
#' @title show
#' @name show
#' @description
#' Displays a formatted summary of a \code{PFIMProject} object including the FIM,
#' standard errors, and design metrics.
#' @param pfimproject The object to be displayed.
#' @param ... Additional arguments.
#' @return Invisibly prints the FIM summary to the console.
#' @examples
#' \dontrun{
#' # Show the results of the evaluationPopulationFIMResults
#' show(evaluationPopulationFIMResults)
#'}
#' @template copyright
#' @export
# ==============================================================================

show = S7::new_generic( "show", c( "pfimproject" ) )

# ==============================================================================
#' @title plotEvaluation
#' @name plotEvaluation
#' @description
#' Generates graphical representations of model responses based on the design
#' and parameters defined in the PFIM project.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A named list of plots per design.
#' @examples
#' \dontrun{
#' # Plot the model responses from evaluationPopulationFIMResults
#' plotEvaluation(evaluationPopulationFIMResults, plotOptions = plotOptions)
#' }
#' @template copyright
#' @export
# ==============================================================================

plotEvaluation = new_generic( "plotEvaluation", c( "pfimproject" ) )

# ==============================================================================
#' @title plotSensitivityIndices
#' @name plotSensitivityIndices
#' @description
#' Generates sensitivity index plots (partial derivatives of model responses
#' with respect to population parameters).
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A named list of sensitivity index plots per design.
#' @examples
#' \dontrun{
#' plot the sensitivity indices from evaluationPopulationFIMResults
#' plotSensitivityIndices( evaluationPopulationFIMResults, plotOptions = plotOptions )
#' }
#' @template copyright
#' @export
# ==============================================================================

plotSensitivityIndices = new_generic( "plotSensitivityIndices", c( "pfimproject" ) )

# ==============================================================================
#' @title plotSE
#' @name plotSE
#' @description
#' Bar plot of Standard Errors (SE) for fixed effects and variance components.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A bar plot of SE values.
#' @examples
#' \dontrun{
#' # plotSE from evaluationPopulationFIMResults
#' plotSE( evaluationPopulationFIMResults )
#' }
#' @template copyright
#' @export
# ==============================================================================

plotSE = new_generic( "plotSE", c( "pfimproject" ) )

# ==============================================================================
#' @title plotRSE
#' @name plotRSE
#' @description
#' Bar plot of Relative Standard Errors (RSE, \%) for the model parameters.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A bar plot of RSE (\%) values.
#' @examples
#' \dontrun{
#' # Extract Relative Standard Errors from evaluationPopulationFIMResults
#' se = getSE(evaluationPopulationFIMResults)
#' print(se)
#' }
#' @template copyright
#' @export
# ==============================================================================

plotRSE = new_generic( "plotRSE", c( "pfimproject" ) )















# ==============================================================================
#' @title getSE
#' @name getSE
#' @description
#' Retrieves the Standard Errors (SE) from the Fisher Information Matrix.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A numeric vector of SE values for each model parameter.
#' @examples
#' \dontrun{
#' # Extract Standard Errors from evaluationPopulationFIMResults
#' se = getSE(evaluationPopulationFIMResults)
#' print(se)
#' }
#' @template copyright
#' @export
# ==============================================================================

getSE = new_generic( "getSE", c( "pfimproject" ) )

# ==============================================================================
#' @title getRSE
#' @name getRSE
#' @description
#' Retrieves the Relative Standard Errors (RSE, \%) from the FIM.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A numeric vector of RSE (\%) values for each model parameter.
#' @examples
#' \dontrun{
#' # Extract RSE (%) for all model parameters for evaluationPopulationFIMResults
#' rse = getRSE(evaluationPopulationFIMResults)
#' # Display the RSE values
#' print(rse)
#' }
#' @template copyright
#' @export
# ==============================================================================

getRSE = new_generic( "getRSE", c( "pfimproject" ) )

# ==============================================================================
#' @title getShrinkage
#' @name getShrinkage
#' @description
#' Retrieves shrinkage values for the random effects (omega), measuring how
#' individual estimates are shrunk toward the population mean.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A numeric vector of shrinkage values for each random effect.
#' @examples
#' \dontrun{
#'
#' # Extract the shrinkage values from the Bayesian FIM evaluation results
#' shrinkage = getShrinkage(evaluationBayesianFIMResults)
#' print(shrinkage)
#'
#' }
#' @template copyright
#' @export
# ==============================================================================

getShrinkage = new_generic( "getShrinkage", c( "pfimproject" ) )

# ==============================================================================
#' @title getDeterminant
#' @name getDeterminant
#' @description
#' Returns the determinant of the Fisher Information Matrix (FIM),
#' a global measure of design information used for D-optimality.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A numeric value representing the determinant of the FIM.
#' @examples
#' \dontrun{
#'
#' # Extract the determinant of the Fisher Information Matrix (FIM)
#' determinant = getDeterminant(evaluationPopulationFIMResults)
#'
#' # Display the determinant value
#' print(determinant)
#'
#' }
#' @template copyright
#' @export
# ==============================================================================

getDeterminant = new_generic( "getDeterminant", c( "pfimproject" ) )

# ==============================================================================
#' @title getDcriterion: Extract the D-optimality criterion
#' @description
#' Returns the D-criterion derived from the determinant of the FIM, normalized
#' by the number of parameters for cross-design comparisons.
#' @name getDcriterion
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A numeric value representing the D-criterion.
#' @examples
#' \dontrun{
#'
#' # Examples from Vignette 1 and 2
#'
#' # Extract the D-criterion from the FIM evaluation results
#' dCriterion = getDcriterion(evaluationPopulationFIMResults)
#'
#' # Display the D-criterion value
#' print(dCriterion)
#'
#' }
#' @template copyright
#' @export
# ==============================================================================

getDcriterion = new_generic( "getDcriterion", c( "pfimproject" ) )

# ==============================================================================
#' @title getCorrelationMatrix
#' @name getCorrelationMatrix
#' @description
#' Returns the correlation matrix of parameter estimates derived from the
#' asymptotic variance-covariance matrix \eqn{C = M^{-1}}, where \eqn{M} is
#' the FIM. Formally: \eqn{R_{ij} = C_{ij} / \sqrt{C_{ii} C_{jj}}}.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments.
#' @return A symmetric correlation matrix with values in \eqn{[-1, 1]} and
#'   ones on the diagonal.
#' @examples
#' \dontrun{
#'
#' # Extract and print the correlation matrix from the FIM evaluation results
#' correlationMatrix = getCorrelationMatrix(evaluationPopulationFIMResults)
#'
#' # Display the matrix
#' print(correlationMatrix)
#'
#' }
#' @template copyright
#' @export
# ==============================================================================

getCorrelationMatrix = new_generic( "getCorrelationMatrix", c( "pfimproject" ) )

# ==============================================================================
#' @title Report
#' @name Report
#' @description
#' Creates a detailed HTML report from the design evaluation results,
#' including tables, matrices, and plots.
#' @param pfimproject An object of class \code{PFIMProject}.
#' @param ... Additional arguments: outputPath, outputFile, plotOptions
#' @return Generates and saves an HTML report to \code{outputPath/outputFile}.
#' @examples
#' \dontrun{
#'
#' # Examples from Vignette 1 and 2
#'
#' # Generate a comprehensive HTML report for the design evaluation
#' Report(
#'   pfimproject = evaluationPopulationFIMResults,
#'   outputPath  = "C:/MyResults",
#'   outputFile  = "Design_Evaluation_Report.html",
#'   plotOptions = plotOptions
#' )
#'
#' }
#' @template copyright
#' @export
# ==============================================================================

Report = new_generic( "Report", c( "pfimproject" ) )

# ==============================================================================
# the methods
# ==============================================================================

# ==============================================================================
#' @name defineFim
#' @title Define the Fisher Information Matrix object
#' @description
#' This method initializes and configures the specific type of Fisher Information Matrix
#' to be calculated within a \code{PFIMProject}. It maps the project's statistical
#' assumptions (Population, Individual, or Bayesian) to the underlying FIM computational engine.
#' \itemize{
#'   \item \bold{Population:} For Nonlinear Mixed Effects Models (NLME), accounting for inter-individual variability.
#'   \item \bold{Individual:} For standard fixed-effects models where only one subject/profile is considered.
#'   \item \bold{Bayesian:} When prior distributions for the parameters are incorporated into the information matrix.
#' }
#' @param pfimproject An object of class \code{\link{PFIMProject}} containing the
#' model and design specifications.
#' @param ... Additional arguments.
#' @return An object of class \code{\link{Fim}} initialized with the settings
#' defined in the project.
#' @template copyright
#' @export
# ==============================================================================

defineFim = new_generic( "defineFim", c( "pfimproject" ) )

method( defineFim, PFIMProject ) = function( pfimproject )
{
  fimType = prop(pfimproject, "fimType")
  fim = switch(fimType,
               "population" = PopulationFim(),
               "individual" = IndividualFim(),
               "Bayesian"   = BayesianFim(),
               stop(sprintf(
                 "Unknown fimType: '%s'. Must be one of: 'population', 'individual', 'Bayesian'.",
                 fimType
               ))
  )
  return(fim)
}

# ==============================================================================
#' @title defineModelType
#' @name defineModelType
#' @description
#' The method acts as a constructor for the specific model class
#' required for analysis. It extracts configurations from a \code{\link{PFIMProject}}
#' and instantiates a \code{Model} object, integrating equations, parameter
#' structures, error models, and solver settings.
#' @details
#' This method determines whether the model should be treated as a:
#' \itemize{
#'   \item \bold{Library Model:} Pre-defined structural models (e.g., 1-compartment PK).
#'   \item \bold{User-Defined Model:} Custom equations provided via \code{modelEquations}.
#'   \item \bold{ODE Model:} Models requiring numerical integration using specified
#'   \code{odeSolverParameters}.
#' }
#' @param pfimproject An object of class \code{\link{PFIMProject}} containing
#' the project specifications.
#' @param ... Additional arguments.
#' @return An object of class \code{Model} (or a subclass thereof) initialized
#' with \code{modelParameters}, \code{odeSolverParameters}, \code{modelError},
#' and \code{modelEquations}.
#' @template copyright
#' @export
# ==============================================================================

defineModelType = new_generic( "defineModelType", c( "pfimproject" ) )

method( defineModelType, PFIMProject ) = function( pfimproject )
{
  isModelODE = FALSE
  isModelInfusion = FALSE
  isDoseInEquation = FALSE
  isDoseInInitialConditions = FALSE

  equations = prop( pfimproject, "modelEquations" )
  parameters = prop( pfimproject, "modelParameters")

  #  check if model ode
  isModelODE = getListLastName( equations ) %>% str_detect("Deriv_") %>% any()

  # check if model analytic
  isModelAnalytic = !( getListLastName( equations ) %>% str_detect("Deriv_") %>% all() )

  # check if model steady state
  isTauInEquations = equations %>% map_lgl( ~ if ( is.list(.x) ) {
    any( map_lgl( .x, ~ str_detect( .x, "tau" ) ) )
  } else {
    str_detect( .x, "tau" )
  }) %>% any()

  # check if mode infusion
  isModelInfusion = equations %>% map_lgl( ~ if ( is.list(.x) ) {
    any( map_lgl( .x, ~ str_detect( .x, "Tinf_") ) )
  } else {
    str_detect( .x, "Tinf_" )
  }) %>% any()

  # check if dose in equations
  isDoseInEquation = equations %>% map_lgl( ~ if ( is.list(.x) ) {
    any( map_lgl( .x, ~ str_detect( .x, "dose_" ) ) )
  } else {
    str_detect( .x, "dose_" )
  }) %>% any()

  # check if dose in initial conditions
  initialConditions = pfimproject %>%
    pluck( "designs" ) %>%
    map(~ {
      arms = pluck( .x, "arms" )
      names( arms ) = map_chr( arms, ~ prop( .x, "name" ) )
      map( arms, ~ pluck( .x, "initialConditions" ) )
    }) %>%
    unlist()

  isDoseInInitialConditions = any( map_lgl( initialConditions, ~ str_detect( .x, "dose_" ) ) )

  # define the class of the model
  if ( isModelODE ){
    # ode model dose defined in equations
    if ( isDoseInEquation )
    {
      model = ModelODEDoseInEquations()
    }
    # ode model dose as cmpt
    if ( !isDoseInEquation )
    {
      model = ModelODEDoseNotInEquations()
    }
    # ode model & infusion & dose defined in equations
    if ( isModelInfusion & isDoseInEquation )
    {
      model = ModelODEInfusionDoseInEquation()
    }
    # ode model bolus & dose defined in initial conditions
    if ( isDoseInInitialConditions )
    {
      model = ModelODEBolus()
    }
  }

  if ( isModelAnalytic ){
    if ( !isModelInfusion & !isTauInEquations )
    {
      # model analytic
      model = ModelAnalytic()
    }
    if ( !isModelInfusion & isTauInEquations )
    {
      # ModelAnalyticSteadyState
      model = ModelAnalyticSteadyState()
    }
    if ( isModelInfusion & isDoseInEquation )
    {
      # model analytic with infusion
      model = ModelAnalyticInfusion()
    }
    if ( isModelInfusion & isDoseInEquation & isTauInEquations )
    {
      # model analytic with infusion
      model = ModelAnalyticInfusionSteadyState()
    }
  }
  # model parameters order by names
  prop( model, "modelParameters") = parameters
  prop( model, "odeSolverParameters") = prop( pfimproject, "odeSolverParameters" )
  prop( model, "modelError") = prop( pfimproject, "modelError" )
  prop( model, "modelEquations") = equations

  return( model )
}

# ==============================================================================
#' @title defineModelEquationsFromLibraryOfModel
#' @name defineModelEquationsFromLibraryOfModel
#' @description
#' The  method extracts the structural
#' mathematical equations from the pre-defined PFIM library. This allows users
#' to leverage standard pharmacokinetic (PK) and pharmacodynamic (PD) models
#' without manually defining differential or algebraic equations.
#' @details
#' This function references the \code{modelFromLibrary} property of the
#' \code{PFIMProject}. It maps library identifiers to a specific set of
#' symbolic or numeric equations used by the evaluation engine.
#' Typical library models include:
#' \itemize{
#'   \item \bold{One-compartment:} Bolus, Infusion, or First-order absorption.
#'   \item \bold{Multi-compartment:} Distribution models with various elimination routes.
#'   \item \bold{Standard PD:} Emax, Sigmoid Emax, or Indirect response models.
#' }
#' @param pfimproject An object of class \code{\link{PFIMProject}} containing
#' the library selection criteria.
#' @param ... Additional arguments.
#' @return A \code{list} of character strings or expressions representing the
#' structural model equations.
#' @template copyright
#' @export
# ==============================================================================

defineModelEquationsFromLibraryOfModel = new_generic( "defineModelEquationsFromLibraryOfModel", c( "pfimproject" ) )

method(defineModelEquationsFromLibraryOfModel, PFIMProject) = function(pfimproject)
{
  equations    = prop(pfimproject, "modelFromLibrary")
  pdModelName  = equations[["PDModel"]]
  pkModels = prop(LibraryOfPKModels, "models")
  prop(pfimproject, "modelEquations") = pkModels[[equations[["PKModel"]]]]
  pkModel = defineModelType(pfimproject)

  if (!is.null(pdModelName)) {
    pdModels = prop(LibraryOfPDModels, "models")
    prop(pfimproject, "modelEquations") = pdModels[[equations[["PDModel"]]]]
    pdModel = defineModelType(pfimproject)
    pkpdModelEquations = definePKPDModel(pkModel, pdModel, pfimproject)
  } else {
    pkpdModelEquations = definePKModel(pkModel, pfimproject)
  }
  return(pkpdModelEquations)
}
