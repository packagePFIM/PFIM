# Distribution Class

The `Distribution` class is an abstract base class used to represent
statistical distributions for model parameters.

## Usage

``` r
Distribution(name = character(0), mu = 0, omega = 0)
```

## Arguments

- name:

  A string specifying the distribution type.

- mu:

  A double representing the fixed effect value.

- omega:

  A double representing the random effect intensity.

## Value

An object of class `Distribution`.

## Slots

- `name`:

  `character`. The name of the distribution (e.g., "Normal",
  "LogNormal").

- `mu`:

  `numeric`. The mean value or fixed effect of the parameter.

- `omega`:

  `numeric`. The standard deviation or variance of the random effect.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
