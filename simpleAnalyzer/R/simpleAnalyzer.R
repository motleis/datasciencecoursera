#' SimpleAnalyzer: A simple Shiny App
#'
#' This shiny app will take an input file containing response varialbe in the first column and predictor varialbe
#' in the second column. A simple histogram is shown for the predicator and a plot where you can select data points
#' to build a linear regression model.
#' @param File,  The input file in your file system. It should contain at least two columns where the first is the
#' response and the second is the predictor.
#' @param bins, The bins parameter can be controlled via a slider, and it will automatically change the number of
#' bins of the histogram.
#' @return , Void application
#' @author Mohamed Tleis
#' @details
#' @seealso \code{lm}
#' @export
#' @importFrom stats lm

simpleAnalyzer <- function(x,...) {
  shiny::runApp('R')
}

