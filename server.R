library(RColorBrewer)

server <- function(input, output, session) {
  countries <- geojsonio::geojson_read("data/revenueByCountry.geojson", what = "sp")
  
  # Create a color palette for the map:
  revenueBins <- c(0,100000,200000,300000,500000,1000000,Inf)
  revenueMapPalette <- colorBin( palette="Greens", domain=countries@data$Revenue, na.color="transparent", bins=revenueBins)
  
  # Prepare the text for tooltips:
  mytext <- paste(
    "Country: ", countries@data$ADMIN,"<br/>", 
    "Revenue: ", countries@data$Revenue, "<br/>", 
    sep="") %>%
    lapply(htmltools::HTML)
  
  output$revenueByCountryMap <- renderLeaflet({
    leaflet(countries) %>% 
      addTiles()  %>% 
      setView( lat=10, lng=0 , zoom=2) %>%
      addPolygons( 
        fillColor = ~revenueMapPalette(Revenue),
        stroke=FALSE, 
        label = mytext,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"), 
          textsize = "13px", 
          direction = "auto"
        )
      ) %>%
      addLegend( pal=revenueMapPalette, values=~Revenue, opacity=0.9, title = "Revenue", position = "bottomleft" )
    
  })
}