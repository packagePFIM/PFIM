
library(PFIM)

# =============================================================================
# Tests PFIM
# =============================================================================

mainPath = "C:/....."
mainPathEvaluation = paste0( mainPath, "Evaluation_tests/" )
mainPathOptimization = paste0( mainPath, "Optimisation_tests/" )

# =============================================================================
# Tests: Evaluation & library of models
# =============================================================================

racine = paste0(mainPathEvaluation,"library_of_models/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts) {

  cat("=== Exécution de :", script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}

# =============================================================================
# Tests: Evaluation & user defined model
# =============================================================================

racine = paste0(mainPathEvaluation,"user_defined_model/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts ) {

  cat("=== Exécution de :",  script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}

# =============================================================================
# Tests: Evaluation & features
# =============================================================================

racine = paste0(mainPathEvaluation,"features/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts) {

  cat("=== Exécution de :", script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}

# =============================================================================
# Tests: Optimization continuous
# =============================================================================

racine = paste0(mainPathOptimization,"continuous/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts[4]) {

  cat("=== Exécution de :", script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}

# =============================================================================
# Tests: Optimization discrete
# =============================================================================

## MultiplicativeAlgorithm
racine = paste0(mainPathOptimization,"discrete/MultiplicativeAlgorithm/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts ) {

  cat("=== Exécution de :", script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}

## FedorovWynn
racine = paste0(mainPathOptimization,"discrete/FedorovWynn/")
scripts = list.files(path = racine, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

for (script in scripts[2] ) {

  cat("=== Exécution de :", script, "===\n")

  old_wd = getwd()

  tryCatch({
    setwd(dirname(script))
    cat("Répertoire de travail :", getwd(), "\n")

    source(basename(script), echo = TRUE)
    cat(":-) Succès\n\n")

  }, error = function(e) {
    cat(":/ Erreur :\n", conditionMessage(e), "\n\n")
    stop()
  }, finally = {
    setwd(old_wd)
  })
}


