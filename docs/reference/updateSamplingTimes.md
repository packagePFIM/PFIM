# Update sampling times for plotting

Replaces the arm's sampling times with a dense regular grid combined
with the original sampling points, enabling smooth curve rendering.

## Usage

``` r
updateSamplingTimes(arm, samplingData, ...)
```

## Arguments

- arm:

  An object of class `Arm`.

- samplingData:

  The list output from `getSamplingData`.

- ...:

  Additional arguments

## Value

The updated `Arm` object.

## Note

Copyright (c) 2026-present Romain Leroux. All rights reserved.

## Author

Romain Leroux <romainlerouxPFIM@gmail.com>
