#' @title SimplexAlgorithm Class
#' @name SimplexAlgorithm
#' @description
#' The \code{SimplexAlgorithm} class implements the Nelder-Mead downhill simplex
#' method for derivative-free optimization. It is particularly robust for
#' non-smooth objective functions in population FIM optimization.
#' @param pctInitialSimplexBuilding A numeric value giving the percent variation
#' used to build the initial simplex around the starting point.
#' @param maxIteration An integer specifying the maximum number of iterations allowed.
#' @param tolerance A numeric value for the convergence tolerance on the FIM criterion.
#' @param seed A numeric value for the random number generator seed (if applicable).
#' @param showProcess A logical value; if \code{TRUE}, prints optimization progress
#' to the console at each iteration.
#' @inheritParams Optimization
#' @include Optimization.R
#' @examples
#' \dontrun{
#'
#' # Examples from Vignette 2
#'
#' # Initializing the Simplex algorithm for population FIM optimization
#' optimizationSimplexPopFIM = Optimization(
#'   name                = "optimizationExampleSimplex",
#'   modelFromLibrary    = modelFromLibrary,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   optimizer           = "SimplexAlgorithm",
#'   optimizerParameters = list(
#'     pctInitialSimplexBuilding = 10,    # initial spread: 10% of window widths
#'     maxIteration              = 1000,  # max Nelder-Mead iterations
#'     tolerance                 = 1e-10, # convergence on relative D-criterion change
#'     showProcess               = FALSE
#'   ),
#'   designs             = list(design2),
#'   fimType             = "population",
#'   outputs             = list("RespPK")
#' )
#'
#' # Run the Simplex optimization and display the results
#' resultsSimplexPopFIM = run(optimizationSimplexPopFIM)
#' show(resultsSimplexPopFIM)
#'
#' }
#' @template copyright
#' @export

SimplexAlgorithm = new_class(
  "SimplexAlgorithm",
  package = "PFIM",
  parent  = .Optimization_S7,
  properties = list(
    pctInitialSimplexBuilding = new_property( class_double,  default = 10 ),
    maxIteration              = new_property( class_double,  default = 1000 ),
    tolerance                 = new_property( class_double,  default = 1e-10 ),
    seed                      = new_property( class_double,  default = 42 ),
    showProcess               = new_property( class_logical, default = FALSE )
  ),
  constructor = function(
    # ── Simplex-specific properties ──────────────────────────────────────────
    pctInitialSimplexBuilding = 10,
    maxIteration              = 1000,
    tolerance                 = 1e-10,
    seed                      = 42,
    showProcess               = FALSE,
    # ── Inherited Optimization properties (forwarded from the factory) ──────
    optimisationDesign           = list(),
    optimisationAlgorithmOutputs = list(),
    name                         = character(0),
    modelParameters              = list(),
    modelEquations               = list(),
    modelFromLibrary             = list(),
    modelError                   = list(),
    designs                      = list(),
    outputs                      = list(),
    fimType                      = character(0),
    odeSolverParameters          = list()
  ) {
    new_object(
      .parent = .Optimization_S7(
        optimisationDesign           = optimisationDesign,
        optimisationAlgorithmOutputs = optimisationAlgorithmOutputs,
        name                         = name,
        modelParameters              = modelParameters,
        modelEquations               = modelEquations,
        modelFromLibrary             = modelFromLibrary,
        modelError                   = modelError,
        designs                      = designs,
        outputs                      = outputs,
        fimType                      = fimType,
        odeSolverParameters          = odeSolverParameters
      ),
      pctInitialSimplexBuilding = pctInitialSimplexBuilding,
      maxIteration              = maxIteration,
      tolerance                 = tolerance,
      seed                      = seed,
      showProcess               = showProcess
    )
  }
)

fisherSimplex = new_generic( "fisherSimplex", c( "optimizationObject" ) )

# ==============================================================================
#' @title Compute the Amoeba (Nelder-Mead) Simplex Search
#' @name fun.amoeba
#' @description
#' \code{fun.amoeba} is an internal numerical routine that performs the
#' Nelder-Mead simplex search. It iteratively updates the simplex vertices
#' to find the optimal experimental design parameters.
#' @param p A matrix where each row represents a vertex of the simplex.
#' @param y A vector containing the function values (FIM criteria) at each vertex.
#' @param ftol A numeric value specifying the fractional convergence tolerance.
#' @param itmax An integer specifying the maximum number of iterations.
#' @param funk The objective function to be minimized (e.g., the D-optimality criterion).
#' @param outcomes The model outcomes used for FIM evaluation.
#' @param data Additional data or design constraints.
#' @param showProcess A logical value; if \code{TRUE}, logs the progress of the simplex.
#' @return A list containing the optimized parameters, the function value,
#' and the number of iterations performed.
#' @template copyright
#' @export
# ==============================================================================

