#' @title SamplingTimeConstraints Class
#' @name SamplingTimeConstraints
#' @description
#' The \code{SamplingTimeConstraints} class defines the boundaries and rules
#' for longitudinal sampling within a specific outcome of an experimental arm.
#' It manages fixed sampling points, flexible windows, and minimum intervals.
#' @param outcome A \code{string} specifying which model output (e.g., "PK", "PD")
#' these constraints apply to.
#' @param initialSamplings A \code{vector} of numeric values representing the
#' starting sampling schedule before optimization.
#' @param fixedTimes A \code{vector} of numeric values specifying time points
#' that cannot be moved or removed by the optimizer.
#' @param numberOfsamplingsOptimisable A \code{double} representing the number
#' of sampling points allowed to be modified.
#' @param samplingsWindows A \code{list} of intervals (e.g., \code{list(c(0,2), c(4,8))})
#' defining the search boundaries for the optimizer.
#' @param numberOfTimesByWindows A \code{vector} indicating how many samples
#' are allowed within each specific window.
#' @param minSampling A \code{vector} (or numeric) defining the minimum
#' allowable time between two consecutive samples.
#' @examples
#' \dontrun{
#' # --- Examples from Vignette 1 ---
#'
#' # The following code illustrates how to configure sampling constraints for both
#' # discrete search grids (e.g., Fedorov-Wynn) and continuous optimization
#' # windows (e.g., PGBO or Simplex):
#'
#' # 1. Discrete Grid Constraints (for Multiplicative and Fedorov-Wynn algorithms)
#' samplingConstraintsRespPK = SamplingTimeConstraints(
#'   outcome                     = "RespPK",
#'   initialSamplings            = c(0.25, 0.75, 1, 1.5, 2, 4, 6),
#'   fixedTimes                  = c(0.25, 4),
#'   numberOfsamplingsOptimisable = 4
#' )
#'
#' # 2. Continuous Window Constraints (for PSO, PGBO, or Simplex algorithms)
#' samplingConstraintsRespPK = SamplingTimeConstraints(
#'   outcome                = "RespPK",
#'   initialSamplings       = c(1, 48, 72, 120),
#'   numberOfTimesByWindows = c(2, 2),
#'   samplingsWindows       = list(c(1, 48),
#'                                 c(72, 120)),
#'   minSampling            = 5
#' )
#' }
#' @template copyright
#' @export

SamplingTimeConstraints = new_class( "SamplingTimeConstraints", package = "PFIM",

                                     properties = list( outcome = new_property(class_character, default = character(0)),
                                                        initialSamplings = new_property(class_vector, default = c(0.0)),
                                                        fixedTimes = new_property(class_vector, default = c(0.0)),
                                                        numberOfsamplingsOptimisable = new_property(class_double, default = 0.0),
                                                        samplingsWindows = new_property(class_list, default = list()),
                                                        numberOfTimesByWindows = new_property(class_vector, default = c(0.0)),
                                                        minSampling = new_property(class_vector, default = c(0.0))))

generateSamplingsFromSamplingConstraints = new_generic( "generateSamplingsFromSamplingConstraints", c( "samplingTimeConstraints" ) )
checkSamplingTimeConstraintsForMetaheuristic = new_generic( "checkSamplingTimeConstraintsForMetaheuristic", c( "samplingTimesConstraints", "arm"  ) )

# ==============================================================================
#' @name generateSamplingsFromSamplingConstraints
#' @title Generate Numerical Intervals from Sampling Constraints
#' @description
#' The \code{generateSamplingsFromSamplingConstraints} method transforms a
#' \code{\link{SamplingTimeConstraints}} object into a structured list of
#' mathematical intervals. These intervals define the feasible search space
#' for each optimizable sampling point.
#' @param samplingTimeConstraints An object of class \code{\link{SamplingTimeConstraints}}
#' containing the user-defined constraints and windows.
#' @return A \code{list} named \code{intervalsConstraints}. Each element of the
#' list is a numeric vector of length 2 (lower and upper bound) representing
#' the search space for one optimizable sample.
#' @template copyright
#' @export
# ==============================================================================

