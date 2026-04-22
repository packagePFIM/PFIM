#' @title MultiplicativeAlgorithm Class
#' @name MultiplicativeAlgorithm
#' @description
#' The \code{MultiplicativeAlgorithm} class implements the multiplicative algorithm
#' for the continuous optimization of study design weights. This approach iteratively
#' updates weights to maximize a specific optimality criterion (e.g., D-optimality).
#' @inheritParams Optimization
#' @param lambda A \code{numeric} value for the relaxation parameter \code{lambda}
#' (typically between 0 and 1).
#' @param delta A \code{numeric} convergence criterion \code{delta}.
#' @param numberOfIterations Maximum \code{integer} number of iterations to perform.
#' @param weightThreshold A \code{numeric} threshold; weights below this value
#' are considered zero and effectively removed from the design.
#' @param showProcess \code{logical}; if \code{TRUE}, displays the optimization
#' progress and convergence status in the console.
#' @param multiplicativeAlgorithmOutputs A \code{list} storing optimization
#' results, including weight history and optimality criterion values.
#' @include Optimization.R
#' @examples
#' \dontrun{
#' # Example from Vignette 1: Initializing the Multiplicative algorithm for population FIM optimization
#'
#' optimizationMultPopFIM = Optimization(
#'   name                = "PKPD_ODE_multi_doses_populationFIM",
#'   modelEquations      = modelEquations,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   optimizer           = "MultiplicativeAlgorithm",
#'   optimizerParameters = list(
#'     lambda             = 0.99,    # near-unity: slow but stable weight updates
#'     numberOfIterations = 1000,    # maximum multiplicative iterations
#'     weightThreshold    = 0.01,    # discard protocols with weight < 1%
#'     delta              = 1e-04,   # stop when D-criterion improvement < 0.01%
#'     showProcess        = TRUE
#'   ),
#'   designs             = list(designConstraint),
#'   fimType             = "population",
#'   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#'   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
#' )
#'
#' # Run the optimization and display results
#' optimizationResults = run(optimizationMultPopFIM)
#' show(optimizationResults)
#' }
#' @template copyright
#' @export

MultiplicativeAlgorithm = new_class("MultiplicativeAlgorithm",
                                    package = "PFIM",
                                    parent = .Optimization_S7,

                                    properties = list(
                                      lambda = new_property(class_numeric, default = 0.0),
                                      delta = new_property(class_numeric, default = 0.0),
                                      numberOfIterations = new_property(class_numeric, default = 0),
                                      weightThreshold = new_property(class_numeric, default = 0.0),
                                      showProcess = new_property(class_logical, default = FALSE),
                                      multiplicativeAlgorithmOutputs = new_property(class_list, default = list())
                                    ))

plotWeightsMultiplicativeAlgorithm = new_generic( "plotWeightsMultiplicativeAlgorithm", c( "optimization", "optimizationAlgorithm" ) )

# ==============================================================================
#' @title Rcpp Multiplicative Algorithm for Optimal Design
#' @name MultiplicativeAlgorithm_Rcpp
#' @description
#' Executes the high-performance C++ implementation of the multiplicative algorithm.
#' This function serves as the computational engine for the \code{MultiplicativeAlgorithm}
#' class, processing Fisher Information Matrices (FIM) from multiple arms to
#' determine the optimal weight distribution.
#' @param fisherMatrices_input A \code{list} or \code{vector} of flattened Fisher
#' Information Matrices for each candidate elementary design arm.
#' @param numberOfFisherMatrices_input An \code{integer} specifying the total
#' number of candidate arms.
#' @param weights_input A \code{numeric} vector of initial weights (must sum to 1).
#' @param numberOfParameters_input The number of fixed parameters in the model.
#' @param dim_input The dimension of the matrices (typically equal to
#' \code{numberOfParameters_input}).
#' @param lambda_input Relaxation parameter for weight updates (step size).
#' @param delta_input Convergence threshold for the optimality criterion.
#' @param iterationInit_input Maximum number of iterations allowed for the C++ solver.
#' @return A \code{list} containing:
#' \itemize{
#'   \item \code{weights}: The vector of optimized design weights.
#'   \item \code{criterion}: The final value of the optimality criterion.
#'   \item \code{iterations}: The number of iterations performed.
#'   \item \code{convergence}: A \code{logical} indicating if the convergence
#'   criterion was met.
#' }
#' @template copyright
#' @export
# ==============================================================================

