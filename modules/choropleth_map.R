library(RColorBrewer)
library(leaflet)

choroplethMapOutput <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("choroplethCountryMap"))
}

choroplethMap <-
  function(input, output, session, metric = "revenue") {
    countries <-
      geojsonio::geojson_read("data/countries.geojson", what = "sp")
    
    # Create a color palette for the map:
    mapPalette <-
      colorBin(
        palette = colorRampPalette(c("#e0e2e4", "#f8d84d"))(4),
        domain = countries@data[[metric]],
        4,
        na.color = "transparent",
        pretty = FALSE
      )
    
    # Prepare the text for tooltips:
    tooltip <- paste(
      "Country: ",
      countries@data$ADMIN,
      "<br/>",
      metric,
      ": ",
      countries@data[[metric]],
      "<br/>",
      sep = ""
    ) %>%
      lapply(htmltools::HTML)
    
    output$choroplethCountryMap <- renderLeaflet({
      leaflet(countries) %>%
        addTiles()  %>%
        setView(lat = 10,
                lng = 0 ,
                zoom = 2) %>%
        leaflet::addPolygons(
          fillColor = ~ mapPalette(countries@data[[metric]]),
          stroke = FALSE,
          fillOpacity = 0.9,
          label = tooltip,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "13px",
            direction = "auto"
          )
        ) %>%
        leaflet::addLegend(
          pal = mapPalette,
          values =  ~ countries@data[[metric]],
          opacity = 0.9,
          title = metric,
          position = "bottomleft"
        )
    })
  }