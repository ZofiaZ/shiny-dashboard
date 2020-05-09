getPercentChangeSpan <- function(changeValue) {
  if (is.na(changeValue)) {
    return("<span class='no-data'>NA*</span>")
  }

  changeValue <- round(changeValue, digits = 2)

  if (changeValue > 0) {
    CSSclass <- "positive-change"
    sign <- "+"
  } else if (changeValue < 0) {
    CSSclass <- "negative-change"
    sign <- ""
  } else {
    CSSclass <- "zero-change"
    sign <- ""
  }

  glue("<span class='{CSSclass}'> {sign}{changeValue}%</span>")
}