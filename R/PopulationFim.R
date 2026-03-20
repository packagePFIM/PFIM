#' @title PopulationFim Class
#' @name PopulationFim
#' @description
#' The \code{PopulationFim} class is a child of the \code{Fim} class. It is
#' specifically designed to store and manage the Fisher Information Matrix
#' calculated for population-level analyses. Unlike individual FIMs, it
#' incorporates the variance-covariance components of the random effects,
#' providing a measure of the information content regarding both structural
#' and statistical parameters.
#' \itemize{
#'   \item Determining the Standard Errors (SE) of population parameters.
#'   \item Calculating the Relative Standard Errors (RSE\%).
#'   \item Evaluating and optimizing designs for clinical trials.
#' }
#' @inheritParams Fim
#' @template copyright
#' @export

PopulationFim = new_class( "PopulationFim", package = "PFIM", parent = Fim )

# ==============================================================================
#' @title Evaluate the Population Fisher Information Matrix
#' @name evaluateFim
#' @description
#' The \code{evaluateFim} method computes the numerical values of the Fisher Information
#' Matrix (FIM) for a given experimental design (arm). It integrates the structural
#' model, the parameter variances, and the residual error model to quantify the
#' expected precision of parameter estimates.
#' This method specifically computes:
#' \itemize{
#'   \item \bold{The Fisher Matrix:} The expected information content for fixed and random effects.
#'   \item \bold{Shrinkage:} An estimation of the "shrinkage" towards the population mean,
#'   providing insight into how well the design informs individual parameters.
#' }
#' @param fim An object of class \code{\link{PopulationFim}} to be populated with results.
#' @param model An object of class \code{Model} containing the structural equations
#' and parameter values.
#' @param arm An object of class \code{Arm} representing the sampling schedule and
#' dose levels for a specific group.
#' @return An object of class \code{PopulationFim} (updated with the \code{fisherMatrix}
#' and calculated \code{shrinkage} values).
#' @template copyright
#' @export
# ==============================================================================

method( evaluateFim, list( PopulationFim, Model, Arm ) ) = function( fim, model, arm ) {

  # variance for the FIM
  evaluateVarianceFIM = evaluateVarianceFIM( fim, model, arm )
  V = evaluateVarianceFIM$V
  MFVar = evaluateVarianceFIM$MFVar

  # fixed mu and fixed omega
  parameters = prop( model, "modelParameters")
  indexParameterNamesFixedMu = which( map_lgl( parameters, ~ prop( .x, "fixedMu" ) == TRUE ) )
  indexParameterNamesFixedOmega = which( map_lgl( parameters, ~ prop( .x, "fixedOmega" ) == TRUE ) )

  # omega = 0 ie fixed omega
  indicesOmegaZero = imap(parameters, ~ if (.x@distribution@omega == 0) .y) %>% compact() %>% unlist()
  indexParameterNamesFixedOmega = unique(c(indexParameterNamesFixedOmega, indicesOmegaZero ))

  indicesMuZero = imap(parameters, ~ if (.x@distribution@mu == 0) .y) %>% compact() %>% unlist()
  indexParameterNamesFixedMu = unique(c(indexParameterNamesFixedMu, indicesMuZero ))

  evaluationGradients =  prop( arm, "evaluationGradients" ) %>% reduce( rbind ) %>% as.matrix()

  # components of the Fim
  if ( length( indexParameterNamesFixedMu ) != 0 )
  {
    evaluationGradients = prop( arm, "evaluationGradients" ) %>%
      reduce( rbind ) %>%
      { .[, -c( indexParameterNamesFixedMu ) ] } %>%
      as.matrix()
  }

  MFbeta = t( evaluationGradients ) %*% chol2inv( chol( V ) ) %*% evaluationGradients

  if ( length( indexParameterNamesFixedOmega ) != 0 )
  {
    MFVar = MFVar[ -c( indexParameterNamesFixedOmega ), -c( indexParameterNamesFixedOmega ) ]
  }

  # Fisher matrix & adjust Fisher matrix with the number of individuals
  MFbeta = MFbeta * prop( arm, "size" )
  MFVar = MFVar * prop( arm, "size" )

  prop( fim, "fisherMatrix" ) = as.matrix( bdiag( MFbeta, MFVar ) )

  return( fim )
}