fun.amoeba = function(p,y,ftol,itmax,funk,outcomes,data,showProcess){
  alpha = 1.0
  beta = 0.5
  gamma = 2.0

  eps = 1.e-10
  mpts = nrow(p)
  iter = 0
  contin = T
  converge = F
  results = data.frame()

  while (contin) {

    if ( showProcess == TRUE )
    {
      message( paste0('iter = ',iter))
      message( paste0('Criterion = ', 1/min(y) ) )
    }

    results = rbind( c( iter , 1/min(y) ) , results)

    # ============================================================
    ## First we must determine which point is the highest (worst),
    ## next highest, and lowest (best).
    # ============================================================

    ord=sort.list(y)
    ilo=ord[1]
    ihi=ord[mpts]
    inhi=ord[mpts-1]

    # ===================================================================
    ## Compute the fractional range from highest to lowest and return if
    ## satisfactory.
    # ===================================================================

    rtol=2.*abs(y[ihi]-y[ilo])/(abs(y[ihi])+abs(y[ilo])+eps)

    if ((rtol<ftol)||(iter==itmax))
    {
      contin=F
      converge=T
      if (iter==itmax) { converge=F }
    } else {
      if (iter==itmax) cat('Amoeba exceeding maximum iterations.\n')
      iter=iter+1

      # ======================================================================
      ## Begin a new iteration.  Compute the vector average of all points
      ## except the highest, i.e. the center of the face of the simplex across
      ## from the high point.  We will subsequently explore along the ray from
      ## the high point through that center.
      # ======================================================================

      pbar=matrix(p[-ihi,],(mpts-1),(mpts-1))
      pbar=apply(pbar,2,mean)

      # ======================================================================
      ## Extrapolate by a factor alpha through the face, i.e. reflect the
      ## simplex from the high point.  Evaluate the function at the reflected
      ## point.
      # ======================================================================

      pr=(1+alpha)*pbar-alpha*p[ihi,]
      ypr=funk(data,pr,outcomes)
      if (ypr<=y[ilo])
      {
        # ======================================================================
        ## Gives a result better than the best point, so try an additional
        ## extrapolation by a factor gamma, and check out the function there.
        # ======================================================================
        prr=gamma*pr+(1-gamma)*pbar
        yprr=funk(data,prr,outcomes)
        if (yprr<y[ilo])
        {
          # ========================================================================
          ## The additional extrapolation succeeded, and replaces the highest point.
          # ========================================================================
          p[ihi,]=prr
          y[ihi]=yprr
        } else {
          # ========================================================================
          ## The additional extrapolation failed, but we can still use the
          ## reflected point.
          # ========================================================================
          p[ihi,]=pr
          y[ihi]=ypr
        }
      } else {
        if (ypr>=y[inhi])
        {
          # ========================================================================
          ## The reflected point is worse than the second-highest.
          # ========================================================================
          if (ypr<y[ihi])
          {
            # ========================================================================
            ## If it's better than the highest, then replace the highest,
            # ========================================================================
            p[ihi,]=pr
            y[ihi]=ypr
          }
          # ========================================================================
          ## but look for an intermediate lower point, in other words, perform a
          ## contraction of the simplex along one dimension.  Then evaluate the
          ## function.
          # ========================================================================
          prr=beta*p[ihi,]+(1-beta)*pbar
          yprr=funk(data,prr,outcomes)
          if (yprr<y[ihi])
          {
            # ========================================================================
            ## Contraction gives an improvement, so accept it.
            # ========================================================================
            p[ihi,]=prr
            y[ihi]=yprr
          } else {
            # ========================================================================
            ## Can't seem to get rid of that high point.  Better contract around the
            ## lowest (best) point.
            # ========================================================================
            p=0.5*(p+matrix(p[ilo,],nrow=nrow(p),ncol=ncol(p),byrow=T))
            for (j in 1:length(y)) {
              if (j!=ilo) {
                y[j]=funk(data,p[j,],outcomes)
              }
            }
          }
        } else {
          # ========================================================================
          ## We arrive here if the original reflection gives a middling point.
          ## Replace the old high point and continue
          # ========================================================================
          p[ihi,]=pr
          y[ihi]=ypr
        }
      }
    }
  }
  return(list(p=p,y=y,iter=iter,converge=converge, results = results ))
} # end function amoeba

