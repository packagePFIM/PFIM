# Extract sampling times and maximum sampling time

Returns structured sampling information from an arm, used internally by
plotting methods.

## Usage

``` r
getSamplingData(arm, ...)
```

## Arguments

- arm:

  An object of class `Arm`.

- ...:

  Additional arguments.

## Value

A list with `samplingTimes`, `samplings` (named list of numeric
vectors), and `samplingMax` (numeric scalar).

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
