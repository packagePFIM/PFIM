#' @title LibraryOfModels Class
#' @name LibraryOfModels
#' @description
#' The \code{LibraryOfModels} class is a centralized container designed to
#' store and manage Pharmacokinetic (PK) and Pharmacodynamic (PD) model
#' definitions.
#' @details
#' This class acts as a bridge between structural model definitions and the
#' \code{Evaluation} engine, ensuring that PK/PD associations are correctly mapped.
#' @param models A named list containing the PK and PD model strings or objects.
#' @template copyright
#' @export

LibraryOfModels = new_class("LibraryOfModels",
                            package = "PFIM",
                            properties = list(
                              models = new_property( class_list, default = list())))