# ==============================================================================
#' @title Compute the fisher.simplex
#' @name fisherSimplex
#' @param simplex A list giving the parameters of the simplex.
#' @param optimizationObject An object \code{Optimization}.
#' @param outcomes A vector giving the outcomes of the arms.
#' @return A list giving the results of the optimization.
#' @template copyright
#' @export
# ==============================================================================

method( fisherSimplex, .Optimization_S7 ) = function( optimizationObject, simplex, outcomes )
{
  samplingTimeConstraintsForContinuousOptimization = list( )

  # designs and arms
  designs = prop( optimizationObject, "designs" )

  for ( design in designs )
  {
    designName = prop( design, "name" )
    arms = prop( design, "arms" )

    # set sampling times in each arm
    armsList = list()

    for ( arm in arms )
    {
      armName = prop( arm, "name" )

      # get constraints
      samplingTimesArms = list()
      samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )
      samplingTimes = prop( arm, "samplingTimes" )

      for ( outcome in outcomes[[armName]] )
      {
        # get the samplings times by design-arm-outcome
        namesSamplings = toString( c( designName, armName, outcome ) )
        indexSamplingTimes = which( names( simplex ) == namesSamplings )
        newSamplings = simplex[indexSamplingTimes]
        names( newSamplings ) = NULL

        # check the constraints on the samplings times
        samplingTimesConstraint = keep( samplingTimesConstraints, ~ prop( .x,"outcome" ) == outcome ) %>% pluck(1)

        samplingTimeConstraintsForContinuousOptimization[[ armName ]][[ outcome ]] =
          checkSamplingTimeConstraintsForMetaheuristic( samplingTimesConstraint, arm, newSamplings, outcome )

        samplingTimes = samplingTimes %>%
          modify_at(
            .at = which( map_chr( ., ~ prop( .x, "outcome" ) ) == outcome ),
            .f = ~ {
              prop( .x, "samplings" ) = newSamplings
              .x
            })
      }
      prop( arm, "samplingTimes" ) = samplingTimes
      armsList = append( armsList, arm )
    }

    # set new arms to the design
    prop( design, "arms" ) = armsList

    samplingTimeConstraintsForContinuousOptimization = unlist( samplingTimeConstraintsForContinuousOptimization )

    # if constraints are satisfied evaluate design
    if( all( samplingTimeConstraintsForContinuousOptimization ) == TRUE )
    {
      # evaluate the fim
      evaluationFIM = Evaluation( name = "internalFimEvaluation",
                                  modelEquations = prop( optimizationObject, "modelEquations" ),
                                  modelParameters = prop( optimizationObject, "modelParameters" ),
                                  modelError = prop( optimizationObject, "modelError" ),
                                  fimType = prop( optimizationObject, "fimType" ),
                                  outputs = prop( optimizationObject, "outputs" ),
                                  designs = list( design ),
                                  odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

      evaluationFIM =  run( evaluationFIM )

      # get D-criterion
      fim = prop( evaluationFIM, "fim" )
      Dcriterion = 1/Dcriterion( fim )

    }else{
      Dcriterion = 1
    }
  }

  # in case of Inf
  Dcriterion[is.infinite(Dcriterion)] = 1.0
  return( Dcriterion )
}

# ==============================================================================
#' @rdname optimizeDesign
#' @name optimizeDesign
#' @export
# ==============================================================================

