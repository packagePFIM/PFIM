
# =============================================================================
# PFIM version 7.0
# =============================================================================
# This script launch all the examples for design evaluation and optimization
# Define the path where you have copy and paste the folder Evaluation_tests and
# Design_optimisation and Run.
# =============================================================================

# define your main path
mainPath = "C:/...."
mainPathEvaluation = paste0( mainPath, "Evaluation_tests/" )
mainPathOptimization = paste0( mainPath, "Design_optimisation/" )

# =============================================================================
# Design evaluation of model defined from the library of models
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
# Design evaluation of user defined model
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
# Design optimization (continuous)
# PSO: Particle Swarm Optimization
# PGBO: Population Genetic Based Optimization
# Simplex: simplex algorithm
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
# Design optimization (discrete)
# FedorovWynnAlgorithm: FedorovWynn algorithm
# MultiplicativeAlgorithm: multiplicative algorithm
# =============================================================================

racine = paste0(mainPathOptimization,"discrete/")
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



