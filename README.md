
# PFIM 

[![CRAN](http://www.r-pkg.org/badges/version/PFIM)](http://cran.r-project.org/package=PFIM)

![Logo_PFIM](Logo_PFIM.png)

Total number of downloads for the entire history of the package
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/grand-total/PFIM?color=blue)]([https://r-pkg.org/pkg/PFIM](https://cran.r-project.org/package=PFIM))

Monthly downloads
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/last-month/PFIM?color=blue)]([https://r-pkg.org/pkg/PFIM](https://cran.r-project.org/package=PFIM))
<!--
Weekly downloads 
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/last-week/PFIM?color=blue)]([https://r-pkg.org/pkg/PFIM](https://cran.r-project.org/package=PFIM))

Daily downloads
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/last-day/PFIM?color=blue)]([https://r-pkg.org/pkg/PFIM](https://cran.r-project.org/package=PFIM))
 -->
#

## Evaluate or optimize designs for nonlinear mixed effects models using the Fisher Information Matrix.

Methods used in the package refer to Mentré F, Mallet A, Baccar D (1997)
<doi:10.1093/biomet/84.2.429>, Retout S, Comets E, Samson A, Mentré F
(2007) <doi:10.1002/sim.2910>, Bazzoli C, Retout S, Mentré F (2009)
<doi:10.1002/sim.3573>, Le Nagard H, Chao L, Tenaillon O (2011)
<doi:10.1186/1471-2148-11-326>, Combes FP, Retout S, Frey N, Mentré F
(2013) <doi:10.1007/s11095-013-1079-3> and Seurat J, Tang Y, Mentré F,
Nguyen TT (2021) <doi:10.1016/j.cmpb.2021.106126>

Version: 7.0

Author and creator: Romain Leroux \[aut, cre\]

Author: France Mentré ORCID <https://orcid.org/0000-0002-7045-1275>
\[aut\]

Contributors: Jérémy Seurat \[ctb]

Maintainer: Romain Leroux \<romainlerouxPFIM@gmail.com\>

License: GPL-2 \| GPL-3 \[expanded from: GPL (≥ 2)\]

## Vignettes

The folder vignettes/ contains the two exemples that are given as
vignettes on the CRAN.

## Examples

Several examples have been implemented in PFIM 7.0 and the full list and
reports are given in **Examples_reports.md**. Source scripts are
available in the folder Examples/, whose sub folders are organized as
follows:

- Examples/
  - evaluation/
    - analytic/
    - analytic_infusion/
    - ode/
    - ode_infusion/
  - optimization/
    - AlgoMutiplicatif/
    - FedorovWynn/
    - PGBO/
    - PSO/
    - Simplex/

To execute all those scripts successively, one can run the script
**run_Examples.R**. The reports will be created in the folder
Outputs/Examples/.

## Evaluation tests

Several tests are available for design evaluation with PFIM; they are
located in the folder tests_evaluation/, whose sub-folders are organized
as follows:

- tests_evaluation/ :
  - library_of_models/ : contains scripts that test the building of
    models with the library
  - models_library_of_model/ : contains scripts that perform evaluation
    on models built with the library of models
  - models_user_defined/ : contains scripts that perform evaluation on
    models built manually by the user

To execute one scripts from models_library_of_model/ or
models_user_defined/, one has to define the variable `fimType` to either
`population`, `individual` or `Bayesian`.

To execute all those scripts successively, one can run the script
**run_tests_evaluation.R**. The outputs will be displayed in the folder
Outputs/tests_evaluation/.

## Optimization tests

Several tests are available for design optimization with PFIM; they are
located in the folder tests_optimization/, whose sub-folders are
organized by algorithm.

- tests_optimization/ :
  - FedorovWynn/
  - MultiplicativeAlgorithm/
  - PGBO/
  - PSO/
  - Simplex/

To execute all those scripts successively, one can run the script
**run_tests_optimization.R**. The outputs will be displayed in the
folder Outputs/tests_evaluation/.

# Getting help

If you encounter a clear bug, please file the issue with a minimal
reproducible example in the folder Issues.

For questions and other discussion, please use the PFIM group mailing
list: <thepfimgroup@googlegroups.com>
