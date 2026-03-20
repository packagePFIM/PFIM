# ==============================================================================
#' @title getListLastName: Get names of the deepest elements in a nested list
#' @name getListLastName
#' @description
#' Recursively traverses a nested list to extract the names of the elements
#' at the lowest level of the hierarchy.
#' @param list A \code{list} (potentially nested).
#' @return A \code{character} vector containing the names of the last elements.
#' @template copyright
#' @export
# ==============================================================================

getListLastName = function(list) {
  # Security: if it's not a list, we stop recursion
  if (!is.list(list)) {
    return(NULL)
  }
  # Recursive mapping
  result = purrr::map(list, getListLastName)
  # Flatten one level
  flat_result = unlist(result, recursive = FALSE, use.names = TRUE)
  if (is.null(flat_result) || length(flat_result) == 0) {
    # We reached the "leaf" of the tree, return the names of current level
    return(names(list))
  } else {
    return(flat_result)
  }
}
