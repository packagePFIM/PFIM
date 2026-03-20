# AdministrationConstraints Class

The `AdministrationConstraints` class defines the space of admissible
doses for a specific model outcome. It is used by optimization
algorithms to restrict dosage inputs to a set of discrete candidate
values.

## Usage

``` r
AdministrationConstraints(outcome = character(0), doses = list())
```

## Arguments

- outcome:

  A string identifying the target outcome for these constraints.

- doses:

  A numeric vector containing the candidate dose values.

## Value

An object of class `AdministrationConstraints`.

## Slots

- `outcome`:

  `character`. The name of the model output (e.g., "PK").

- `doses`:

  `numeric vector`. A vector of authorized dose levels (discrete
  candidates).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Define discrete dose candidates for a PK model outcome
administrationConstraintsRespK = AdministrationConstraints(
 outcome = "RespPK",
 doses   = list(0.2, 0.64, 2, 6.24, 11.24, 20) )
print( administrationConstraintsRespK )
#> <PFIM::AdministrationConstraints>
#>  @ outcome: chr "RespPK"
#>  @ doses  :List of 6
#>  .. $ : num 0.2
#>  .. $ : num 0.64
#>  .. $ : num 2
#>  .. $ : num 6.24
#>  .. $ : num 11.2
#>  .. $ : num 20
```