# ==============================================================================
#' @title Compute Variance Matrix Component
#' @name computeVMat
#' @description
#' The \code{computeVMat} method calculates the V matrix for a given set of
#' model parameters. In the context of population modeling, V represents
#' the total variance of the data, integrating both the structural model
#' sensitivity to random effects and the residual error components.
#' @param varParam1 A numeric vector or matrix representing the first set of
#' variance components (typically related to the linearized structural model).
#' @param varParam2 A numeric vector or matrix representing the second set of
#' variance components (typically the residual error terms).
#' @param invCholV A logical or numeric matrix used for the Inverse Cholesky
#' decomposition of \eqn{V}, facilitating faster computation of the FIM and likelihood.
#' @return A square, symmetric matrix representing the total variance \code{V}
#' for the observations.
#' @template copyright
#' @export
#' =====================================================================

computeVMat = function( varParam1, varParam2, invCholV )
{
  1/2 * sum( diag( invCholV %*% varParam1 %*% invCholV %*% varParam2 ) )
}

# ==============================================================================
#' @title Evaluate the Variance Component of the Fisher Information Matrix
#' @name evaluateVarianceFIM
#' @description
#' The \code{evaluateVarianceFIM} method calculates the portion of the Fisher
#' Information Matrix that corresponds to the variance parameters of the
#' Nonlinear Mixed Effects Model. This includes the inter-individual
#' variability (random effects) and the residual error components.
#' @param arm An object of class \code{\link{Arm}} defining the experimental
#' design (sampling times, doses) for a group of subjects.
#' @param model An object of class \code{\link{Model}} containing the structural
#' equations and the statistical model for random effects.
#' @param fim An object of class \code{\link{PopulationFim}} used as the
#' container for the resulting matrices.
#' @return A \code{list} containing:
#' \itemize{
#'   \item \code{MFVar}: A matrix representing the Fisher Information for the
#'   variance parameters.
#'   \item \code{V}: The computed variance-covariance matrix of the observations.
#' }
#' @template copyright
#' @export
# ==============================================================================

method( evaluateVarianceFIM, list( PopulationFim, Model, Arm ) ) = function( fim, model, arm ) {

  parameters = prop( model, "modelParameters")
  parameterNames = map_chr( parameters, ~ prop( .x, "name" ) )

  evaluationVariance = prop( arm, "evaluationVariance")
  errorVariance = evaluationVariance$errorVariance
  sigmaDerivatives = evaluationVariance$sigmaDerivatives

  # matrix Omega
  omega = parameters %>% map_dbl( ~ pluck( .x, "distribution", "omega" ) ) %>% { (.^2) }

  # responses gradient adjusted
  gradient = prop( arm, "evaluationGradients" ) %>% reduce( rbind )

  adjustedGradient = map( parameters, function( parameter ) {
    distribution = prop( parameter, "distribution" )
    parameterName = prop( parameter, "name" )
    adjustGradient( distribution, gradient[,parameterName] )
  }) %>% reduce( rbind ) %>% t(.)

  # V matrix
  if ( length(omega)[1] == 1)
  { # cas omega is one scale
    adjustedGradient = matrix(adjustedGradient)
    V = omega * adjustedGradient %*% t( adjustedGradient ) + errorVariance
  }else
  {
    V = adjustedGradient %*% diag(omega) %*% t( adjustedGradient ) + errorVariance
  }

  # B Block
  dVdOmega = map( parameterNames, ~{
    iter = which( parameterNames == .x )
    dOmega = matrix( 0, ncol = length( parameters ), nrow = length( parameters ) )
    dOmega[iter, iter] = 1
    adjustedGradient %*% dOmega %*% t( adjustedGradient )
  }) %>% setNames( parameterNames )

  # V matrix
  dVdLambda = c( dVdOmega, sigmaDerivatives )
  invCholV = chol2inv( chol( V ) )
  VMat = outer( dVdLambda, dVdLambda, Vectorize( function(x, y) computeVMat( x, y, invCholV ) ) )
  MFVar = matrix( VMat, nrow = length( dVdLambda ), ncol = length( dVdLambda ) )

  return( list( MFVar = MFVar, V = V ) )
}

# ==============================================================================
#' @title Set Optimal Arms for the MultiplicativeAlgorithm and FedorovWynnAlgorithm
#' @name setOptimalArms
#' @description
#' The \code{setOptimalArms} method identifies and extracts the best performing
#' experimental arms from an optimization routine. It converts the output of
#' the \code{\link{MultiplicativeAlgorithm}} into a structured list of
#' optimized experimental designs.
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' Fisher Information Matrix evaluated at the optimal design points.
#' @param optimizationAlgorithm An object of class \code{\link{MultiplicativeAlgorithm}\link{FedorovWynnAlgorithm}}
#' representing the solver that has completed its execution.
#' sampling schedule and dosing protocols that maximize the optimization criterion.
#' @template copyright
#' @export
# ==============================================================================

