#' @title LibraryOfPKModels Class
#' @name LibraryOfPKModels
#' @description
#' The \code{LibraryOfPKModels} class is a specialized container for managing
#' and storing Pharmacokinetic (PK) model definitions.
#' @details
#' This class inherits from \code{LibraryOfModels}. It is specifically optimized
#' to handle PK-specific attributes such as absorption types (e.g., Bolus,
#' Infusion, Zero-Order), clearance structures, and compartmental volumes.
#' @slot models A named list of PK model structures (e.g., 1-compartment, 2-compartment).
#' @include LibraryOfModels.R
#' @template copyright
#' @export

LibraryOfPKModels = new_class( "LibraryOfPKModels", package = "PFIM", parent = LibraryOfModels )

#' Model Linear2BolusSingleDose_ClQV1V2
#' @name Linear2BolusSingleDose_ClQV1V2
#' @export

Linear2BolusSingleDose_ClQV1V2 = function(){

  beta_expr = "0.5*(Q/V1+Q/V2+Cl/V1-sqrt((Q/V1 + Q/V2 + Cl/V1)^2 - 4*Q/V2*Cl/V1))"
  alpha_expr = str_replace("(Q/V2*Cl/V1)/beta", "beta", beta_expr)

  A_expr = "(1/V1)*(alpha-Q/V2)/(alpha-beta)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))
  B_expr = "(1/V1)*(beta-Q/V2)/(beta-alpha)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))

  model_expression = "dose_RespPK*(A*exp(-alpha*t) + B*exp(-beta*t))" %>%
    str_replace("alpha", alpha_expr) %>% str_replace("beta", beta_expr) %>%
    str_replace("A", A_expr) %>% str_replace("B", B_expr)

  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2BolusSingleDose_kk12k21V
#' @name Linear2BolusSingleDose_kk12k21V
#' @export

Linear2BolusSingleDose_kk12k21V = function(){

  beta_expr = "0.5*(k12+k21+k-sqrt((k12 + k21 + k)^2 - 4*k21*k))"
  alpha_expr = str_replace("(k21*k)/beta", "beta", beta_expr)

  A_expr = "1/V * (alpha-k21)/(alpha-beta)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))
  B_expr = "1/V * (beta-k21)/(beta-alpha)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))

  model_expression = "dose_RespPK * (A * exp(-alpha*t) + B * exp(-beta*t))" %>%
    str_replace_all(c( "alpha" = alpha_expr,"beta" = beta_expr,"A" = A_expr, "B" = B_expr))

  model_expression = model_expression  %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2BolusSteadyState_ClQV1V2tau
#' @name Linear2BolusSteadyState_ClQV1V2tau
#' @export

Linear2BolusSteadyState_ClQV1V2tau = function(){

  beta_expr = "0.5*(Q/V1+Q/V2+Cl/V1-sqrt((Q/V1 + Q/V2 + Cl/V1)^2 - 4*Q/V2*Cl/V1))"
  alpha_expr = "(Q/V2*Cl/V1)/beta" %>% str_replace("beta", beta_expr)

  A_coef = "1/V1*(alpha-Q/V2)/(alpha-beta)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))
  B_coef = "1/V1*(beta-Q/V2)/(beta-alpha)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))

  model_expression = "dose_RespPK*(A*exp(-alpha*t)/exp(1-exp(-alpha*tau)) + B*exp(-beta*t)/exp(1-exp(-beta*tau)))" %>%
    str_replace_all(c( "alpha" = alpha_expr,"beta" = beta_expr,"A" = A_coef, "B" = B_coef ))

  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2BolusSteadyState_kk12k21Vtau
#' @name Linear2BolusSteadyState_kk12k21Vtau
#' @export

Linear2BolusSteadyState_kk12k21Vtau = function(){

  beta_expr = "0.5*(k12+k21+k-sqrt((k12 + k21 + k)^2 - 4*k21*k))"
  alpha_expr = "(k21*k)/beta" %>% str_replace("beta", beta_expr)

  A_coef = "1/V*(alpha-k21)/(alpha-beta)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))
  B_coef = "1/V*(beta-k21)/(beta-alpha)" %>% str_replace_all(c("alpha" = alpha_expr, "beta" = beta_expr))

  model_expression = "dose_RespPK*(A*exp(-alpha*t)/exp(1-exp(-alpha*tau)) + B*exp(-beta*t)/exp(1-exp(-beta*tau)))" %>%
    str_replace_all(c( "alpha" = alpha_expr,"beta" = beta_expr, "A" = A_coef, "B" = B_coef ))

  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2FirstOrderSingleDose_kaClQV1V2
#' @name Linear2FirstOrderSingleDose_kaClQV1V2
#' @export

Linear2FirstOrderSingleDose_kaClQV1V2 = function(){

  beta_str = "0.5 * (Q/V1 + Q/V2 + Cl/V1 - sqrt((Q/V1 + Q/V2 + Cl/V1)^2 - 4 * Q/V2 * Cl/V1))"
  alpha_str = str_c("((Q/V2 * Cl/V1) / (", beta_str, "))")

  A_str = str_c("ka/V1 * (Q/V2 - ", alpha_str, ") / (", beta_str, " - ", alpha_str, ") / (ka - ", alpha_str, ")")
  B_str = str_c("ka/V1 * (Q/V2 - ", beta_str, ") / (", alpha_str, " - ", beta_str, ") / (ka - ", beta_str, ")")

  model_expression = str_c( "dose_RespPK * ((", A_str, ") * exp(-", alpha_str, " * t) + (",B_str, ") * exp(-", beta_str, " * t) - ((",A_str, ") + (", B_str, ")) * exp(-ka * t))")
  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2FirstOrderSingleDose_kakk12k21V
#' @name Linear2FirstOrderSingleDose_kakk12k21V
#' @export

Linear2FirstOrderSingleDose_kakk12k21V = function(){

  beta_str = "0.5 * (k12 + k21 + k - sqrt((k12 + k21 + k)^2 - 4 * k21 * k))"
  alpha_str = str_c("((k21 * k) / (", beta_str, "))")

  A_str = str_c( "ka / V * (k21 - ", alpha_str, ") / (", beta_str, " - ", alpha_str, ") / (ka - ", alpha_str, ")")
  B_str = str_c( "ka / V * (k21 - ", beta_str, ") / (", alpha_str, " - ", beta_str, ") / (ka - ", beta_str, ")")

  model_expression = str_c( "dose_RespPK * ((",A_str, ") * exp(-", alpha_str, " * t) + (",B_str, ") * exp(-", beta_str, " * t) - ((",A_str, ") + (", B_str, ")) * exp(-ka * t))")
  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2FirstOrderSteadyState_kaClQV1V2tau
#' @name Linear2FirstOrderSteadyState_kaClQV1V2tau
#' @export

Linear2FirstOrderSteadyState_kaClQV1V2tau = function(){

  beta_str = "0.5 * (Q/V1 + Q/V2 + Cl/V1 - sqrt((Q/V1 + Q/V2 + Cl/V1)^2 - 4 * Q/V2 * Cl/V1))"
  alpha_str = str_c("((Q/V2 * Cl/V1) / (", beta_str, "))")

  A_str = str_c( "ka / V1 * (Q/V2 - ", alpha_str, ") / (", beta_str, " - ", alpha_str, ") / (ka - ", alpha_str, ")")
  B_str = str_c("ka / V1 * (Q/V2 - ", beta_str, ") / (", alpha_str, " - ", beta_str, ") / (ka - ", beta_str, ")")

  model_expression = str_c("dose_RespPK * ((",A_str, ") * exp(-", alpha_str, " * t) / (1 - exp(-", alpha_str, " * tau)) + (",B_str, ") * exp(-", beta_str, " * t) / (1 - exp(-", beta_str, " * tau)) - ((",A_str, ") + (", B_str, ")) * exp(-ka * t) / (1 - exp(-ka * tau)))")
  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2FirstOrderSteadyState_kakk12k21Vtau
#' @name Linear2FirstOrderSteadyState_kakk12k21Vtau
#' @export

Linear2FirstOrderSteadyState_kakk12k21Vtau = function(){

  beta_str = "0.5 * (k12 + k21 + k - sqrt((k12 + k21 + k)^2 - 4 * k21 * k))"
  alpha_str = str_c("((k21 * k) / (", beta_str, "))")

  A_str = str_c("ka / V1 * (Q / V2 - ", alpha_str, ") / (", beta_str, " - ", alpha_str, ") / (ka - ", alpha_str, ")")
  B_str = str_c("ka / V1 * (Q / V2 - ", beta_str, ") / (", alpha_str, " - ", beta_str, ") / (ka - ", beta_str, ")")

  model_expression = str_c( "dose_RespPK * ((",A_str, ") * exp(-", alpha_str, " * t) / (1 - exp(-", alpha_str, " * tau)) + (",B_str, ") * exp(-", beta_str, " * t) / (1 - exp(-", beta_str, " * tau)) - ((",A_str, ") + (", B_str, ")) * exp(-ka * t) / (1 - exp(-ka * tau)))")
  model_expression = model_expression %>% str_replace_all("\\s+", " ")

  return( model_expression ) }

#' Model Linear2InfusionSingleDose_kk12k21V
#' @name Linear2InfusionSingleDose_kk12k21V
#' @export

Linear2InfusionSingleDose_kk12k21V = function(){

  beta_str = "0.5 * (k12 + k21 + k - sqrt((k12 + k21 + k)^2 - 4 * k21 * k))"
  alpha_str = str_c("((k21 * k) / (", beta_str, "))")

  A_str = str_c("1 / V * (", alpha_str, " - k21) / (", alpha_str, " - ", beta_str, ")")
  B_str = str_c("1 / V * (", beta_str, " - k21) / (", beta_str, " - ", alpha_str, ")")

  equation_during_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (", A_str, " / ", alpha_str, " * (1 - exp(-", alpha_str, " * t)) + ",
                                        B_str, " / ", beta_str, " * (1 - exp(-", beta_str, " * t)))" )

  equation_after_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (", A_str, " / ", alpha_str, " * (1 - exp(-", alpha_str, " * Tinf_RespPK)) * exp(-", alpha_str, " * (t - Tinf_RespPK)) + ",
                                       B_str, " / ", beta_str, " * (1 - exp(-", beta_str, " * Tinf_RespPK)) * exp(-", beta_str, " * (t - Tinf_RespPK)))")

  equation_during_infusion_clean = str_replace_all(equation_during_infusion_str, "\\s+", " ")
  equation_after_infusion_clean = str_replace_all(equation_after_infusion_str, "\\s+", " ")

  model_expression = list( duringInfusion = list("RespPK" = equation_during_infusion_clean), afterInfusion = list("RespPK" = equation_after_infusion_clean) )

  return( model_expression ) }

#' Model Linear2InfusionSingleDose_ClQV1V2
#' @name Linear2InfusionSingleDose_ClQV1V2
#' @export

Linear2InfusionSingleDose_ClQV1V2 = function(){

  beta_str = "0.5 * (Q / V1 + Q / V2 + Cl / V1 - sqrt((Q / V1 + Q / V2 + Cl / V1)^2 - 4 * (Q / V2 * Cl / V1)))"
  alpha_str = str_c("(", "Q / V2 * Cl / V1", " / ", "beta", ")")

  A_str = str_c("1 / V1 * (", alpha_str, " - Q / V2) / (", alpha_str, " - ", beta_str, ")")
  B_str = str_c("1 / V1 * (", beta_str, " - Q / V2) / (", beta_str, " - ", alpha_str, ")")

  equation_during_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (", A_str, " / alpha * (1 - exp(-alpha * t)) + ",
                                        B_str, " / beta * (1 - exp(-beta * t)))" )

  equation_after_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (", A_str, " / alpha * (1 - exp(-alpha * Tinf_RespPK)) * exp(-alpha * (t - Tinf_RespPK)) + ",
                                       B_str, " / beta * (1 - exp(-beta * Tinf_RespPK)) * exp(-beta * (t - Tinf_RespPK)))")

  equation_during_infusion_clean = str_replace_all(equation_during_infusion_str, "\\s+", " ")
  equation_after_infusion_clean = str_replace_all(equation_after_infusion_str, "\\s+", " ")

  model_expression = list( duringInfusion = list("RespPK" = equation_during_infusion_clean),afterInfusion = list("RespPK" = equation_after_infusion_clean))

  return( model_expression ) }

#' Model Linear2InfusionSteadyState_kk12k21Vtau
#' @name Linear2InfusionSteadyState_kk12k21Vtau
#' @export

Linear2InfusionSteadyState_kk12k21Vtau = function(){

  beta_str = "0.5 * (k12 + k21 + k - sqrt((k12 + k21 + k)^2 - 4 * k21 * k))"
  alpha_str = str_c("(", "k21 * k", " / ", "beta", ")")

  A_str = str_c("1 / V * (", alpha_str, " - k21) / (", alpha_str, " - ", beta_str, ")")
  B_str = str_c("1 / V * (", beta_str, " - k21) / (", beta_str, " - ", alpha_str, ")")

  equation_during_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (",
                                        A_str, " / alpha * (1 - exp(-alpha * t) + exp(-alpha * tau) * (1 - exp(-alpha * Tinf_RespPK)) * exp(-alpha * (t - Tinf_RespPK)) / (1 - exp(-alpha * tau))) + ",
                                        B_str, " / beta * (1 - exp(-beta * t) + exp(-beta * tau) * (1 - exp(-beta * Tinf_RespPK)) * exp(-beta * (t - Tinf_RespPK)) / (1 - exp(-beta * tau)))")

  equation_after_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (",
                                       A_str, " / alpha * (1 - exp(-alpha * Tinf_RespPK)) * exp(-alpha * (t - Tinf_RespPK)) / (1 - exp(-alpha * tau)) + ",
                                       B_str, " / beta * (1 - exp(-beta * Tinf_RespPK)) * exp(-beta * (t - Tinf_RespPK)) / (1 - exp(-beta * tau))")

  equation_during_infusion_clean = str_replace_all(equation_during_infusion_str, "\\s+", " ")
  equation_after_infusion_clean = str_replace_all(equation_after_infusion_str, "\\s+", " ")

  model_expression = list( duringInfusion = list("RespPK" = equation_during_infusion_clean), afterInfusion = list("RespPK" = equation_after_infusion_clean) )

  return( model_expression ) }

#' Model Linear2InfusionSteadyState_ClQV1V2tau
#' @name Linear2InfusionSteadyState_ClQV1V2tau
#' @export

Linear2InfusionSteadyState_ClQV1V2tau = function(){

  beta_str = "0.5 * (Q / V1 + Q / V2 + Cl / V1 - sqrt((Q / V1 + Q / V2 + Cl / V1)^2 - 4 * Q / V2 * Cl / V1))"
  alpha_str = str_c("(", "Q / V2 * Cl / V1", " / ", "beta", ")")

  A_str = str_c("1 / V1 * (", alpha_str, " - Q / V2) / (", alpha_str, " - ", beta_str, ")")
  B_str = str_c("1 / V1 * (", beta_str, " - Q / V2) / (", beta_str, " - ", alpha_str, ")")

  equation_during_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (",
                                        A_str, " / alpha * (1 - exp(-alpha * t) + exp(-alpha * tau) * (1 - exp(-alpha * Tinf_RespPK)) * exp(-alpha * (t - Tinf_RespPK)) / (1 - exp(-alpha * tau))) + ",
                                        B_str, " / beta * (1 - exp(-beta * t) + exp(-beta * tau) * (1 - exp(-beta * Tinf_RespPK)) * exp(-beta * (t - Tinf_RespPK)) / (1 - exp(-beta * tau)))" )

  equation_after_infusion_str = str_c( "dose_RespPK / Tinf_RespPK * (",
                                       A_str, " / alpha * (1 - exp(-alpha * Tinf_RespPK)) * exp(-alpha * (t - Tinf_RespPK)) / (1 - exp(-alpha * tau)) + ",
                                       B_str, " / beta * (1 - exp(-beta * Tinf_RespPK)) * exp(-beta * (t - Tinf_RespPK)) / (1 - exp(-beta * tau))" )

  equation_during_infusion_clean = str_replace_all(equation_during_infusion_str, "\\s+", " ")
  equation_after_infusion_clean = str_replace_all(equation_after_infusion_str, "\\s+", " ")

  model_expression = list( duringInfusion = list("RespPK" = equation_during_infusion_clean), afterInfusion = list("RespPK" = equation_after_infusion_clean))

  return( model_expression ) }

models = list(
  # Linear

  # 1. One compartment

  # 1.1 IV bolus

  # 1.1.1 Single dose
  "Linear1BolusSingleDose_kV" = list( "RespPK" = "dose_RespPK/V*(exp(-k*t))" ) ,
  "Linear1BolusSingleDose_ClV" = list( "RespPK" = "dose_RespPK/V * (exp(-Cl/V* t))" ),

  # 1.1.2 Steady state
  "Linear1BolusSteadyState_ClVtau" = list( "RespPK" = "dose_RespPK/V * ( exp(-Cl/V*t)/(1-exp(-Cl/V*tau)))" ),
  "Linear1BolusSteadyState_kVtau" = list("RespPK" = " dose_RespPK/V * ( exp( -k*t )/( 1-exp( -k*tau ) ) )"),

  # 1.2 Infusion

  # 1.2.1 Single dose
  "Linear1InfusionSingleDose_ClV" = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl * (1 - exp(-Cl/V * t ) )" ) ,
                                          afterInfusion  = list( "RespPK" = "dose_RespPK/Tinf_RespPK/Cl * (1 - exp(-Cl/V * Tinf_RespPK)) * (exp(-Cl/V * (t - Tinf_RespPK)))")),

  "Linear1InfusionSingleDose_kV" = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/(k*V) * (1 - exp(-k * t ) )" ) ,
                                         afterInfusion  = list( "RespPK" = "(dose_RespPK/Tinf_RespPK)/(k*V) * (1 - exp(-k * Tinf_RespPK)) * (exp(-k * (t - Tinf_RespPK)))") ),

  "Linear1InfusionSteadyState_kVtau" = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/(k*V) * ( (1 - exp(-k * t)) + exp(-k*tau) * ( (1 - exp(-k*Tinf_RespPK)) * exp(-k*(t-Tinf_RespPK)) / (1-exp(-k*tau) ) ) )" ) ,
                                             afterInfusion  = list( "RespPK" = "dose_RespPK/Tinf_RespPK/(k*V) * ( (1 - exp(-k*Tinf_RespPK ) ) * exp(-k*(t-Tinf_RespPK)) / (1-exp(-k*tau ) ) )") ),

  "Linear1InfusionSteadyState_ClVtau" = list( duringInfusion = list( "RespPK" = "dose_RespPK/Tinf_RespPK/((Cl/V)*V) * ( ( 1 - exp(-(Cl/V) * t)) + exp(-(Cl/V)*tau) * ( (1 - exp(-(Cl/V)*Tinf_RespPK)) * exp(-(Cl/V)*(t-Tinf_RespPK)) / (1-exp(-(Cl/V)*tau) ) ) )" ) ,
                                              afterInfusion  = list( "RespPK" = "dose_RespPK/Tinf_RespPK/((Cl/V)*V) * ( ( 1 - exp(-(Cl/V)*Tinf_RespPK ) ) * exp(-(Cl/V)*(t-Tinf_RespPK)) / (1-exp(-(Cl/V)*tau ) ) )" ) ),


  # 1.3 First order

  # 1.3.1 Single dose
  "Linear1FirstOrderSingleDose_kaClV" = list( "RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V * t) - exp(-ka * t))" ),

  "Linear1FirstOrderSingleDose_kakV" = list( "RespPK" = "dose_RespPK/V * ka/(ka - k) * (exp(-k * t) - exp(-ka * t))" ),

  # 1.3.2 Steady state
  "Linear1FirstOrderSteadyState_kaClVtau" = list("RespPK" = "dose_RespPK/V * ka/(ka - Cl/V) * (exp(-Cl/V * t)/(1-exp(-Cl/V * tau)) - exp(-ka * t)/(1-exp(-ka * tau)))"),
  "Linear1FirstOrderSteadyState_kakVtau" = list("RespPK" = "dose_RespPK/V * ka/(ka - k) * (exp(-k * t)/(1-exp(-k * tau)) - exp(-ka * t)/(1-exp(-ka * tau)))"),

  # 2. Two compartments

  # 2.1 Bolus

  # 2.1.1 Single dose

  # Linear2BolusSingleDose_ClQV1V2
  "Linear2BolusSingleDose_ClQV1V2" = list( "RespPK" = Linear2BolusSingleDose_ClQV1V2() ),

  # Linear2BolusSingleDose_kk12k21V
  "Linear2BolusSingleDose_kk12k21V" = list( "RespPK" = Linear2BolusSingleDose_kk12k21V() ),

  # 2.1.2 Steady state

  # Linear2BolusSteadyState_ClQV1V2tau
  "Linear2BolusSteadyState_ClQV1V2tau" = list( "RespPK" = Linear2BolusSteadyState_ClQV1V2tau() ),

  # Linear2BolusSteadyState_kk12k21Vtau
  "Linear2BolusSteadyState_kk12k21Vtau" = list( "RespPK" = Linear2BolusSteadyState_kk12k21Vtau() ),

  # 2.2 First order

  # 2.2.1 Single dose

  # Linear2First orderSingleDose_kaClQV1V2
  "Linear2FirstOrderSingleDose_kaClQV1V2" = list( "RespPK" = Linear2FirstOrderSingleDose_kaClQV1V2() ),

  # Linear2First orderSingleDose_kakk12k21V
  "Linear2FirstOrderSingleDose_kakk12k21V" = list( "RespPK" = Linear2FirstOrderSingleDose_kakk12k21V() ),

  # 2.2.2 Steady state

  # Linear2FirstOrderSteadyState_kaClQV1V2tau
  "Linear2FirstOrderSteadyState_kaClQV1V2tau" = list( "RespPK" = Linear2FirstOrderSteadyState_kaClQV1V2tau() ),

  # Linear2First orderSteadyState_kakk12k21V
  "Linear2FirstOrderSteadyState_kakk12k21Vtau" = list( "RespPK" = Linear2FirstOrderSteadyState_kakk12k21Vtau() ),

  # 2.3 Infusion

  # 2.3.1 Single dose

  # Linear2InfusionSingleDose_kk12k21V
  "Linear2InfusionSingleDose_kk12k21V"  = Linear2InfusionSingleDose_kk12k21V() ,

  # Linear2InfusionSingleDose_ClQV1V2
  "Linear2InfusionSingleDose_ClQV1V2" = Linear2InfusionSingleDose_ClQV1V2(),

  # 2.3.2 Steady state

  # Linear2InfusionSteadyState_kk12k21Vtau
  "Linear2InfusionSteadyState_kk12k21Vtau" = Linear2InfusionSteadyState_kk12k21Vtau(),

  # Linear2InfusionSteadyState_ClQV1V2tau
  "Linear2InfusionSteadyState_ClQV1V2tau" = Linear2InfusionSteadyState_ClQV1V2tau(),

  # Michaelis-Menten elimination

  # 1. One compartment

  # 1.1 IV bolus
  "MichaelisMenten1BolusSingleDose_VmKm" = list( "Deriv_C1" = "-Vm*C1/(Km+C1)" ),


  # 1.2 First order
  "MichaelisMenten1FirstOrderSingleDose_kaVmKmV" = list("Deriv_C1" = "-Vm*C1/(Km+C1) + dose_RespPK/V*ka*exp(-ka*t)"),

  # 1.3 Infusion
  "MichaelisMenten1InfusionSingleDose_VmKmk12k21V1V2" = list( duringInfusion = list( "Deriv_C1" = "(dose_RespPK/Tinf_RespPK)/Cl * (1 - exp(-Cl/V * t ) )",
                                                                                     "Deriv_C2" = "k12*V/V2*C1 - k21*C2"),

                                                              afterInfusion  = list( "Deriv_C1" = " -Vm*C1/(Km+C1)",
                                                                                     "Deriv_C2" = "k12*V/V2*C1 - k21*C2")),
  # 2. Two compartments

  # 2.1 IV bolus
  "MichaelisMenten2BolusSingleDose_VmKmk12k21V1V2" = list( "Deriv_C1" = "-Vm*C1/(Km+C1) - k12*C1+k21*V2/V*C2",
                                                           "Deriv_C2" = "k12*V/V2*C1 - k21*C2" ),

  # 2.2 First order
  "MichaelisMenten2FirstOrderSingleDose_kaVmKmk12k21V1V2" = list( "Deriv_C1" = "-Vm*C1/(Km+C1) - k12*C1 + k21*V2/V*C2 + dose_RespPK/V*ka*exp(-ka*t)",
                                                                  "Deriv_C2" = "k12*V/V2*C1 - k21*C2" ),

  # 2.3 Infusion
  "MichaelisMenten2InfusionSingleDose_VmKmk12k21V1V2" = list( duringInfusion = list( "Deriv_C1" = "-Vm*C1/(Km+C1) + dose_RespPK/V/Tinf_RespPK",
                                                                                     "Deriv_C2" = "k12*V/V2*C1 - k21*C2"),

                                                              afterInfusion  = list( "Deriv_C1" = "-Vm*C1/(Km+C1)",
                                                                                     "Deriv_C2" = "k12*V/V2*C1 - k21*C2") )
) #end list of model

LibraryOfPKModels = LibraryOfPKModels( models )








