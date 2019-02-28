#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
chord_expand <- function(
  message,
  # width = NULL, height = NULL,
  elementId = NULL,
  year = NULL,
  threshold = 10000,
  labelThreshold = 5000,
  animationDuration = 500,
  maxRegionsOpen = 2,
  margin = 25,
  arcPadding = 0.04,
  infoPopupDelay = 300,
  arcWidth = 24,
  width = 800,
  height = 800,
  labelPadding = 10,
  sourcePadding = 3,
  targetPadding = 20,
  curveFactor = 0.4) {

  # forward options using x
  x = list ( data = message,
             year = year,
             height = height,
             width = width ,
             arcWidth = arcWidth,
             threshold = threshold,
             animationDuration = animationDuration,
             labelThreshold = labelThreshold,
             maxRegionsOpen = maxRegionsOpen,
             margin = margin,
             infoPopupDelay = infoPopupDelay,
             curveFactor = curveFactor,
             labelPadding = labelPadding,
             sourcePadding = sourcePadding,
             targetPadding = targetPadding,
             arcPadding = arcPadding)

  # create widget
  htmlwidgets::createWidget(
    name = 'chord_expand',
    x,
    width = width,
    height = height,
    package = 'migviz',
    elementId = elementId
  )
}

#' Shiny bindings for chord_expand
#'
#' Output and render functions for using chord_expand within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a chord_expand
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name chord_expand-shiny
#'
#' @export
chord_expandOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'chord_expand', width, height, package = 'migviz')
}

#' @rdname chord_expand-shiny
#' @export
renderchord_expand <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, chord_expandOutput, env, quoted = TRUE)
}