method( setOptimalArms, list( PopulationFim, MultiplicativeAlgorithm ) ) = function( fim, optimizationAlgorithm ) {

  # get the parameters of the MultiplicativeAlgorithm
  multiplicativeAlgorithmOutputs = prop( optimizationAlgorithm, "multiplicativeAlgorithmOutputs" )

  # get the inputs arms and FIMs for the MultiplicativeAlgorithm
  armFims = multiplicativeAlgorithmOutputs$armFims
  multiplicativeAlgorithmOutput = multiplicativeAlgorithmOutputs$multiplicativeAlgorithmOutput
  numberOfArms = multiplicativeAlgorithmOutputs$numberOfArms

  # get the parameters of the MultiplicativeAlgorithm
  weights = multiplicativeAlgorithmOutputs$optimalWeights
  weightsIndex = multiplicativeAlgorithmOutputs$weightsIndex

  #number of individual per group
  numberOfIndividualPerGroupTmp = numberOfArms*weights
  numberOfIndividualPerGroup = numberOfIndividualPerGroupTmp / sum( numberOfIndividualPerGroupTmp )*numberOfArms

  armList = list()

  for( index in weightsIndex )
  {
    arm = pluck( armFims[[index]], 1 )
    prop( arm, "size" ) = numberOfIndividualPerGroup[ index == weightsIndex ]
    prop( arm, "name" ) = paste0( "Arm", index )
    armList = append( armList, arm )
  }

  # sort by decreasing order
  sizes = map_dbl( armList, "size" )
  orderIndices = order( sizes )
  optimalArms = armList[orderIndices]

  return( optimalArms )
}

method( setOptimalArms, list( PopulationFim, FedorovWynnAlgorithm ) ) = function( fim, optimizationAlgorithm ) {

  # get the parameters of the FedorovWynnAlgorithm
  FedorovWynnAlgorithmOutputs = prop( optimizationAlgorithm, "FedorovWynnAlgorithmOutputs" )

  numberOfIndividuals = FedorovWynnAlgorithmOutputs$numberOfIndividuals
  listArms = FedorovWynnAlgorithmOutputs$listArms

  optimalArms = imap(listArms, function(listArm, iter) {
    prop( listArm$arm, "size" ) = numberOfIndividuals[iter]
    prop( listArm$arm, "name" ) = paste0( "Arm", iter )
    return(listArm)
  })

  return( optimalArms )
}

# ==============================================================================
#' @title Finalize and Set Population FIM Results
#' @name setEvaluationFim
#' @description
#' The \code{setEvaluationFim} method processes the raw results from a model
#' evaluation to populate the detailed statistical slots of a \code{\link{PopulationFim}}
#' object. It transforms the Fisher Information Matrix into actionable
#' metrics like Standard Errors (SE) and Relative Standard Errors (RSE).
#' @param fim An object of class \code{\link{PopulationFim}} to be updated.
#' @param evaluation An object of class \code{Evaluation} containing the
#' outputs from the structural model and error engine.
#' @return The updated \code{\link{PopulationFim}} object, with the following slots
#' populated: \code{fisherMatrix}, \code{fixedEffects}, \code{shrinkage},
#' \code{condNumberFixedEffects}, and \code{SEAndRSE}.
#' @template copyright
#' @export
# ==============================================================================

