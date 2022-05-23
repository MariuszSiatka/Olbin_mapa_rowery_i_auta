
library(sp)
library(sf)
library(tidyverse)
library(scales)

library(shiny)
library(leaflet)
library(shinythemes)


library(htmltools)
# _____________________________________

load('DANE.RData')

#### server ####
# calculations
server <- function(input, output, session) {
  
  pal <- colorNumeric(
    palette = # rampcols, # "Blues", #"BrBG",
      c("#b35806", "#e08214", "#fdb863", "#fee0b6", "#f7f7f7",  "#f7f7f7", "#d8daeb", "#d8daeb", "#b2abd2", "#8073ac",  "#8073ac", "#542788", "#542788"),
    #c("#C0D5F2", "#3ba233", "#F99D4A"), #"heat",
    domain = dane$PRC_Auta,
    reverse = T
  )
  
  
  
  observeEvent(input$show_o_danych, {
    showModal(
      modalDialog(
        div(HTML(text_O_Danych)), 
        title = 'O danych'
      )
    )
  })
  observeEvent(input$show_wnioski_i_rekomendacje, {
    showModal(
      modalDialog(
        div(HTML(text_wnioski_i_rekomendacje)), 
        title = 'Wnioski i rekomendajce'
      )
    )
  })
  
  
  
  output$myMap <- renderLeaflet({
    
    leaflet(dane) %>%
      addTiles(
        # urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        # attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 17.06, lat = 51.124, zoom = 15)  %>%
      addPolylines(color = ~pal(PRC_Auta), 
                   label = ~html_text, 
                   labelOptions = labelOptions(noHide = F, direction = "top", textsize = "15px"),
                   weight  = 7, opacity = 0.9,
                   highlightOptions = highlightOptions(weight = 15, bringToFront = TRUE, opacity = 1)) %>%
      addLegend(pal = pal, 
                values = ~ PRC_Auta, 
                position = "bottomleft", 
                title = "Procent samochodów", 
                labFormat = labelFormat(prefix = "", 
                                        suffix = "%", 
                                        between = "",
                                        transform = function(x) 100 * x
                )
      ) 
  })
  
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  pointsInBounds <- reactive({
    df_Słupki
  })
  
  
  
  observe({
    
    
    if(input$PKT_SŁUPKI == "Tak") {
      
      leafletProxy("myMap", data = pointsInBounds()) %>%
        clearMarkers() %>%
        addMarkers(
          icon = ico,
          lng = ~long,
          lat = ~lat) 
      #addCircleMarkers(~long, ~lat, 
      #                 #layerId = ~ID_Słupka, 
      #                 #radius = 5,
      #                 stroke = TRUE, color = "red", weight = 1, fillOpacity = 1,
      #                 popup = ~ TEXT, 
      #                 radius = ~ Miejasa_na)
    } else {
      
      leafletProxy("myMap") %>%
        clearMarkers()
    }
  })
  
  
  # _______
  #### wykres ####
  
  output$histogram <- plotly::renderPlotly({
    histogram
  })
  
  
  output$tabela_danych <- DT::renderDT({
    Interatywna_tabela
  })
  
  
  
}

