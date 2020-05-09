library(RColorBrewer)
library(leaflet)

choroplethMapOutput <- function(id) {
  ns <- NS(id)

  # select only those metrics that are available per country:
  map_metrics <- c("revenue", "orders_count", "users_active", "users_dropped_out", "complaints_opened", "complaints_closed")
  choices <- list("Select" = "") %>% c(getMetricsChoices(map_metrics, metrics_list))

  tagList(
    tags$div(
      class = "tile-header",
      tagList(
        selectInput(
          ns("metric"), "Select metric for the choropleth map",
          choices,
          width = NULL,
          selectize = FALSE
        ),
        tags$span("by country")
      )
    ),
    leafletOutput(ns("choroplethCountryMap"))
  )
}

getCountriesDataByDate <- function(df, y, m, metric, f = sum) {
  getSubsetByTimeRange(df, y, m, metric = c("country", metric)) %>%
    group_by(country) %>%
    summarize_at(.vars = c(metric), .funs = f)
}

choroplethMap <-
  function(input,
           output,
           session,
           countries_geo_data,
           df,
           y,
           m) {
    metric <- reactive({
      validate(need(input$metric != "", "select metric"))
      metrics_list[[input$metric]]
    })

    countries_df <- reactive({
      getCountriesDataByDate(df, y(), m(), metric()$id, sum)
    })


    output$choroplethCountryMap <- renderLeaflet({
      map_palette <-
        colorQuantile( # TODO change to more represenative palletter
          palette = colorRampPalette(c("#f8d84d", "#bdd64b"))(6),
          domain = countries_df()[[metric()$id]],
          6,
          na.color = "transparent"
        )

      metric_prefix <- ifelse(!is.null(metric()$currency), metric()$currency, "")
      tooltip <- glue(
        "<h4>{countries_df()$country}</h4>
        <span class='metric-name'>{metric()$legend}: </span>
        <span class='metric-value'>{metric_prefix}{countries_df()[[metric()$id]]}<span class='metric-name'>"
      ) %>% lapply(HTML)

      leaflet() %>%
        addTiles() %>%
        addProviderTiles(providers$CartoDB.VoyagerNoLabels) %>%
        setView(
          lat = 10,
          lng = 0,
          zoom = 2
        ) %>%
        leaflet::addPolygons(
          data = countries_geo_data,
          fillColor = ~ map_palette(countries_df()[[metric()$id]]),
          stroke = FALSE,
          fillOpacity = 0.9,
          label = tooltip,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "13px",
            direction = "auto"
            # TODO move to scss
          )
        )
    })
  }