method( setEvaluationFim, PopulationFim ) = function( fim, evaluation ) {

  # get parameters names and model error
  parameters = prop( evaluation, "modelParameters" )
  parametersNames = map_chr( parameters, ~ prop( .x, "name" ) )
  modelError = prop( evaluation, "modelError" )

  # Greek letter for column names
  greeksLetterForCOnsole = c( mu = "\u03bc_", omega = "\u03c9\u00B2_", sigma = "\u03c3" )

  # define the name for the columns and rows for mu, omega and sigma
  columnNamesMu = parameters %>%
    keep( ~ prop( .x, "fixedMu" ) == FALSE) %>%
    keep( ~ .x@distribution@mu != 0 ) %>%
    map_chr( "name" ) %>%
    map_chr(~ paste0( greeksLetterForCOnsole['mu'], .x ) )

  columnNamesOmega = parameters %>%
    keep( ~ prop( .x, "fixedOmega" ) == FALSE ) %>%
    keep( ~ .x@distribution@omega != 0 ) %>%
    map_chr( "name" ) %>%
    map_chr( ~ paste0( greeksLetterForCOnsole['omega'], .x ) )

  columnNamesSigma = map( modelError, ~{
    sigma = character()
    if ( prop( .x, "sigmaInter" ) != 0 && prop( .x, "sigmaInterFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_inter_", prop( .x ,"output" ) ) )
    if ( prop( .x, "sigmaSlope" ) != 0 && prop( .x, "sigmaSlopeFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_slope_", prop( .x ,"output" ) ) )
    return( sigma )
  }) %>% unlist()  %>% unname()

  # get mu values
  muValues = parameters %>% keep( ~ prop( .x, "fixedMu" ) == FALSE ) %>%
    keep( ~ .x@distribution@mu != 0 ) %>%
    map_dbl( ~ pluck( .x, "distribution", "mu" ) )

  # get omega values
  omegaValues = parameters %>%
    keep( ~ prop( .x, "fixedOmega" ) == FALSE ) %>%
    keep( ~ .x@distribution@omega != 0 ) %>%
    map_dbl( ~ pluck( .x, "distribution", "omega" ) ) %>% { (.^2) }

  # get sigma values
  sigmaValues = map( modelError, ~ {
    values = list()
    if ( prop( .x, "sigmaInter" ) !=0 && prop( .x, "sigmaInterFixed" ) == FALSE )
    {
      values$sigmaInter = prop( .x, "sigmaInter" )
    }
    if ( prop( .x, "sigmaSlope" ) !=0 && prop( .x, "sigmaSlopeFixed" ) == FALSE )
    {
      values$sigmaSlope =  prop( .x, "sigmaSlope" )
    }
    return( values )
  }) %>% unlist()

  # get fisherMatrix
  fisherMatrix = prop( fim, "fisherMatrix")
  colnames( fisherMatrix ) = c( columnNamesMu, columnNamesOmega, columnNamesSigma )
  rownames( fisherMatrix ) = c( columnNamesMu, columnNamesOmega, columnNamesSigma )

  # fixed effects and variance effects
  fixedEffects = fisherMatrix[ columnNamesMu, columnNamesMu ]
  varianceEffects = fisherMatrix[ c( columnNamesOmega, columnNamesSigma ), c( columnNamesOmega, columnNamesSigma ) ]

  # compute SE ans RSE
  SE = sqrt( diag( chol2inv( chol( fisherMatrix ) ) ) )

  parametersValues = c( muValues, omegaValues, sigmaValues )
  RSE = SE / parametersValues * 100

  SEAndRSE = data.frame( "parametersValues" = parametersValues, "SE" = SE, "RSE" = RSE )
  SE = data.frame( "parametersValues" = parametersValues, "SE" = SE )
  RSE = data.frame( "parametersValues" = parametersValues, "RSE" = RSE )

  rownames( SEAndRSE ) = rownames( fisherMatrix )
  rownames( SE ) = rownames( fisherMatrix )
  rownames( RSE ) = rownames( fisherMatrix )

  prop( fim, "fisherMatrix" ) = fisherMatrix
  prop( fim, "fixedEffects" ) = fixedEffects
  prop( fim, "varianceEffects" ) = varianceEffects
  prop( fim, "condNumberFixedEffects" ) = cond(fixedEffects)
  prop( fim, "condNumberVarianceEffects" ) = cond(varianceEffects)
  prop( fim, "SEAndRSE" ) = list( SE = SE, RSE = RSE, SEAndRSE = SEAndRSE )

  return( fim )
}

# ==============================================================================
#' @title Display FIM Results in the R Console
#' @name showFIM
#' @description
#' The \code{showFIM} method provides a comprehensive summary of the Fisher Information
#' Matrix (FIM) results. It prints structural and statistical metrics to the console,
#' allowing the user to evaluate parameter precision, numerical stability, and
#' optimization criteria for a specific design.
##' @param fim An object of class \code{IndividualFim} (or \code{PopulationFim})
#' containing the computed results.
#' @return This function returns a formatted summary to the console. It invisibly
#' returns a list containing the \code{fisherMatrix}, \code{fixedEffects},
#' \code{Determinant}, \code{conditionNumbers}, \code{D-criterion}, and \code{Shrinkage}.
#' @template copyright
#' @export
# ==============================================================================

