# SamplingTimeConstraints Class

The `SamplingTimeConstraints` class defines the boundaries and rules for
longitudinal sampling within a specific outcome of an experimental arm.
It manages fixed sampling points, flexible windows, and minimum
intervals.

## Usage

``` r
SamplingTimeConstraints(
  outcome = character(0),
  initialSamplings = 0,
  fixedTimes = 0,
  numberOfsamplingsOptimisable = 0,
  samplingsWindows = list(),
  numberOfTimesByWindows = 0,
  minSampling = 0
)
```

## Arguments

- outcome:

  A `string` specifying which model output (e.g., "PK", "PD") these
  constraints apply to.

- initialSamplings:

  A `vector` of numeric values representing the starting sampling
  schedule before optimization.

- fixedTimes:

  A `vector` of numeric values specifying time points that cannot be
  moved or removed by the optimizer.

- numberOfsamplingsOptimisable:

  A `double` representing the number of sampling points allowed to be
  modified.

- samplingsWindows:

  A `list` of intervals (e.g., `list(c(0,2), c(4,8))`) defining the
  search boundaries for the optimizer.

- numberOfTimesByWindows:

  A `vector` indicating how many samples are allowed within each
  specific window.

- minSampling:

  A `vector` (or numeric) defining the minimum allowable time between
  two consecutive samples.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
if (FALSE) { # \dontrun{
# --- Examples from Vignette 1 ---

# The following code illustrates how to configure sampling constraints for both
# discrete search grids (e.g., Fedorov-Wynn) and continuous optimization
# windows (e.g., PGBO or Simplex):

# 1. Discrete Grid Constraints (for Multiplicative and Fedorov-Wynn algorithms)
samplingConstraintsRespPK = SamplingTimeConstraints(
  outcome                     = "RespPK",
  initialSamplings            = c(0.25, 0.75, 1, 1.5, 2, 4, 6),
  fixedTimes                  = c(0.25, 4),
  numberOfsamplingsOptimisable = 4
)

# 2. Continuous Window Constraints (for PSO, PGBO, or Simplex algorithms)
samplingConstraintsRespPK = SamplingTimeConstraints(
  outcome                = "RespPK",
  initialSamplings       = c(1, 48, 72, 120),
  numberOfTimesByWindows = c(2, 2),
  samplingsWindows       = list(c(1, 48),
                                c(72, 120)),
  minSampling            = 5
)
} # }
```
