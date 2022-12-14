% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_nearest.R
\name{find_nearest}
\alias{find_nearest}
\title{Load 2 sf objects, x and y}
\usage{
find_nearest(x, y, y.name = "y")
}
\arguments{
\item{x}{An sf object containing the features for which you want find the nearest features in y}

\item{y}{An sf object containing features to be assigned to x}

\item{y.name}{Characters prepended to the y features in the returned datatable}
}
\value{
Returns a dataframe containing all rows from x with the corresponding nearest
feature from y. A column representing the distance between the features is
also included. Note that this object contains no geometry.
}
\description{
Accepts two sf objects x and y and determines the nearest feature in y for
every feature in x.
}