method( showFIM, PopulationFim ) = function( fim ) {

  SEAndRSE = prop( fim, "SEAndRSE" )
  fisherMatrix = prop( fim, "fisherMatrix")
  fixedEffects =prop( fim, "fixedEffects")
  varianceEffects = prop( fim, "varianceEffects")
  condNumberFixedEffects = prop( fim, "condNumberFixedEffects" )
  condNumberVarianceEffects = prop( fim, "condNumberVarianceEffects" )

  RSE = SEAndRSE$SE
  RSE = SEAndRSE$RSE
  SEAndRSE = SEAndRSE$SEAndRSE

  Dcriterion = Dcriterion( fim )

  determinant = det( fisherMatrix )

  cat("\n*************************************** \n")
  cat(" Population Fisher Matrix \n" )
  cat("*************************************** \n\n")
  print( fisherMatrix )
  cat("\n*************************************** \n")
  cat(" Fixed effects \n" )
  cat("*************************************** \n\n")
  print( fixedEffects )
  cat("\n*************************************** \n")
  cat(" Variance components \n" )
  cat("*************************************** \n\n")
  print( varianceEffects )
  cat("\n********************************************* \n")
  cat(" Determinant, condition numbers and D-criterion  \n" )
  cat("*********************************************** \n\n")
  cat( c( "Determinant:", as.numeric(determinant) ), "\n")
  cat( c( "D-criterion:", as.numeric(Dcriterion) ), "\n")
  cat( c("Conditional number of the fixed effects:", as.numeric(condNumberFixedEffects) , "\n") )
  cat( c("Conditional number of the random effects:", as.numeric(condNumberVarianceEffects) , "\n") )
  cat("\n*************************************** \n")
  cat(" Parameters estimation \n" )
  cat("*************************************** \n\n")
  print( SEAndRSE )
}

# ==============================================================================
#' @title Plot Standard Errors from the Population FIM
#' @name plotSEFIM
#' @description
#' The \code{plotSEFIM} method generates a diagnostic bar plot representing the
#' Standard Errors (SE) or Relative Standard Errors (RSE\%) for all estimated
#' parameters. This visualization is crucial for comparing the precision
#' between structural parameters (fixed effects) and variance components.
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' calculated SE and RSE values.
#' @param evaluation An object of class \code{Evaluation} providing the
#' context of the model being plotted.
#' @return A \code{ggplot2} or base R plot object showing the bar plot of the
#' parameter uncertainties.
#' @template copyright
#' @export
# ==============================================================================

method( plotSEFIM, list( PopulationFim, PFIMProject ) ) = function( fim, evaluation ) {

  # get parameter names and model error
  parameters = prop( evaluation, "modelParameters" )
  modelError = prop( evaluation, "modelError" )

  # get SEAndRSE
  fim = prop( evaluation, "fim" )
  fim = setEvaluationFim( fim, evaluation )
  standardErrors = prop( fim, "SEAndRSE" )

  # Greek letter for column names
  greeksLetterForCOnsole = c( mu = "\u03bc", omega = "\u03c9\u00B2", sigma = "\u03c3" )

  parametersMu =  parameters %>%
    keep( ~ prop( .x, "fixedMu" ) == FALSE) %>%
    keep( ~ .x@distribution@mu != 0 ) %>%
    map_chr( "name" )

  parametersOmega = parameters %>%
    keep( ~ prop( .x, "fixedOmega" ) == FALSE ) %>%
    keep( ~ .x@distribution@omega != 0 ) %>%
    map_chr( "name" )

  parametersSigma = map( modelError, ~{
    sigma = character()
    if ( prop( .x, "sigmaInter" ) != 0 && prop( .x, "sigmaInterFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_inter_", prop( .x ,"output" ) ) )
    if ( prop( .x, "sigmaSlope" ) != 0 && prop( .x, "sigmaSlopeFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_slope_", prop( .x ,"output" ) ) )
    return( sigma )
  }) %>% unlist()  %>% unname()

  columnNamesMu = parametersMu %>% map_chr(~  greeksLetterForCOnsole['mu'] )
  columnNamesOmega = parametersOmega %>% map_chr( ~  greeksLetterForCOnsole['omega']  )
  columnNamesSigma = parametersSigma %>% map_chr( ~  greeksLetterForCOnsole['sigma']  )

  # data for plot
  data = data.frame( Parameter = c( parametersMu, parametersOmega, parametersSigma ),
                     Value = standardErrors$SEAndRSE$parametersValues,
                     SE = standardErrors$SE,
                     cat = paste0( "SE ", c(columnNamesMu, columnNamesOmega, columnNamesSigma ) ) )

  colnames( data ) = c("Parameter", "Value", "parametersValues", "SE", "cat")

  # bar plot of the plot SE
  plotSE = ggplot( data, aes( x = Parameter, y = SE ) ) +
    geom_bar( stat = "identity", position = "dodge", show.legend = FALSE ) +
    facet_wrap( ~factor( cat, levels =  paste0( "SE ", c( greeksLetterForCOnsole['mu'],  greeksLetterForCOnsole['omega'], greeksLetterForCOnsole["sigma"] ) ) ), scales = "free_x" ) +
    theme(legend.position = "none",
          plot.title = element_text(size=16, hjust = 0.5),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          axis.text.x = element_text(size=16, angle = 90, vjust = 0.5),
          axis.text.y = element_text(size=16, angle = 0, vjust = 0.5, hjust=0.5),
          strip.text.x = element_text(size=16))

  return( plotSE )
}

