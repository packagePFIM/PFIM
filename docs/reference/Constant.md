# Constant Class

The `Constant` class defines an additive residual error model, where the
standard deviation (SD) of the error remains constant.

## Usage

``` r
Constant(
  output = character(0),
  equation = expression(sigmaInter),
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

  A string specifying the name of the model output.

- equation:

  An expression representing the model error equation.

- derivatives:

  A list of derivatives for the model error equation.

- sigmaInter:

  A numeric value for the constant residual error component.

- sigmaSlope:

  A numeric value for the slope (defaulted to 0.0 for this model).

- sigmaInterFixed:

  Logical; indicates if `sigmaInter` is fixed (default FALSE).

- sigmaSlopeFixed:

  Logical; indicates if `sigmaSlope` is fixed (default FALSE).

- cError:

  A numeric power parameter (default 1.0).

## Value

An object of class `Constant`.

## Slots

- `output`:

  `character`. The name of the model output.

- `sigmaInter`:

  `numeric`. The additive residual error value.

- `sigmaInterFixed`:

  `logical`. If `TRUE`, `sigmaInter` is not estimated.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
