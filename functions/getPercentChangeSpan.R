getPercentChangeSpan <- function(changeValue) {
  if (is.na(changeValue)) {
    return("<span class='change-value no-data'>NA*</span>")
  }

  changeValue <- round(changeValue, digits = 2)

  if (changeValue > 0) {
    CSSclass <- "change-value positive-change"
    sign <- "+"
  } else if (changeValue < 0) {
    CSSclass <- "change-value negative-change"
    sign <- ""
  } else {
    CSSclass <- " change-value zero-change"
    sign <- ""
  }

  glue("<span class='{CSSclass}'> {sign}{changeValue}%</span>")
}