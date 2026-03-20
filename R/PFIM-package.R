#' @name PFIM-package
#' @aliases PFIM, package-PFIM
#' @docType package
#' @encoding UTF-8
#' @title Fisher Information matrix for design evaluation/optimization for  nonlinear mixed effects models.
#' @section Description:
#' Nonlinear mixed effects models (NLMEM) are widely used in model-based drug development and use to analyze
#' longitudinal data. The use of the "population" Fisher Information Matrix (FIM) is a good alternative to
#' clinical trial simulation to optimize the design of these studies. The present version, **PFIM 7.0**, is an R package that uses the S4 object system for evaluating and/or
#' optimizing population designs based on FIM in NLMEMs.
#'
#' This version of **PFIM** now includes a library of models implemented also using the object oriented system S4 of R.
#' This library contains two libraries of pharmacokinetic (PK) and/or pharmacodynamic (PD) models. The PK library includes model with different
#' administration routes (bolus, infusion, first-order absorption), different number of compartments (from 1 to 3), and different types of eliminations
#' (linear or Michaelis-Menten). The PD model library, contains direct immediate models (e.g. Emax and Imax) with various baseline models, and turnover
#' response models. The PK/PD models are obtained with combination of the models from the PK and PD model libraries. **PFIM** handles both analytical
#' and ODE models and offers the possibility to the user to define his/her own model(s).
#' In **PFIM 7.0**, the FIM is evaluated by first order linearization of the model assuming a block diagonal FIM as in Mentré et al. (1997). The Bayesian FIM is also
#' available to give shrinkage predictions (Combes et al., 2013).
#' **PFIM 7.0** includes several algorithms to conduct design optimization based on the D-criterion, given design constraints: the simplex algorithm (Nelder-Mead) (Nelder & Mead, 1965), the
#' multiplicative algorithm (Seurat et al., 2021), the Fedorov-Wynn algorithm (Fedorov, 1972), PSO (*Particle Swarm Optimization*) and PGBO (*Population Genetics Based
#' Optimizer*) (Le Nagard et al., 2011).
#'
#' @section Documentation:
#' Documentation and user guide are available at \url{http://www.pfim.biostat.fr/}
#'
#' @section Validation:
#' **PFIM 7.0** also provides quality control with tests and validation using the evaluated FIM to assess the validity of the new version and its new
#' features. Finally, **PFIM 7.0** displays all the results with both clear graphical form and a data summary, while ensuring their easy manipulation in
#' R. The standard data visualization package ggplot2 for R is used to display all the results with clear graphical form (Wickham, 2016). A quality control using the
#' D-criterion is also provided.
#'
#' @references
#' Dumont C, Lestini G, Le Nagard H, Mentré F, Comets E, Nguyen TT, et al. PFIM 4.0, an extended R program for design evaluation and optimization in
#' nonlinear mixed-effect models. Comput Methods Programs Biomed. 2018;156:217-29.
#'
#' Chambers JM. Object-Oriented Programming, Functional Programming and R. Stat Sci. 2014;29:167-80.
#'
#' Mentré F, Mallet A, Baccar D. Optimal Design in Random-Effects Regression Models. Biometrika. 1997;84:429-42.
#'
#' Combes FP, Retout S, Frey N, Mentré F. Prediction of shrinkage of individual parameters using the Bayesian information matrix in nonlinear mixed effect models with evaluation in pharmacokinetics. Pharm Res. 2013;30:2355-67.
#'
#' Nelder JA, Mead R. A simplex method for function minimization. Comput J. 1965;7:308-13.
#'
#' Seurat J, Tang Y, Mentré F, Nguyen, TT. Finding optimal design in nonlinear mixed effect models using multiplicative algorithms. Computer Methods and Programs in Biomedicine, 2021.
#'
#' Fedorov VV. Theory of Optimal Experiments. Academic Press, New York, 1972.
#'
#' Eberhart RC, Kennedy J. A new optimizer using particle swarm theory. Proc. of the Sixth International Symposium on Micro Machine and Human Science, Nagoya, 4-6 October 1995, 39-43.
#'
#' Le Nagard H, Chao L, Tenaillon O. The emergence of complexity and restricted pleiotropy in adapting networks. BMC Evol Biol. 2011;11:326.
#'
#' Wickham H. ggplot2: Elegant Graphics for Data Analysis, Springer-Verlag New York, 2016.
#'
#' @section Organization of the source files in the `/R` folder:
#' **PFIM 7.0** contains a hierarchy of S4 classes with corresponding methods and functions serving as constructors.
#' All of the source code related to the specification of a certain class is contained in a file named `[Name_of_the_class]-Class.R`.
#' These classes include:
#'
#' 1. all roxygen `@include` to insure the correctly generated collate for the DESCRIPTION file,
#' 2. a description of purpose and slots of the class,
#' 3. specification of an initialize method,
#' 4. all getter and setter, respectively returning attributes of the object and associated objects.
#'
# @section Content of the source code and files in the \code{/R} folder:
#'
"_PACKAGE"
