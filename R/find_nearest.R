
#' Load 2 sf objects, x and y
#'
#' Accepts two sf objects x and y and determines the nearest feature in y for
#' every feature in x.
#' @param x An sf object containing the features for which you want find the nearest features in y
#' @param y An sf object containing features to be assigned to x
#' @param y.name Characters prepended to the y features in the returned datatable
#' @return Returns a dataframe containing all rows from x with the corresponding nearest
#' feature from y. A column representing the distance between the features is
#' also included. Note that this object contains no geometry.
#' @import sf
#' @import units
#' @export

find_nearest <- function(x, y, y.name = "y") {

  # Determine CRSs
  message(paste0("x Coordinate reference system is ESPG: ", st_crs(x)$epsg))
  message(paste0("y Coordinate reference system is ESPG: ", st_crs(y)$epsg))

  # Transform y CRS to x CRS if required
  if (sf::st_crs(x) != sf::st_crs(y)) {
    message(paste0(
      "Transforming y coordinate reference system to ESPG: ",
      sf::st_crs(x)$epsg
    ))
    y <- sf::st_transform(y, sf::st_crs(x))
  }

  # Get rownumber of x
  x$rowguid <- seq.int(nrow(x))

  # Compute distance matrix
  dist.matrix <- sf::st_distance(x, y)

  # Select y features which are shortest distance
  nearest.rows <- apply(dist.matrix, 1, which.min)
  # Determine shortest distances
  nearest.distance <-
    dist.matrix[cbind(seq(nearest.rows), nearest.rows)]

  # Report distance units
  distance.units <- deparse_unit(nearest.distance)
  message(paste0("Distance unit is: ", distance.units))

  # Build data table of nearest features and add row index
  nearest.features <- y[nearest.rows,]
  nearest.features$distance <- nearest.distance
  nearest.features$x.rowguid <- x$rowguid
  nearest.features$index <- rownames(nearest.features)
  nearest.features$index <- sub("\\..*", "", nearest.features$index)

  # Remove geometries
  sf::st_geometry(x) <- NULL
  sf::st_geometry(nearest.features) <- NULL

  # Prepend names to y columns
  names(nearest.features) <- paste0(y.name, ".", names(nearest.features))

  # Bind datatables and return
  #output <- cbind(x, nearest.features)
  output <- nearest.features
  return(output)
}
