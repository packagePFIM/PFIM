# Combined1 Class

The `Combined1` class defines a combined residual error model, which
incorporates both an additive and a proportional component.

## Usage

``` r
Combined1(
  output = character(0),
  equation = expression(sigmaInter + sigmaSlope * output),
  derivatives = list(),
  sigmaInter = 0,
  sigmaSlope = 0,
  sigmaInterFixed = FALSE,
  sigmaSlopeFixed = FALSE,
  cError = 1
)
```

## Arguments

- output:

  A string specifying the model error output name.

- equation:

  An expression representing the model error equation.

- derivatives:

  A list of derivatives for the model error equation.

- sigmaInter:

  A numeric value for the additive component (default 0).

- sigmaSlope:

  A numeric value for the proportional component (default 0).

- sigmaInterFixed:

  Logical; indicates if `sigmaInter` is fixed (default FALSE).

- sigmaSlopeFixed:

  Logical; indicates if `sigmaSlope` is fixed (default FALSE).

- cError:

  A numeric power parameter (default 1.0).

## Value

An object of class `Combined1`.

## Slots

- `output`:

  `character`. The name of the model output (e.g., "Cc").

- `sigmaInter`:

  `numeric`. The additive (intercept) error component.

- `sigmaSlope`:

  `numeric`. The proportional (slope) error component.

- `sigmaInterFixed`:

  `logical`. If `TRUE`, the intercept is fixed.

- `sigmaSlopeFixed`:

  `logical`. If `TRUE`, the slope is fixed.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
