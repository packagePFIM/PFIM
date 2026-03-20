# Normal Class

The class `Normal` implements the Normal distribution.

## Usage

``` r
Normal(name = character(0), mu = 0, omega = 0)
```

## Arguments

- name:

  A string specifying the distribution type.

- mu:

  A double representing the fixed effect value.

- omega:

  A double representing the random effect intensity.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>

## Examples

``` r
# Set the Normal distribution for a parameter
normalDistribution = Normal(
  mu    = 0.74,
  omega = 0.316
)
# Display distribution summary
print(normalDistribution)
#> <PFIM::Normal>
#>  @ name : chr(0) 
#>  @ mu   : num 0.74
#>  @ omega: num 0.316
```
