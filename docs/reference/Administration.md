# Administration Class

The `Administration` class defines the dosing regimen for a specific
model outcome. It stores comprehensive information regarding dose
amounts, administration timings, infusion durations, and dosing
intervals (tau).

## Usage

``` r
Administration(
  outcome = character(0),
  timeDose = numeric(0),
  dose = numeric(0),
  Tinf = numeric(0),
  tau = 0
)
```

## Arguments

- outcome:

  A string identifying the target outcome for the administration.

- timeDose:

  A numeric vector of dosing times.

- dose:

  A numeric vector of dose amounts.

- Tinf:

  A numeric vector specifying infusion durations.

- tau:

  A numeric value representing the dosing interval (for multiple doses).

## Value

An object of class `Administration`.

## Slots

- `outcome`:

  `character`. The name of the model output (e.g., "PK").

- `timeDose`:

  `numeric vector`. The time points at which doses are administered.

- `dose`:

  `numeric vector`. The amount of drug administered at each time point.

- `Tinf`:

  `numeric vector`. The duration of the infusion (defaults to 0 for
  bolus).

- `tau`:

  `numeric`. The dosing interval for repeated doses or steady-state
  calculations.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Example 1: Single bolus dose at time 0
administrationRespPK = Administration(
  outcome  = "RespPK",
  timeDose = 0,
  dose     = 0.2
)
print( administrationRespPK )
#> <PFIM::Administration>
#>  @ outcome : chr "RespPK"
#>  @ timeDose: num 0
#>  @ dose    : num 0.2
#>  @ Tinf    : num(0) 
#>  @ tau     : num 0

# Example 2: Multiple doses at various times
administrationRespPK = Administration(
  outcome  = "RespPK",
  timeDose = c(0, 10, 20),
  dose     = c(0.1, 0.2, 0.3)
)
print( administrationRespPK )
#> <PFIM::Administration>
#>  @ outcome : chr "RespPK"
#>  @ timeDose: num [1:3] 0 10 20
#>  @ dose    : num [1:3] 0.1 0.2 0.3
#>  @ Tinf    : num(0) 
#>  @ tau     : num 0

# Example 3: Multiple doses with a 2-hour infusion duration
administrationRespPK = Administration(
  outcome  = "RespPK",
  timeDose = c(0, 10, 20),
  dose     = c( 0.1, 0.2, 0.3),
  Tinf     = 2.0
)
print( administrationRespPK )
#> <PFIM::Administration>
#>  @ outcome : chr "RespPK"
#>  @ timeDose: num [1:3] 0 10 20
#>  @ dose    : num [1:3] 0.1 0.2 0.3
#>  @ Tinf    : num 2
#>  @ tau     : num 0

# Example 4: Repeated dosing with a 5-hour interval (tau)
administrationRespPK = Administration(
  outcome = "RespPK",
  dose    = c(0.1, 0.2, 0.3),
  tau     = 5
)
print( administrationRespPK )
#> <PFIM::Administration>
#>  @ outcome : chr "RespPK"
#>  @ timeDose: num(0) 
#>  @ dose    : num [1:3] 0.1 0.2 0.3
#>  @ Tinf    : num(0) 
#>  @ tau     : num 5
```