MultiplicativeAlgorithm_Rcpp = function(fisherMatrices_input,
                                        numberOfFisherMatrices_input,
                                        weights_input,
                                        numberOfParameters_input,
                                        dim_input,
                                        lambda_input,
                                        delta_input,
                                        iterationInit_input){
  incltxt = '

// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
using namespace arma;

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h> 	/* Mathematical functions */
#include <time.h>	/* Function time used to initialise the random number generator */
#include <float.h>	/* Implementation related constants */
#include <signal.h>	/* Signal handling used to detect arithmetic errors */

/******************************************************************************
 MultiplicativeAlgorithm_Rcpp
*******************************************************************************/

// [[Rcpp::export]]
List MultiplicativeAlgorithm_Rcpp( List fisherMatrices,
                    arma :: vec  numberOfFisherMatrices,
                    arma :: vec  weights,
                    arma :: vec  numberOfParameters,
                    arma :: vec  dim,
                    arma :: vec  lambda,
                    arma :: vec  delta,
                    arma :: vec  iterationInit)
 {

arma :: mat sum_weighted_fims(dim[0],dim[0]);
arma :: vec determinant;
arma :: vec Dcriteria;
arma :: mat derivative_phi(dim[0],dim[0]);
arma :: vec vector_of_multiplier(numberOfFisherMatrices[0]);
arma :: mat matmult(dim[0],dim[0]);

int iter;
for( iter=0 ; iter < iterationInit[0] ; iter ++){

//Rcout << "iteration = " << iter << std::endl;

// sum_weighted_fims =  weights[i]*fims[i]
int i;
for(i=0 ; i<numberOfFisherMatrices[0] ; i++){
sum_weighted_fims += Rcpp::as<arma::mat>( fisherMatrices[i])*weights[i];
}

// determinant of sum_weighted_fims
determinant = det( sum_weighted_fims );

// D-criteria
Dcriteria = pow(determinant,1/dim[0]);

// derivatives of function phi_D
derivative_phi = Dcriteria[0] * inv(sum_weighted_fims)/dim[0];

// vector of multiplier
for(i=0 ; i<numberOfFisherMatrices[0] ; i++){
matmult = derivative_phi * Rcpp::as<arma::mat>( fisherMatrices[i]);
vector_of_multiplier[i] = sum(matmult.diag());
}

// normalization of the weights
weights = weights % pow(vector_of_multiplier,lambda[0]) / sum(weights % pow(vector_of_multiplier,lambda[0]));

// stop criterion
 if (vector_of_multiplier.max()<(1+delta[0])*sum(weights%vector_of_multiplier))
        {
          break;
        }

} // end iteration

// output
return Rcpp::List::create( Rcpp::Named ("weights") = weights,
                           Rcpp::Named ("iterationEnd") = iter);

} // end MultiplicativeAlgorithm_Rcpp
'

MultiplicativeAlgorithm_Rcpp = inline::cxxfunction(

  signature( fisherMatrices_input = "list",
             numberOfFisherMatrices_input = "integer",
             weights_input = "numeric",
             numberOfParameters_input = "integer",
             dim_input = "integer",
             lambda_input = "numeric",
             delta_input = "numeric",
             iterationInit_input = "integer"),

  plugin = "RcppArmadillo",
  incl = incltxt,
  body = '
          List fisherMatrices = Rcpp::as<List>(fisherMatrices_input);
          arma::vec numberOfFisherMatrices  = Rcpp::as<arma::vec>(numberOfFisherMatrices_input);
          arma::vec weights  = Rcpp::as<arma::vec>(weights_input);
          arma::vec numberOfParameters = Rcpp::as<arma::vec>(numberOfParameters_input);
          arma::vec dim = Rcpp::as<arma::vec>(dim_input);
          arma::vec lambda = Rcpp::as<arma::vec>(lambda_input);
          arma::vec delta = Rcpp::as<arma::vec>(delta_input);
          arma::vec iterationInit = Rcpp::as<arma::vec>(iterationInit_input);

          return Rcpp::wrap( MultiplicativeAlgorithm_Rcpp(  fisherMatrices,
                                                            numberOfFisherMatrices,
                                                            weights,
                                                            numberOfParameters,
                                                            dim,
                                                            lambda,
                                                            delta,
                                                            iterationInit ) );')

output = MultiplicativeAlgorithm_Rcpp( fisherMatrices_input,
                                       numberOfFisherMatrices_input,
                                       weights_input,
                                       numberOfParameters_input,
                                       dim_input, lambda_input,
                                       delta_input,
                                       iterationInit_input )
return( output )

}

# ==============================================================================
#' @rdname optimizeDesign
#' @name optimizeDesign
#' @export
# ==============================================================================

method( optimizeDesign, list( .Optimization_S7, MultiplicativeAlgorithm ) ) = function( optimizationObject, optimizationAlgorithm ) {

  # parameters of the optimization algorithm
  optimizerParameters = prop( optimizationObject, "optimizerParameters")
  lambda = optimizerParameters$lambda
  delta = optimizerParameters$delta
  numberOfIterations = optimizerParameters$numberOfIterations
  weightThreshold = optimizerParameters$weightThreshold

  # generate the Fims from administration and sampling times constraints
  fimsFromConstraints = generateFimsFromConstraints( optimizationObject )

  # run the multiplicative algorithm
  designs = prop( optimizationObject, "designs" )
  design = pluck( designs, 1 )
  optimalDesign = pluck( designs, 1 )

  # list for the evaluation of the optimal design
  evaluationOptimalDesignList = list()
  evaluationInitialDesignList = list()

  # design name
  designName = prop( design, "name" )

  # number of arms in the design
  numberOfArms = prop( design, "numberOfArms" )

  # set arms and fims from the evaluation of the constraints
  armFims = fimsFromConstraints$listArms[[designName]]
  fisherMatrices = fimsFromConstraints$listFimsAlgoMult[[designName]]

  # multiplicative algorithm parameters
  numberOfFisherMatrices = length( fisherMatrices )
  weights = rep( 1/numberOfFisherMatrices, numberOfFisherMatrices )
  dim = nrow( pluck( fisherMatrices,1 ) )
  numberOfParameters = length( prop( optimizationObject, "modelParameters" ) )

  # run the multiplicative algorithm
  multiplicativeAlgorithmOutput = MultiplicativeAlgorithm_Rcpp( fisherMatrices, numberOfFisherMatrices, weights, numberOfParameters, dim, lambda, delta, numberOfIterations )

  #get the optimal weights
  weights = multiplicativeAlgorithmOutput[["weights"]]
  weightsIndex = which( weights > weightThreshold )
  optimalWeights = weights[ weightsIndex ]

  # set the multiplicativeAlgorithmOutputs
  prop( optimizationAlgorithm, "multiplicativeAlgorithmOutputs" ) = list( armFims = armFims,
                                                                          multiplicativeAlgorithmOutput = multiplicativeAlgorithmOutput,
                                                                          numberOfArms = numberOfArms,
                                                                          weightThreshold = weightThreshold,
                                                                          weightsIndex = weightsIndex,
                                                                          optimalWeights = optimalWeights )

  # set the optimal arms to the optimal design
  fim =  prop( optimizationObject, "fim" )
  optimalArms = setOptimalArms( fim, optimizationAlgorithm )

  # set optimal arms
  prop( optimalDesign, "arms" ) = optimalArms

  # evaluate the optimal design
  evaluationOptimalDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( optimalDesign ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationOptimalDesign = run( evaluationOptimalDesign )

  # evaluate the initial design
  evaluationInitialDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( design ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationInitialDesign = run( evaluationInitialDesign )

  # set the results in evaluation
  prop( optimizationObject, "optimisationDesign" ) = list( evaluationInitialDesign = evaluationInitialDesign,
                                                           evaluationOptimalDesign = evaluationOptimalDesign )

  prop( optimizationObject, "optimisationAlgorithmOutputs" ) = list( "optimizationAlgorithm" = optimizationAlgorithm,
                                                                     "optimalArms" = optimalArms, optimalWeights = optimalWeights )

  return( optimizationObject )
}

# ==============================================================================
#' @title Visualize Optimal Weight Distribution from Multiplicative Algorithm
#' @name plotWeightsMultiplicativeAlgorithm
#' @description
#' Generates a bar plot representing the optimal weights allocated to each study
#' arm after the execution of the multiplicative algorithm. This visualization
#' quickly highlights which arms have been retained or prioritized by the
#' optimization process.
#' @param optimization An object of class \code{\link{Optimization}} containing
#' the optimized weights.
#' @param optimizationAlgorithm An object of class \code{\link{MultiplicativeAlgorithm}}
#' @param thresholdWeights An numeric threshold for the weights
#' used for the optimization.
#' @return A \code{ggplot2} graphical object representing the weights per arm.
#' @template copyright
# ==============================================================================

method( plotWeightsMultiplicativeAlgorithm, list( .Optimization_S7, MultiplicativeAlgorithm ) ) = function( optimization, optimizationAlgorithm, thresholdWeights = 0 )
{
  optimisationAlgorithmOutputs   = prop( optimization, "optimisationAlgorithmOutputs" )
  optimizationAlgorithm          = optimisationAlgorithmOutputs$optimizationAlgorithm
  multiplicativeAlgorithmOutputs = prop( optimizationAlgorithm, "multiplicativeAlgorithmOutputs" )

  weightsIndex   = as.integer( multiplicativeAlgorithmOutputs$weightsIndex )
  optimalWeights = as.numeric( multiplicativeAlgorithmOutputs$optimalWeights )

  keep        = optimalWeights > thresholdWeights
  optimalArms = data.frame(
    weightsIndex   = weightsIndex[ keep ],
    optimalWeights = optimalWeights[ keep ],
    stringsAsFactors = FALSE
  )

  weightPlot = ggplot( optimalArms, aes( x = reorder( weightsIndex, optimalWeights ), y = optimalWeights ) ) +
    geom_bar( stat = "identity", fill = "gray50" ) +
    scale_y_continuous( limits = c(0, 1), breaks = seq(0, 1, by = 0.1), minor_breaks = seq(0, 1, by = 0.05), expand = c(0, 0) ) +
    scale_x_discrete( expand = c(0, 0) ) +
    labs( x = "Arms", y = "Weights" ) +
    coord_flip() +
    theme_minimal( base_size = 14 ) +
    theme(
      plot.title         = element_text( hjust = 0.5, face = "bold" ),
      axis.title.x       = element_text( color = "black", margin = margin(t = 10) ),
      axis.title.y       = element_text( color = "black", margin = margin(r = 10) ),
      axis.text.x        = element_text( color = "black", margin = margin(t = 5) ),
      axis.text.y        = element_text( color = "black", margin = margin(r = 5) ),
      panel.grid.major.x = element_line( color = "gray90", linewidth = 0.5 ),
      panel.grid.minor.x = element_line( color = "gray95", linewidth = 0.3 ),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.border       = element_rect( color = "gray80", fill = NA, linewidth = 0.5 ),
      plot.margin        = margin(10, 10, 10, 10) )

  return( weightPlot )
}

# ==============================================================================
#' @rdname constraintsTableForReport
#' @name constraintsTableForReport
#' @export
# ==============================================================================

method( constraintsTableForReport, MultiplicativeAlgorithm ) = function( optimizationAlgorithm, arms  )
{
  armsConstraints = map( pluck( arms, 1 ) , ~ getArmConstraints( .x, optimizationAlgorithm ) )
  armsConstraints = map_dfr( pluck( armsConstraints, 1), ~ as.data.frame(.x, stringsAsFactors = FALSE ) )
  colnames( armsConstraints ) = c( "Arms name" , "Number of subjects", "Outcome", "Initial samplings", "Fixed times", "Number of samplings optimisable","Dose constraints" )
  armsConstraintsTable = kbl( armsConstraints, align = c( "l","c","c","c","c","c","c") ) %>%
    kable_styling( bootstrap_options = c(  "hover" ), full_width = FALSE, position = "center", font_size = 13 )
  return( armsConstraintsTable )
}
