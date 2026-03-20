# FedorovWynnAlgorithm with Rcpp

Implementation of the Fedorov-Wynn algorithm in C++ via Rcpp. This
function handles the heavy matrix computations and exchange logic
required for D-optimal design.

## Usage

``` r
FedorovWynnAlgorithm_Rcpp(
  protocols_input,
  ndimen_input,
  nbprot_input,
  numprot_input,
  freq_input,
  nbdata_input,
  vectps_input,
  fisher_input,
  nok_input,
  protdep_input,
  freqdep_input
)
```

## Arguments

- protocols_input:

  List of protocol definitions.

- ndimen_input:

  Dimensions of the problem.

- nbprot_input:

  Number of protocols.

- numprot_input:

  Protocol indices.

- freq_input:

  Frequencies of protocols.

- nbdata_input:

  Data point counts.

- vectps_input:

  Sampling times vector.

- fisher_input:

  Fisher matrix inputs.

- nok_input:

  Error code/status.

- protdep_input:

  Initial protocol indices.

- freqdep_input:

  Initial frequencies.

## Value

A list containing optimal frequencies, sampling times, and the resulting
FIM.
