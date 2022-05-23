
library(sp)
library(sf)
library(tidyverse)
library(scales)

library(shiny)
library(leaflet)
library(shinythemes)


library(htmltools)
# _____________________________________


ui <- fluidPage(
  theme = shinythemes::shinytheme("yeti"),
  titlePanel(
    title = div(HTML("We Wrocławiu brakuje bezpiecznych i łatwo dostępnych miejsc do parkowania rowerów"))
  ),
  tabsetPanel(
    tabPanel(
      "Mapa", 
      
      div(class="outer",
          leaflet::leafletOutput(
            "myMap",
            width = "100%",
            height = "100%"
          ),
          absolutePanel(
            id = "controls", 
            class = "panel panel-default",
            fixed = TRUE,
            draggable = TRUE, 
            top = 140, 
            left = "auto", 
            right = 10, 
            bottom = "auto",
            width = 300, 
            height = "auto",
            selectInput(
              "PKT_SŁUPKI", 
              "Pokaż stojaki rowerowe",
              c("Tak", "Nie")
            ),
            actionButton(
              "show_o_danych", 
              "O danych"
            )
          ),
          tags$style(type = "text/css", 
                     "
                    .outer {position: fixed; top: 145px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}
                    #controls{background-color:white;padding:20px;opacity:0.8;
                    #title_panel{background-color:white;padding:20px;opacity:0.8;
                    "
          ),
          tags$div(id = "cite",
                   'Autor: WroData | Więcej na: ', tags$em('www.facebook.com/WroData'))
          
      )
    ),
    tabPanel(
      'Histogram', 
      plotly::plotlyOutput('histogram'),
      tags$div(id = "cite",
               'Autor: WroData | Więcej na: ', tags$em('www.facebook.com/WroData'))
    ),
    tabPanel(
      'Tabela danych',
      DT::DTOutput('tabela_danych'),
      tags$div(id = "cite",
               'Autor: WroData | Więcej na: ', tags$em('www.facebook.com/WroData'))
    )
  )
)