method( generateSamplingsFromSamplingConstraints, SamplingTimeConstraints ) = function( samplingTimeConstraints ) {

  # get min sampling constraint
  minSampling = prop( samplingTimeConstraints, "minSampling" )
  # get samplings window constraints
  samplingsWindow = prop( samplingTimeConstraints, "samplingsWindows" )
  # get numberOfTimesByWindows constraints
  numberOfTimesByWindows = prop( samplingTimeConstraints, "numberOfTimesByWindows" )
  # generate samplings from sampling constraints
  intervalsConstraints = list()

  minSamplingAndNumberOfTimesByWindows = as.data.frame( list( minSampling, numberOfTimesByWindows ) )
  data = t( as.data.frame( samplingsWindow ) )
  inputRandomSpaced = as.data.frame( do.call( "cbind", list( data, minSamplingAndNumberOfTimesByWindows ) ) )

  colnames( inputRandomSpaced ) = c("min","max","delta","n")
  rownames( inputRandomSpaced ) = NULL

  for( iter in 1:length( inputRandomSpaced$n ) )
  {
    min = inputRandomSpaced$min[iter]
    max = inputRandomSpaced$max[iter]
    delta = inputRandomSpaced$delta[iter]
    n = inputRandomSpaced$n[iter]

    distance = max-min-(n-1)*delta

    ind = runif(n,0,1)
    tmp = distance*sort( ind )
    interval = min + tmp + delta * seq(0,n-1,1)

    intervalsConstraints[[iter]] = interval
  }
  return( unlist( intervalsConstraints ) )
}

# ==============================================================================
#' @name checkSamplingTimeConstraintsForMetaheuristic
#' @title Validate New Sampling Schedules Against Constraints
#' @description
#' The \code{checkSamplingTimeConstraintsForMetaheuristic} method evaluates
#' whether a proposed set of sampling times is feasible. It checks the
#' timings against defined windows, fixed points, and minimum intervals
#' required for clinical safety or logistical practicality.
#' @param samplingTimesConstraints An object of class \code{\link{SamplingTimeConstraints}}
#' defining the allowed design space.
#' @param arm An object of class \code{\link{Arm}} representing the experimental
#' group being validated.
#' @param newSamplings A \code{vector} of numeric values representing the
#' candidate sampling times proposed by the algorithm.
#' @param outcome A \code{string} specifying the model output (e.g., "PK", "PD")
#' to which these samples belong.
#' @return A \code{logical} value: \code{TRUE} if the design is valid,
#' \code{FALSE} otherwise. If \code{FALSE}, a descriptive error message is
#' usually printed to the console or stored in the optimization log.
#' @template copyright
#' @export
# ==============================================================================

method( checkSamplingTimeConstraintsForMetaheuristic, list( SamplingTimeConstraints, Arm ) ) = function( samplingTimesConstraints, arm, newSamplings, outcome ) {

  armName = prop(arm, 'name')

  # get min sampling constraint
  minSampling = prop( samplingTimesConstraints, "minSampling")

  # get samplings window constraints
  samplingsWindow =  prop( samplingTimesConstraints, "samplingsWindows")
  # get numberOfTimesByWindows constraints
  numberOfTimesByWindows =  prop( samplingTimesConstraints, "numberOfTimesByWindows")

  # get the constraints min, max, delta and n
  minSamplingAndNumberOfTimesByWindows = as.data.frame( list( minSampling, numberOfTimesByWindows ) )
  data = t( as.data.frame(samplingsWindow ) )
  inputRandomSpaced = as.data.frame( do.call( "cbind", list( data, minSamplingAndNumberOfTimesByWindows ) ) )
  colnames( inputRandomSpaced ) = c("min","max","delta","n")
  rownames( inputRandomSpaced ) = NULL

  testForConstraintsWindowsLength = list()
  testForConstraintsMinimalSampling = list()

  for( iter in 1:length( inputRandomSpaced$n ) )
  {
    min = inputRandomSpaced$min[iter]
    max = inputRandomSpaced$max[iter]

    # check the constraint numberOfTimesByWindows
    testForConstraintsWindowsLength[[ armName ]][[ outcome ]][[iter]] = newSamplings[ newSamplings >= min & newSamplings <= max ]

    # check the constraint minSampling
    testForConstraintsMinimalSampling[[ armName ]][[ outcome ]][[iter]] = diff( testForConstraintsWindowsLength[[ armName ]][[ outcome ]][[ iter ]] )

    # case for one sampling
    if ( length( testForConstraintsMinimalSampling[[ armName ]][[ outcome ]][[iter]] ) == 0 )
    {
      testForConstraintsMinimalSampling[[ armName ]][[ outcome ]][[iter]] = 0
    }
  }

  # tests for the constraint
  testForConstraintsWindowsLengthtmp = map_int( testForConstraintsWindowsLength[[armName]][[outcome]], ~ length(.x) )

  if ( all( testForConstraintsWindowsLengthtmp == numberOfTimesByWindows ) )
  {
    constraintWindowsLength = TRUE
  }else{
    constraintWindowsLength = FALSE
  }

  testForConstraintsMinimalSamplingTmp = map_dbl(testForConstraintsMinimalSampling[[armName]][[outcome]], ~ min(.x) )

  if ( all( testForConstraintsMinimalSamplingTmp >= minSampling ) )
  {
    constraintMinimalSampling = TRUE
  }else{
    constraintMinimalSampling = FALSE
  }
  return( list( constraintWindowsLength = constraintWindowsLength, constraintMinimalSampling = constraintMinimalSampling ) )
}