method( optimizeDesign, list( .Optimization_S7, SimplexAlgorithm ) ) = function( optimizationObject, optimizationAlgorithm )
{
  # get simplex parameters
  optimizerParameters = prop( optimizationObject, "optimizerParameters")
  showProcess = optimizerParameters$showProcess
  pctInitialSimplexBuilding = optimizerParameters$pctInitialSimplexBuilding
  tolerance = optimizerParameters$tolerance
  maxIteration = optimizerParameters$maxIteration

  # get the design to be optimized
  designs = prop( optimizationObject, "designs" )
  design = pluck( designs, 1 )
  optimalDesign =  pluck( designs, 1 )
  designName = prop( design, "name" )

  # check validity of the sampling Times Constraints
  checkValiditySamplingConstraint( design )

  # in case of partial sampling constraints set the new arms with the sampling constraints
  design = setSamplingConstraintForOptimization( design )

  # get the arms
  arms = prop( design, "arms" )

  # set the new designs in the optimizationObject
  prop( optimizationObject, "designs" ) = list( design )

  # get arm outcomes
  outcomes = map( set_names( arms, map_chr( arms, ~ prop( .x, 'name' ) ) ), ~ {
    map_chr( prop( .x, "samplingTimesConstraints" ), ~ prop( .x, "outcome"))
  })

  # create the initial simplex
  namesSamplingsSimplex = list()
  samplingsSimplex = list()
  initialSimplex = list()

  k=1
  for ( arm in arms )
  {
    armName = prop( arm, "name" )
    samplingTimesConstraints = prop( arm, "samplingTimesConstraints" )

    for ( outcome in outcomes[[armName]] )
    {
      samplingTimesConstraint = keep( samplingTimesConstraints, ~ prop(.x,"outcome") == outcome ) %>% pluck(1)
      samplingsSimplex[[k]] = prop( samplingTimesConstraint, "initialSamplings" )
      namesSamplingsSimplex[[k]] = rep( toString( c( designName, armName, outcome ) ), length( samplingsSimplex[[k]] ) )
      k=k+1
    }
  }

  samplingsSimplex = unlist( samplingsSimplex )
  samplingsSimplex = matrix( rep( samplingsSimplex,length( samplingsSimplex ) + 1 ), ncol = length( samplingsSimplex ), byrow=TRUE )
  colnames( samplingsSimplex ) = unlist( namesSamplingsSimplex )
  samplingsSimplex = t( apply( samplingsSimplex, 1, sort ) )

  # percentage initial simplex
  for ( i in 1:ncol( samplingsSimplex ) )
  {
    samplingsSimplex[i+1,i] = samplingsSimplex[i+1,i]*( 1-pctInitialSimplexBuilding/100 )
  }

  # evaluate criteria
  y = c()
  for ( i in 1:nrow( samplingsSimplex ) )
  {
    y[i] = fisherSimplex( optimizationObject, samplingsSimplex[i,], outcomes )
  }

  # Run the simplex
  opti = fun.amoeba( samplingsSimplex, y, tolerance, maxIteration, fisherSimplex, outcomes, data = optimizationObject, showProcess )

  # get the results of the simplex
  optimalDCriteria = opti$y
  samplingTimesSimplex = opti$p
  indexOptimalDCriteria = which( opti$y == min( opti$y ) )
  results = opti$results
  optimalsamplingTimes = samplingTimesSimplex[indexOptimalDCriteria,]

  # set optimal design
  namesDesignArmOutcome = unique( names( optimalsamplingTimes ) )
  arms = prop( optimalDesign, "arms" )
  armsList = list()

  for ( arm in arms )
  {
    armName = prop( arm, "name" )

    listOfSamplingTimes = list()

    for ( outcome in outcomes[[armName]] )
    {
      namesSamplings = toString(c( designName, armName, outcome ))
      indexSamplingTimes = which( names( optimalsamplingTimes ) == namesSamplings )
      samplings = optimalsamplingTimes[indexSamplingTimes]
      names(samplings) = NULL
      samplingTimes = SamplingTimes( outcome, samplings = samplings )
      listOfSamplingTimes = append( listOfSamplingTimes, samplingTimes )
    }
    prop( arm, "samplingTimes" ) = listOfSamplingTimes
    armsList = append( armsList, arm )
  }

  # set optimal arms
  prop( optimalDesign, "arms" ) = armsList

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
  prop( optimizationObject, "optimisationDesign" ) = list( evaluationInitialDesign = evaluationInitialDesign, evaluationOptimalDesign = evaluationOptimalDesign )
  prop( optimizationObject, "optimisationAlgorithmOutputs" ) = list( "optimizationAlgorithm" = optimizationAlgorithm, "optimalArms" = armsList )
  return( optimizationObject )
}

# ==============================================================================
#' @rdname constraintsTableForReport
#' @name constraintsTableForReport
#' @export
# ==============================================================================

method( constraintsTableForReport, SimplexAlgorithm ) = function( optimizationAlgorithm, arms  )
{
  armsConstraints = map( pluck( arms, 1 ) , ~ getArmConstraints( .x, optimizationAlgorithm ) )
  armsConstraints = map_dfr( armsConstraints, ~ map_dfr(.x, ~ as.data.frame(.x, stringsAsFactors = FALSE)))
  colnames( armsConstraints ) = c( "Arms name" , "Number of subjects", "Outcome", "Initial samplings", "Samplings windows", "Number of times by windows","Min sampling" )
  armsConstraintsTable = kbl( armsConstraints, align = c( "l","c","c","c","c","c","c") ) %>% kable_styling( bootstrap_options = c(  "hover" ), full_width = FALSE, position = "center", font_size = 13 )
  return( armsConstraintsTable )
}
