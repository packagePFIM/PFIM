# Package index

## Main classes

Top-level objects: evaluation and optimization of experimental designs

- [`PFIM`](https://packagePFIM.github.io/PFIM/reference/PFIM-package.md)
  [`PFIM-package`](https://packagePFIM.github.io/PFIM/reference/PFIM-package.md)
  [`PFIM,`](https://packagePFIM.github.io/PFIM/reference/PFIM-package.md)
  [`package-PFIM`](https://packagePFIM.github.io/PFIM/reference/PFIM-package.md)
  : Fisher Information matrix for design evaluation/optimization for
  nonlinear mixed effects models.
- [`PFIMProject()`](https://packagePFIM.github.io/PFIM/reference/PFIMProject.md)
  : PFIMProject Class
- [`Evaluation()`](https://packagePFIM.github.io/PFIM/reference/Evaluation.md)
  : Evaluation Class
- [`Optimization()`](https://packagePFIM.github.io/PFIM/reference/Optimization.md)
  : Optimization Class

## Run & display

- [`run()`](https://packagePFIM.github.io/PFIM/reference/run.md) : run
- [`show()`](https://packagePFIM.github.io/PFIM/reference/show.md) :
  show

## Plot

Unified OO entry point.
[`plot()`](https://packagePFIM.github.io/PFIM/reference/plot.md)
dispatches on the object class and returns a named list of ggplot2
objects. Specific plot functions are also available.

- [`plot()`](https://packagePFIM.github.io/PFIM/reference/plot.md) :
  plot
- [`plotSE()`](https://packagePFIM.github.io/PFIM/reference/plotSE.md) :
  plotSE
- [`plotRSE()`](https://packagePFIM.github.io/PFIM/reference/plotRSE.md)
  : plotRSE
- [`plotEvaluation()`](https://packagePFIM.github.io/PFIM/reference/plotEvaluation.md)
  : plotEvaluation
- [`plotSensitivityIndices()`](https://packagePFIM.github.io/PFIM/reference/plotSensitivityIndices.md)
  : plotSensitivityIndices
- [`plotWeights()`](https://packagePFIM.github.io/PFIM/reference/plotWeights.md)
  : Visualize the distribution of optimal design weights
- [`plotFrequencies()`](https://packagePFIM.github.io/PFIM/reference/plotFrequencies.md)
  : plotFrequencies: visualize optimal frequencies for the Fedorov-Wynn
  algorithm
- [`plotSEFIM`](https://packagePFIM.github.io/PFIM/reference/plotSEFIM.md)
  : Bar plot for Standard Errors (SE)
- [`plotRSEFIM`](https://packagePFIM.github.io/PFIM/reference/plotRSEFIM.md)
  : Bar plot for Relative Standard Errors (RSE)
- [`plotShrinkage`](https://packagePFIM.github.io/PFIM/reference/plotShrinkage.md)
  : plotShrinkage: Bar plot for Bayesian Shrinkage
- [`plotWeightsMultiplicativeAlgorithm`](https://packagePFIM.github.io/PFIM/reference/plotWeightsMultiplicativeAlgorithm.md)
  : Visualize Optimal Weight Distribution from Multiplicative Algorithm
- [`plotFrequenciesFedorovWynnAlgorithm`](https://packagePFIM.github.io/PFIM/reference/plotFrequenciesFedorovWynnAlgorithm.md)
  : plotFrequenciesFedorovWynnAlgorithm for the FedorovWynnAlgorithm
- [`plotEvaluationResults()`](https://packagePFIM.github.io/PFIM/reference/plotEvaluationResults.md)
  : Plot model responses for an arm
- [`plotEvaluationSI()`](https://packagePFIM.github.io/PFIM/reference/plotEvaluationSI.md)
  : Plot sensitivity indices for an arm
- [`processArmEvaluationResults()`](https://packagePFIM.github.io/PFIM/reference/processArmEvaluationResults.md)
  : Process arm evaluation for response plots
- [`processArmEvaluationSI()`](https://packagePFIM.github.io/PFIM/reference/processArmEvaluationSI.md)
  : Process arm evaluation for sensitivity index plots

## Accessors

Extract results from Evaluation or Optimization objects

- [`getFim()`](https://packagePFIM.github.io/PFIM/reference/getFim.md) :
  getFim
- [`getFisherMatrix()`](https://packagePFIM.github.io/PFIM/reference/getFisherMatrix.md)
  : getFisherMatrix
- [`getSE()`](https://packagePFIM.github.io/PFIM/reference/getSE.md) :
  getSE
- [`getRSE()`](https://packagePFIM.github.io/PFIM/reference/getRSE.md) :
  getRSE
- [`getShrinkage()`](https://packagePFIM.github.io/PFIM/reference/getShrinkage.md)
  : getShrinkage
- [`getDeterminant()`](https://packagePFIM.github.io/PFIM/reference/getDeterminant.md)
  : getDeterminant
- [`getDcriterion()`](https://packagePFIM.github.io/PFIM/reference/getDcriterion.md)
  : getDcriterion: Extract the D-optimality criterion
- [`getCorrelationMatrix()`](https://packagePFIM.github.io/PFIM/reference/getCorrelationMatrix.md)
  : getCorrelationMatrix
- [`Dcriterion`](https://packagePFIM.github.io/PFIM/reference/Dcriterion.md)
  : Dcriterion

## Report

- [`Report()`](https://packagePFIM.github.io/PFIM/reference/Report.md) :
  Report
- [`generateReportEvaluation`](https://packagePFIM.github.io/PFIM/reference/generateReportEvaluation.md)
  : Generate a Comprehensive HTML Evaluation Report
- [`generateReportOptimization`](https://packagePFIM.github.io/PFIM/reference/generateReportOptimization.md)
  : Generate the HTML Report for Design Optimization
- [`tablesForReport`](https://packagePFIM.github.io/PFIM/reference/tablesForReport.md)
  : Generate Statistical Tables for Evaluation Reports
- [`constraintsTableForReport()`](https://packagePFIM.github.io/PFIM/reference/constraintsTableForReport.md)
  : Generate Algorithm Constraints Table for Reporting

## Design objects

Experimental design specification

- [`Design()`](https://packagePFIM.github.io/PFIM/reference/Design.md) :
  Design Class
- [`Arm()`](https://packagePFIM.github.io/PFIM/reference/Arm.md) : Arm
  Class
- [`SamplingTimes()`](https://packagePFIM.github.io/PFIM/reference/SamplingTimes.md)
  : SamplingTimes Class
- [`Administration()`](https://packagePFIM.github.io/PFIM/reference/Administration.md)
  : Administration Class
- [`SamplingTimeConstraints()`](https://packagePFIM.github.io/PFIM/reference/SamplingTimeConstraints.md)
  : SamplingTimeConstraints Class
- [`AdministrationConstraints()`](https://packagePFIM.github.io/PFIM/reference/AdministrationConstraints.md)
  : AdministrationConstraints Class

## Model parameters & error

- [`ModelParameter()`](https://packagePFIM.github.io/PFIM/reference/ModelParameter.md)
  : ModelParameter Class
- [`LogNormal()`](https://packagePFIM.github.io/PFIM/reference/LogNormal.md)
  : LogNormal Class
- [`Normal()`](https://packagePFIM.github.io/PFIM/reference/Normal.md) :
  Normal Class
- [`Distribution()`](https://packagePFIM.github.io/PFIM/reference/Distribution.md)
  : Distribution Class
- [`ModelError()`](https://packagePFIM.github.io/PFIM/reference/ModelError.md)
  : ModelError Class
- [`Combined1()`](https://packagePFIM.github.io/PFIM/reference/Combined.md)
  : Combined1 Class
- [`Constant()`](https://packagePFIM.github.io/PFIM/reference/Constant.md)
  : Constant Class
- [`Proportional()`](https://packagePFIM.github.io/PFIM/reference/Proportional.md)
  : Proportional Class

## FIM classes

- [`Fim()`](https://packagePFIM.github.io/PFIM/reference/Fim.md) :
  Fisher Information Matrix (FIM) Class
- [`PopulationFim()`](https://packagePFIM.github.io/PFIM/reference/PopulationFim.md)
  : PopulationFim Class
- [`IndividualFim()`](https://packagePFIM.github.io/PFIM/reference/IndividualFim.md)
  : Individual Fisher Information Matrix (IndividualFim) Class
- [`BayesianFim()`](https://packagePFIM.github.io/PFIM/reference/BayesianFim.md)
  : BayesianFim Class

## FIM methods

- [`defineFim()`](https://packagePFIM.github.io/PFIM/reference/defineFim.md)
  : Define the Fisher Information Matrix object
- [`setEvaluationFim`](https://packagePFIM.github.io/PFIM/reference/setEvaluationFim.md)
  : Format and set the Bayesian Fim results
- [`setOptimalArms`](https://packagePFIM.github.io/PFIM/reference/setOptimalArms.md)
  : Set the optimal arms for Multiplicative Algorithm
- [`showFIM`](https://packagePFIM.github.io/PFIM/reference/showFIM.md) :
  Display the Bayesian Fim in the console
- [`evaluateFim`](https://packagePFIM.github.io/PFIM/reference/evaluateFim.md)
  : Evaluation of the Bayesian Fim
- [`evaluateVarianceFIM`](https://packagePFIM.github.io/PFIM/reference/evaluateVarianceFIM.md)
  : Evaluate the Variance Component of the Fisher Information Matrix
- [`evaluateArm()`](https://packagePFIM.github.io/PFIM/reference/evaluateArm.md)
  : Evaluate an arm
- [`evaluateDesign`](https://packagePFIM.github.io/PFIM/reference/evaluateDesign.md)
  : Evaluation of a clinical design
- [`evaluateModel`](https://packagePFIM.github.io/PFIM/reference/evaluateModel.md)
  : evaluate the model
- [`evaluateModelGradient`](https://packagePFIM.github.io/PFIM/reference/evaluateModelGradient.md)
  : evaluate the gradient of the model
- [`evaluateModelVariance`](https://packagePFIM.github.io/PFIM/reference/evaluateModelVariance.md)
  : Evaluate Model Variance and Sigma Derivatives
- [`evaluateErrorModelDerivatives`](https://packagePFIM.github.io/PFIM/reference/evaluateErrorModelDerivatives.md)
  : evaluate the derivatives of the model error.
- [`evaluateInitialConditions`](https://packagePFIM.github.io/PFIM/reference/evaluateInitialConditions.md)
  : evaluate the initial conditions.
- [`computeVMat()`](https://packagePFIM.github.io/PFIM/reference/computeVMat.md)
  : Compute Variance Matrix Component

## Model classes

- [`Model()`](https://packagePFIM.github.io/PFIM/reference/Model.md) :
  Model Class
- [`ModelAnalytic()`](https://packagePFIM.github.io/PFIM/reference/ModelAnalytic.md)
  : ModelAnalytic Class
- [`ModelAnalyticInfusion()`](https://packagePFIM.github.io/PFIM/reference/ModelAnalyticInfusion.md)
  : ModelAnalyticInfusion Class
- [`ModelAnalyticInfusionSteadyState()`](https://packagePFIM.github.io/PFIM/reference/ModelAnalyticInfusionSteadyState.md)
  : ModelAnalyticInfusionSteadyState Class
- [`ModelAnalyticSteadyState()`](https://packagePFIM.github.io/PFIM/reference/ModelAnalyticSteadyState.md)
  : ModelAnalyticSteadyState Class
- [`ModelInfusion()`](https://packagePFIM.github.io/PFIM/reference/ModelInfusion.md)
  : ModelInfusion Class
- [`ModelODE()`](https://packagePFIM.github.io/PFIM/reference/ModelODE.md)
  : ModelODE Class
- [`ModelODEBolus()`](https://packagePFIM.github.io/PFIM/reference/ModelODEBolus.md)
  : ModelODEBolus Class
- [`ModelODEDoseInEquations()`](https://packagePFIM.github.io/PFIM/reference/ModelODEDoseInEquations.md)
  : ModelODEDoseInEquations Class
- [`ModelODEDoseNotInEquations()`](https://packagePFIM.github.io/PFIM/reference/ModelODEDoseNotInEquations.md)
  : ModelODEDoseNotInEquations Class
- [`ModelODEInfusion()`](https://packagePFIM.github.io/PFIM/reference/ModelODEInfusion.md)
  : ModelODEInfusion Class
- [`ModelODEInfusionDoseInEquation()`](https://packagePFIM.github.io/PFIM/reference/ModelODEInfusionDoseInEquation.md)
  : ModelODEInfusionDoseInEquation Class

## Model helpers

- [`defineModelType()`](https://packagePFIM.github.io/PFIM/reference/defineModelType.md)
  : defineModelType
- [`defineModelEquationsFromLibraryOfModel()`](https://packagePFIM.github.io/PFIM/reference/defineModelEquationsFromLibraryOfModel.md)
  : defineModelEquationsFromLibraryOfModel
- [`defineModelWrapper`](https://packagePFIM.github.io/PFIM/reference/defineModelWrapper.md)
  : define the model wrapper for the ode solver
- [`defineModelAdministration`](https://packagePFIM.github.io/PFIM/reference/defineModelAdministration.md)
  : define the administration
- [`definePKModel`](https://packagePFIM.github.io/PFIM/reference/definePKModel.md)
  : define a PK model from library of model
- [`definePKPDModel`](https://packagePFIM.github.io/PFIM/reference/definePKPDModel.md)
  : define a PKPD model from library of model
- [`convertPKModelAnalyticToPKModelODE`](https://packagePFIM.github.io/PFIM/reference/convertPKModelAnalyticToPKModelODE.md)
  : conversion from analytic to ode
- [`finiteDifferenceHessian`](https://packagePFIM.github.io/PFIM/reference/finiteDifferenceHessian.md)
  : Compute the Hessian

## Library of models

Pre-implemented standard PK/PD structural models

- [`LibraryOfModels()`](https://packagePFIM.github.io/PFIM/reference/LibraryOfModels.md)
  : LibraryOfModels Class
- [`LibraryOfPKModels`](https://packagePFIM.github.io/PFIM/reference/LibraryOfPKModels.md)
  : LibraryOfPKModels Class
- [`LibraryOfPDModels`](https://packagePFIM.github.io/PFIM/reference/LibraryOfPDModels.md)
  : LibraryOfPDModels Class
- [`Linear2BolusSingleDose_ClQV1V2()`](https://packagePFIM.github.io/PFIM/reference/Linear2BolusSingleDose_ClQV1V2.md)
  : Model Linear2BolusSingleDose_ClQV1V2
- [`Linear2BolusSingleDose_kk12k21V()`](https://packagePFIM.github.io/PFIM/reference/Linear2BolusSingleDose_kk12k21V.md)
  : Model Linear2BolusSingleDose_kk12k21V
- [`Linear2BolusSteadyState_ClQV1V2tau()`](https://packagePFIM.github.io/PFIM/reference/Linear2BolusSteadyState_ClQV1V2tau.md)
  : Model Linear2BolusSteadyState_ClQV1V2tau
- [`Linear2BolusSteadyState_kk12k21Vtau()`](https://packagePFIM.github.io/PFIM/reference/Linear2BolusSteadyState_kk12k21Vtau.md)
  : Model Linear2BolusSteadyState_kk12k21Vtau
- [`Linear2FirstOrderSingleDose_kaClQV1V2()`](https://packagePFIM.github.io/PFIM/reference/Linear2FirstOrderSingleDose_kaClQV1V2.md)
  : Model Linear2FirstOrderSingleDose_kaClQV1V2
- [`Linear2FirstOrderSingleDose_kakk12k21V()`](https://packagePFIM.github.io/PFIM/reference/Linear2FirstOrderSingleDose_kakk12k21V.md)
  : Model Linear2FirstOrderSingleDose_kakk12k21V
- [`Linear2FirstOrderSteadyState_kaClQV1V2tau()`](https://packagePFIM.github.io/PFIM/reference/Linear2FirstOrderSteadyState_kaClQV1V2tau.md)
  : Model Linear2FirstOrderSteadyState_kaClQV1V2tau
- [`Linear2FirstOrderSteadyState_kakk12k21Vtau()`](https://packagePFIM.github.io/PFIM/reference/Linear2FirstOrderSteadyState_kakk12k21Vtau.md)
  : Model Linear2FirstOrderSteadyState_kakk12k21Vtau
- [`Linear2InfusionSingleDose_ClQV1V2()`](https://packagePFIM.github.io/PFIM/reference/Linear2InfusionSingleDose_ClQV1V2.md)
  : Model Linear2InfusionSingleDose_ClQV1V2
- [`Linear2InfusionSingleDose_kk12k21V()`](https://packagePFIM.github.io/PFIM/reference/Linear2InfusionSingleDose_kk12k21V.md)
  : Model Linear2InfusionSingleDose_kk12k21V
- [`Linear2InfusionSteadyState_ClQV1V2tau()`](https://packagePFIM.github.io/PFIM/reference/Linear2InfusionSteadyState_ClQV1V2tau.md)
  : Model Linear2InfusionSteadyState_ClQV1V2tau
- [`Linear2InfusionSteadyState_kk12k21Vtau()`](https://packagePFIM.github.io/PFIM/reference/Linear2InfusionSteadyState_kk12k21Vtau.md)
  : Model Linear2InfusionSteadyState_kk12k21Vtau
- [`replaceVariablesLibraryOfModels()`](https://packagePFIM.github.io/PFIM/reference/replaceVariablesLibraryOfModels.md)
  : : replace variable in the LibraryOfModels

## Optimization algorithms

- [`defineOptimizationAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/defineOptimizationAlgorithm.md)
  : Define Optimization Algorithm
- [`FedorovWynnAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/FedorovWynnAlgorithm.md)
  : FedorovWynnAlgorithm Class
- [`MultiplicativeAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/MultiplicativeAlgorithm.md)
  : MultiplicativeAlgorithm Class
- [`SimplexAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/SimplexAlgorithm.md)
  : SimplexAlgorithm Class
- [`PSOAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/PSOAlgorithm.md)
  : PSOAlgorithm Class
- [`PGBOAlgorithm()`](https://packagePFIM.github.io/PFIM/reference/PGBOAlgorithm.md)
  : PGBOAlgorithm Class
- [`optimizeDesign()`](https://packagePFIM.github.io/PFIM/reference/optimizeDesign.md)
  : Optimize Study Design
- [`generateFimsFromConstraints()`](https://packagePFIM.github.io/PFIM/reference/generateFimsFromConstraints.md)
  : Generate Fisher Information Matrices (FIM) from Design Constraints
- [`FedorovWynnAlgorithm_Rcpp()`](https://packagePFIM.github.io/PFIM/reference/FedorovWynnAlgorithm_Rcpp.md)
  : FedorovWynnAlgorithm with Rcpp
- [`MultiplicativeAlgorithm_Rcpp()`](https://packagePFIM.github.io/PFIM/reference/MultiplicativeAlgorithm_Rcpp.md)
  : Rcpp Multiplicative Algorithm for Optimal Design
- [`fisherSimplex`](https://packagePFIM.github.io/PFIM/reference/fisherSimplex.md)
  : Compute the fisher.simplex
- [`fun.amoeba()`](https://packagePFIM.github.io/PFIM/reference/fun.amoeba.md)
  : Compute the Amoeba (Nelder-Mead) Simplex Search

## Sampling & dose helpers

- [`setSamplingConstraintForOptimization`](https://packagePFIM.github.io/PFIM/reference/setSamplingConstraintForOptimization.md)
  : Initialize sampling constraints
- [`updateSamplingTimes()`](https://packagePFIM.github.io/PFIM/reference/updateSamplingTimes.md)
  : Update sampling times for plotting
- [`getSamplingData()`](https://packagePFIM.github.io/PFIM/reference/getSamplingData.md)
  : Extract sampling times and maximum sampling time
- [`checkSamplingTimeConstraintsForMetaheuristic`](https://packagePFIM.github.io/PFIM/reference/checkSamplingTimeConstraintsForMetaheuristic.md)
  : Validate New Sampling Schedules Against Constraints
- [`checkValiditySamplingConstraint`](https://packagePFIM.github.io/PFIM/reference/checkValiditySamplingConstraint.md)
  : Validate optimization constraints
- [`generateSamplingsFromSamplingConstraints`](https://packagePFIM.github.io/PFIM/reference/generateSamplingsFromSamplingConstraints.md)
  : Generate Numerical Intervals from Sampling Constraints
- [`generateSamplingTimesCombination`](https://packagePFIM.github.io/PFIM/reference/generateSamplingTimesCombination.md)
  : Generate sampling time combinations
- [`generateDosesCombination`](https://packagePFIM.github.io/PFIM/reference/generateDosesCombination.md)
  : Generate dose combinations for optimization
- [`armAdministration()`](https://packagePFIM.github.io/PFIM/reference/armAdministration.md)
  : Get administration parameters of an arm
- [`getArmConstraints()`](https://packagePFIM.github.io/PFIM/reference/getArmConstraints.md)
  : Get arm constraints for optimization algorithms
- [`getArmData()`](https://packagePFIM.github.io/PFIM/reference/getArmData.md)
  : Extract arm data for reporting

## Utilities

- [`getListLastName()`](https://packagePFIM.github.io/PFIM/reference/getListLastName.md)
  : getListLastName: Get names of the deepest elements in a nested list
- [`getModelErrorData`](https://packagePFIM.github.io/PFIM/reference/getModelErrorData.md)
  : get the parameters sigma slope and sigma inter (used for the
  report).
- [`getModelParametersData`](https://packagePFIM.github.io/PFIM/reference/getModelParametersData.md)
  : Extract Model Parameter Data for Reporting
- [`adjustGradient`](https://packagePFIM.github.io/PFIM/reference/adjustGradient.md)
  : Adjust the gradient for the log normal distribution.