# ==============================================================================
#' @title Plot Relative Standard Errors (RSE\%) for Population FIM
#' @name plotRSEFIM
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' calculated RSE values.
#' @param evaluation An object of class \code{Evaluation} providing the
#' context and parameter names for the plot.
#' @return A plot object (typically \code{ggplot2} or \code{lattice}) displaying
#' the RSE\% for structural and variance parameters.
#' @template copyright
#' @export
# ==============================================================================

method( plotRSEFIM, list( PopulationFim, PFIMProject ) ) = function( fim, evaluation ) {

  # get parameter names and model error
  parameters = prop( evaluation, "modelParameters" )
  modelError = prop( evaluation, "modelError" )

  # get SEAndRSE
  fim = prop( evaluation, "fim" )
  fim = setEvaluationFim( fim, evaluation )
  standardErrors = prop( fim, "SEAndRSE" )

  # Greek letter for column names
  greeksLetterForCOnsole = c( mu = "\u03bc", omega = "\u03c9\u00B2", sigma = "\u03c3" )

  parametersMu =  parameters %>%
    keep( ~ prop( .x, "fixedMu" ) == FALSE) %>%
    keep( ~ .x@distribution@mu != 0 ) %>%
    map_chr( "name" )

  parametersOmega = parameters %>%
    keep( ~ prop( .x, "fixedOmega" ) == FALSE ) %>%
    keep( ~ .x@distribution@omega != 0 ) %>%
    map_chr( "name" )

  parametersSigma = map( modelError, ~{
    sigma = character()
    if ( prop( .x, "sigmaInter" ) != 0 && prop( .x, "sigmaInterFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_inter_", prop( .x ,"output" ) ) )
    if ( prop( .x, "sigmaSlope" ) != 0 && prop( .x, "sigmaSlopeFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "_slope_", prop( .x ,"output" ) ) )
    return( sigma )
  }) %>% unlist()  %>% unname()

  columnNamesMu = parametersMu %>% map_chr(~  greeksLetterForCOnsole['mu'] )
  columnNamesOmega = parametersOmega %>% map_chr( ~  greeksLetterForCOnsole['omega']  )
  columnNamesSigma = parametersSigma %>% map_chr( ~  greeksLetterForCOnsole['sigma']  )

  # data for plot
  data = data.frame( Parameter = c( parametersMu, parametersOmega, parametersSigma ),
                     Value = standardErrors$SEAndRSE$parametersValues,
                     RSE = standardErrors$RSE,
                     cat = paste0( "RSE ", c(columnNamesMu, columnNamesOmega, columnNamesSigma ) ) )

  colnames( data ) = c("Parameter", "Value", "parametersValues", "RSE", "cat")

  # bar plot of the plot SE
  plotRSE = ggplot( data, aes( x = Parameter, y = RSE ) ) +
    geom_bar( stat = "identity", position = "dodge", show.legend = FALSE ) +
    facet_wrap( ~factor( cat, levels =  paste0( "RSE ", c( greeksLetterForCOnsole['mu'],  greeksLetterForCOnsole['omega'], greeksLetterForCOnsole["sigma"] ) ) ), scales = "free_x" ) +
    theme(legend.position = "none",
          plot.title = element_text(size=16, hjust = 0.5),
          axis.title.x = element_text(size=16),
          axis.title.y = element_text(size=16),
          axis.text.x = element_text(size=16, angle = 90, vjust = 0.5),
          axis.text.y = element_text(size=16, angle = 0, vjust = 0.5, hjust=0.5),
          strip.text.x = element_text(size=16))

  return( plotRSE )
}

# ==============================================================================
#' @title Generate Statistical Tables for Evaluation Reports
#' @name tablesForReport
#' @description
#' The \code{tablesForReport} method aggregates the results of a PFIM analysis
#' into three standardized tables. It provides a structured view of parameter
#' estimates, global design criteria, and the precision of the estimation
#' (Standard Errors and Relative Standard Errors).
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' calculated Fisher Information Matrix and derived statistics.
#' @param evaluation An object of class \code{Evaluation} providing the
#' structural model context and output definitions.
#' @return A \code{list} containing three data frames:
#' \describe{
#'   \item{\code{fixedEffectsTable}}{Table of parameter names and values.}
#'   \item{\code{FIMCriteriaTable}}{Summary of FIM-based optimality criteria.}
#'   \item{\code{SEAndRSETable}}{Table of precision metrics (SE and RSE\%).}
#' }
#' @template copyright
#' @export
# ==============================================================================

method( tablesForReport, list( PopulationFim, PFIMProject ) ) = function( fim, evaluation ) {

  SEAndRSE = prop( fim, "SEAndRSE" )
  fisherMatrix = prop( fim, "fisherMatrix")
  fixedEffects = prop( fim, "fixedEffects")
  varianceEffects = prop( fim, "varianceEffects")
  condNumberFixedEffects = prop( fim, "condNumberFixedEffects" )
  condNumberVarianceEffects = prop( fim, "condNumberVarianceEffects" )
  Dcriterion = Dcriterion( fim )
  determinant = det( fisherMatrix )
  SEAndRSE = SEAndRSE$SEAndRSE
  parameters = prop( evaluation, "modelParameters" )
  modelError = prop( evaluation, "modelError" )

  # Greek letter for column names
  greeksLetterForCOnsole = c( mu = "$\\mu_{", omega = "$\\omega^2_{", sigma = "${\\sigma_" )

  # define the name for the columns and rows for mu, omega and sigma
  columnNamesMu = parameters %>%
    keep( ~ prop( .x, "fixedMu" ) == FALSE) %>%
    keep( ~  prop( prop(.x,"distribution"), "mu" ) != 0 ) %>%
    map_chr( "name" ) %>%
    map_chr(~ paste0( greeksLetterForCOnsole['mu'], .x,"}$" ) )

  columnNamesOmega = parameters %>%
    keep( ~ prop( .x, "fixedOmega" ) == FALSE ) %>%
    keep( ~  prop( prop(.x,"distribution"), "omega" ) != 0 ) %>%
    map_chr( "name" ) %>%
    map_chr( ~ paste0( greeksLetterForCOnsole['omega'], .x ,"}$" ) )

  columnNamesSigma = map( modelError, ~{
    sigma = character()
    if ( prop( .x, "sigmaInter" ) != 0 && prop( .x, "sigmaInterFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "{inter}}_{", prop( .x ,"output" ),"}$" ) )
    if ( prop( .x, "sigmaSlope" ) != 0 && prop( .x, "sigmaSlopeFixed" ) == FALSE ) sigma = c( sigma, paste0( greeksLetterForCOnsole["sigma"], "{slope}}_{", prop( .x ,"output" ),"}$" ) )
    return( sigma )
  }) %>% unlist()  %>% unname()

  fixedEffects = as.matrix( fixedEffects )
  colnames( fixedEffects ) = columnNamesMu
  rownames( fixedEffects ) = columnNamesMu
  colnames( varianceEffects ) = c( columnNamesOmega, columnNamesSigma )
  rownames( varianceEffects ) = c( columnNamesOmega, columnNamesSigma )

  fixedEffectsTable = fixedEffects %>%
    kbl() %>%
    kable_styling(
      bootstrap_options = c("hover"),
      full_width = FALSE,
      position = "center",
      font_size = 13 )

  varianceEffectsTable = varianceEffects %>%
    kbl() %>%
    kable_styling(
      bootstrap_options = c("hover"),
      full_width = FALSE,
      position = "center",
      font_size = 13 )

  FIMCriteria = data.frame( Determinant = determinant, Dcriterion = Dcriterion, FixedEffects = condNumberFixedEffects, VarianceEffects = condNumberVarianceEffects )

  FIMCriteriaTable = kbl(
    FIMCriteria,
    col.names = c("", "", "Fixed effects", "Variance effects"),
    align = c("c", "c", "c", "c"),
    format = "html" ) %>%
    add_header_above(c(
      "Determinant" = 1,
      "D-criterion" = 1,
      "Condition number" = 2
    )) %>%
    kable_styling(
      bootstrap_options = c("hover"),
      full_width = FALSE,
      position = "center",
      font_size = 13 )

  # SEAndRSE table
  SEAndRSE = data.frame( c( columnNamesMu, columnNamesOmega, columnNamesSigma ), round(SEAndRSE,3) )
  row.names( SEAndRSE ) = NULL

  SEAndRSETable = kbl(
    SEAndRSE,
    col.names = c("Parameters", "Parameter values", "SE", "RSE (%)"),
    align = c("c", "c", "c", "c") ) %>%
    kable_styling(
      bootstrap_options = c("hover"),
      full_width = FALSE,
      position = "center",
      font_size = 13 )

  fimTables = list( fixedEffectsTable = fixedEffectsTable, varianceEffectsTable = varianceEffectsTable, FIMCriteriaTable = FIMCriteriaTable, SEAndRSETable =  SEAndRSETable)

  return( fimTables )
}

# ==============================================================================
#' @title Generate a Comprehensive HTML Evaluation Report
#' @name generateReportEvaluation
#' @description
#' The \code{generateReportEvaluation} method compiles all computed Fisher Information
#' Matrix (FIM) results into a standalone HTML document. This report serves as
#' the final deliverable for a design evaluation, summarizing parameter precision,
#' design efficiency, and numerical stability.
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' finalized FIM data.
#' @param tablesForReport A \code{list} of data frames (as returned by
#' \code{\link{tablesForReport}}) containing the formatted statistical summaries.
#' @return An HTML file (or a path to the generated file) containing the
#' complete model evaluation report.
#' @template copyright
#' @export
# ==============================================================================

method( generateReportEvaluation, PopulationFim ) = function( fim, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "EvaluationPopulationFIM.Rmd" )
  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )
}


#' @title Generate the HTML Report for Design Optimization
#' @name generateReportOptimization
#' @description
#' The \code{generateReportOptimization} method compiles the results of a design
#' optimization into a professional HTML document. It specifically handles the
#' output of the \code{\link{MultiplicativeAlgorithm}}, documenting the
#' transition from the initial design to the optimal sampling schedule.
#' @param fim An object of class \code{\link{PopulationFim}} containing the
#' Fisher Information Matrix of the final optimized design.
#' @param optimizationAlgorithm An object of class \code{\link{MultiplicativeAlgorithm},\link{FedorovWynnAlgorithm}
#' \link{SimplexAlgorithm},\link{PSOAlgorithm},\link{PGBOAlgorithm}}.
#' @param tablesForReport A \code{list} of data frames (as returned by
#' \code{\link{tablesForReport}}) containing the final optimized statistical summaries.
#' @return An HTML report file (or a path to the file) containing the detailed
#' optimization results and diagnostic plots.
#' @template copyright
#' @export
# ==============================================================================

method( generateReportOptimization, list( PopulationFim, MultiplicativeAlgorithm ) ) = function( fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "OptimizationMultiplicativeAlgorithmPopulationFIM.Rmd" )

  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )
}

method( generateReportOptimization, list( PopulationFim, FedorovWynnAlgorithm ) ) = function( fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "OptimizationFedorovWynnAlgorithmPopulationFIM.Rmd" )

  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )
}

method( generateReportOptimization, list( PopulationFim, SimplexAlgorithm ) ) = function( fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "OptimizationSimplexAlgorithmPopulationFIM.Rmd" )

  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )

}

method( generateReportOptimization, list( PopulationFim, PSOAlgorithm ) ) = function( fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "OptimizationPSOAlgorithmPopulationFIM.Rmd" )

  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )
}

method( generateReportOptimization, list( PopulationFim, PGBOAlgorithm ) ) = function( fim, optimizationAlgorithm, tablesForReport, outputPath, outputFile ) {

  path = system.file(package = "PFIM")
  path = paste0( path, "/rmarkdown/templates/skeleton/" )
  nameInputFile = paste0( path, "OptimizationPGBOAlgorithmPopulationFIM.Rmd" )

  rmarkdown::render( input = nameInputFile, output_file = outputFile, output_dir = outputPath, params = list( tablesForReport = tablesForReport ) )
}
