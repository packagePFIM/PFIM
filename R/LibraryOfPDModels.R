#' @title LibraryOfPDModels Class
#' @name LibraryOfPDModels
#' @description
#' The \code{LibraryOfPDModels} class is a specialized container for managing
#' and storing Pharmacodynamic (PD) model definitions.
#' @details
#' This class inherits from \code{\link{LibraryOfModels}} and provides a
#' dedicated structure for pharmacodynamic responses. It is designed to handle
#' various PD mechanisms, including direct effect models (Emax, Sigmoid Emax),
#' indirect response models (Turnover), and kinetic-pharmacodynamic (K-PD)
#' structures.
#' @slot models A named list of PD model structures (e.g., Emax, Indirect Response).
#' @include LibraryOfModels.R
#' @template copyright
#' @export

LibraryOfPDModels = new_class("LibraryOfPDModels", package = "PFIM", parent = LibraryOfModels )

models = list(
  # Immediate Response Models

  # Drug action models

  # linear
  "ImmediateDrugLinear_S0Alin" = list( "RespPD" = "S0 + RespPK * Alin" ),
  # quadratic
  "ImmediateDrugImaxQuadratic_S0AlinAquad" = list( "RespPD" = "S0 + RespPK * Alin + Alin * (RespPK)**2" ),
  # logarithmic
  "ImmediateDrugImaxLogarithmic_S0Alog" = list( "RespPD" = "S0 + Alog * log(RespPK)" ),
  # Emax
  "ImmediateDrugEmax_S0EmaxC50" = list( "RespPD" = "S0 + Emax*RespPK/(RespPK+C50)" ),
  # Sigmoid Emax
  "ImmediateDrugSigmoidEmax_S0EmaxC50gamma" = list( "RespPD" = "S0 + Emax*(RespPK**gamma)/(RespPK**gamma+C50**gamma)" ),
  # Imax
  "ImmediateDrugImax_S0ImaxC50" = list( "RespPD" = "S0 * (1 - Imax * RespPK/( RespPK + C50 ))" ),
  # Sigmoid Imax
  "ImmediateDrugImax_S0ImaxC50_gamma" = list( "RespPD" = "S0 * (1 - Imax * RespPK/(RespPK**gamma + C50**gamma ) )" ),

  # Baseline/disease models

  # Constant
  "ImmediateBaselineConstant_S0" = list( "RespPD" = "S0" ),
  # Linear
  "ImmediateBaselineLinear_S0kprog" = list( "RespPD" = "S0 + kprog*t" ),
  # Exponential disease increase
  "ImmediateBaselineExponentialincrease_S0kprog" = list( "RespPD" = "S0*exp(-kprog*t)" ),
  # Exponential disease decrease
  "ImmediateBaselineExponentialdecrease_S0kprog" = list( "RespPD" = "S0*(1-exp(-kprog*t))" ),

  # Turnover Models

  # Models with impact on the input (Rin)

  # Emax
  "TurnoverRinEmax_RinEmaxCC50koutE" = list( "Deriv_E" = "Rin*(1+(Emax*RespPK)/(RespPK+C50))-kout*E" ),
  # Sigmoid Emax
  "TurnoverRinSigmoidEmax_RinEmaxCC50koutE" = list( "Deriv_E" = "Rin*(1+(Emax*RespPK**gamma)/(RespPK**gamma+C50**gamma))-kout*E" ),
  # Imax
  "TurnoverRinImax_RinImaxCC50koutE" = list( "Deriv_E" = "Rin*(1-(Imax*RespPK)/(RespPK+C50))-kout*E" ),
  # Sigmoid Imax
  "TurnoverRinSigmoidImax_RinImaxCC50koutE" = list( "Deriv_E" = "Rin*(1-(Imax*RespPK**gamma)/(RespPK**gamma+C50**gamma))-kout*E" ),
  # Full Imax
  "TurnoverRinFullImax_RinCC50koutE" = list( "Deriv_E" = "(Rin*(1-(RespPK)/(RespPK+C50))-kout*E)" ),
  # Sigmoid Full Imax
  "TurnoverRinSigmoidFullImax_RinCC50koutE" = list( "Deriv_E" = "Rin*(1-RespPK**gamma/(RespPK**gamma+C50**gamma))-kout*E" ),

  # Models with impact on the output (kout)

  # Emax
  "TurnoverkoutEmax_RinEmaxCC50koutE" = list( "Deriv_E" = "Rin*(1+(Emax*RespPK)/(RespPK+C50))-kout*E" ),

  # Sigmoid Emax
  "TurnoverkoutSigmoidEmax_RinEmaxCC50koutEgamma" = list("Deriv_E" = "Rin-kout*(1+(Emax*RespPK**gamma)/(RespPK**gamma+C50**gamma))*E"),
  # Imax
  "TurnoverkoutImax_RinImaxCC50koutE" = list("Deriv_E" = "Rin-kout*(1-Imax*RespPK/(RespPK+C50))*E"),
  # Sigmoid Imax
  "TurnoverkoutSigmoidImax_RinImaxCC50koutEgamma" = list("Deriv_E" = "Rin-kout*(1-Imax*RespPK**gamma/(RespPK**gamma+C50**gamma))*E"),
  # Full Imax
  "TurnoverkoutFullImax_RinCC50koutE" = list("Deriv_E" = "Rin-kout*(1-RespPK/(RespPK+C50))*E"),
  # Sigmoid Full Imax
  "TurnoverkoutSigmoidFullImax_RinCC50koutE" = list("Deriv_E" = "Rin-kout*(1-RespPK**gamma/(RespPK**gamma+C50**gamma))*E") )

LibraryOfPDModels = LibraryOfPDModels( models )






