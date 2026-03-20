# SamplingTimes Class

The `SamplingTimes` class defines the specific time points at which
observations are collected for a given model outcome. In multi-response
models, this class allows each outcome (e.g., PK and PD) to have its own
independent sampling schedule.

## Usage

``` r
SamplingTimes(outcome = character(0), samplings = numeric(0))
```

## Arguments

- outcome:

  A `string` specifying the name of the model output (e.g., "RespPK",
  "Metabolite").

- samplings:

  A `numeric vector` representing the sampling schedule.

## Value

An object of class `SamplingTimes`.

## Slots

- `outcome`:

  `character`. The name of the model output (e.g., "RespPK").

- `samplings`:

  `numeric vector`. The sequence of observation time points.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Define a PK sampling schedule
samplingTimesRespPK = SamplingTimes(
  outcome   = "RespPK",
  samplings = c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4)
)

# Display the sampling schedule summary
print(samplingTimesRespPK)
#> <PFIM::SamplingTimes>
#>  @ outcome  : chr "RespPK"
#>  @ samplings: num [1:9] 0.25 0.5 0.75 1 1.25 1.5 2 3 4
```
