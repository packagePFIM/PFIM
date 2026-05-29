---
output:
  pdf_document: default
  html_document: default
---
# PFIM 7.1 Beta version — Test and Optimisation Scripts for covariate and IOV

This folder contains five R scripts for testing and optimising population
pharmacokinetic designs using the PFIM package. All scripts share the same
underlying model: a one-compartment PK model with first-order absorption,
log-normally distributed parameters, and a constant additive residual error.

---

## Common model specification

| Element | Value |
|---|---|
| PK equation | `dose/V * ka/(ka - Cl/V) * (exp(-Cl/V*t) - exp(-ka*t))` |
| ka | LogNormal(mu = 1, omega = 0.3) |
| V | LogNormal(mu = 3.5, omega = 0.3) |
| Cl | LogNormal(mu = 2 or 0.5, omega = 0.3) |
| IOV (when present) | gamma = sqrt(0.0225) on all three parameters |
| Residual error | Constant, sigmaInter = 0.1 |
| Fixed covariate | Sex on V: beta = log(1.2), ratio V_F/V_M = 1.20, 50/50 M/F |
| Occasion covariate | Treatment on Cl: AB/BA cross-over, beta = log(1.1), ratio Cl_B/Cl_A = 1.10 |

---

## Script descriptions

### `script_tests_cov_and_iov_and_tests_tost_equi_noequiv.R`

Runs six successive FIM evaluation cases that progressively increase model
complexity. Each case calls `run()` on an `Evaluation` object, displays the
result with `show()`, and saves the FIM, D-criterion, and standard errors to
a text file via `saveResult()`. Cases that include covariates additionally
call `covariateTest()` and save the three resulting statistical tables
(significance, non-relevance, relevance) via `saveResultCovariateTest()`.

The six cases are:

| Case | Covariates | IOV |
|---|---|---|
| 1 | None | No |
| 2 | None | Yes (2 occasions) |
| 3 | Fixed: Sex on V | No |
| 4 | Fixed: Sex on V | Yes (2 occasions) |
| 5 | Fixed: Sex on V + occasion: Treatment on Cl | Yes (2 occasions) |
| 6 | Occasion: Treatment on Cl only | Yes (2 occasions) |

Each case is isolated with `rm()` + `devtools::load_all()` before execution
to ensure a clean environment.

---

### `optimisation_algo_mult_withCov_mixed.R`

Optimises sampling times using the **Multiplicative algorithm** for a model
with both a fixed covariate (Sex on V) and an occasion covariate (Treatment
on Cl, AB/BA cross-over, 2 occasions). The design has 1 arm of 40 subjects
with 5 candidate sampling times (0.5, 2, 4, 6, 8 h), of which 3 are
optimisable. The algorithm maximises the D-criterion of the population FIM.

Optimiser parameters: lambda = 0.99, 1000 iterations, weight threshold =
0.01, delta = 1e-4.

---

### `optimisation_algo_simplex_withCov_mixed.R`

Optimises sampling times using the **Simplex algorithm** for the same mixed
covariate structure as above (Sex on V + Treatment on Cl, AB/BA cross-over,
2 occasions). The design has 1 arm of 100 subjects with 10 candidate
sampling times distributed across two windows: [0, 24] h (6 samples) and
[35, 130] h (4 samples), with minimum inter-sample gaps of 1 h and 2 h
respectively.

Optimiser parameters: 20% initial simplex perturbation, 200 iterations,
tolerance = 1e-6.

---

### `optimisation_algo_simplex_withCov_withIOV.R`

Optimises sampling times using the **Simplex algorithm** for a model with a
fixed covariate only (Sex on V) and IOV on all three parameters (2
occasions). Same design and constraint structure as
`optimisation_algo_simplex_withCov_mixed.R` (100 subjects, two sampling
windows), but without the occasion covariate Treatment.

---

### `optimisation_algo_simplex_withCovOccasion.R`

Optimises sampling times using the **Simplex algorithm** for a model with an
occasion covariate only (Treatment on Cl, AB/BA cross-over, 2 occasions) and
no fixed covariate. Same design and constraint structure as the other Simplex
scripts (100 subjects, two sampling windows).

---

## Output files

All evaluation results are written to the directory defined by
`file.path(folder_PFIM, folder_results)` at the top of the evaluation
script. Each case produces one or two plain-text files:

- `casN_<label>.txt` — FIM matrix, D-criterion, and SE for the evaluation.
- `casN_<label>_resultsClinicalRelevance.txt` — significance, non-relevance, 
and relevance tables from `covariateTest()` (cases 3–6 only).

Optimisation scripts display results in the console via `show()` and do not
write output files.

---

## Dependencies

- R package **PFIM** (loaded via `library(PFIM)` or `devtools::load_all()`).
- No other external packages are required beyond those imported by PFIM.
