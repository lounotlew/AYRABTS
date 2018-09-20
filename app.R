# ==============================================================
# All Your Restaurant Are Belong to Us
# Simply write Yelp API business search, lookup, and review
# data to a .csv file.

# Written by Woo Sik (Lewis) Kim,
# with other online sources (check specific files for authors.)
# ==============================================================
# Requiring the necessary packages (may not require all):
library(shiny)
require(tidyverse)
require(httr)
require(dplyr)
require(assertive.types)

# Sourcing necessary files from utils:
source('utils/business_search.R')
source('utils/business_lookup.R')
source('utils/reviews.R')
source('utils/functions.R')

ui <- shinyUI(fluidPage(
  
  titlePanel(title = h3("All Your Restaurant Are Belong to Us - Interactive Yelp Data Downloader", align="left")),
  
  # Inputs for business search tab (tab 1).
  sidebarPanel(
    conditionalPanel(condition = 'input.tabselected==1', h4("Business Search (Max. 50 by Yelp API default; use offset)"),
                     
                     textInput("term", label="Search Term (e.g. 'Mexican', 'Sushi', 'Starbucks'; leave blank to search everything)", 
                               value = "Taco Bell"),
                     
                     checkboxGroupInput("price", label = "Filter by Price: (Blank defaults to all price ranges)", choices = c('$', '$$', '$$$', '$$$$'),
                                       selected = c('$', '$$', '$$$', '$$$$')),
                     
                     sliderInput("slider", label = "Filter by Rating:", min = 0, 
                                 max = 5, step = 0.5, value = c(0, 5)),
                     
                     numericInput("rvcount", label = "Filter by Review Count (Min. # of Reviews):",
                                  value = 0, min = 0),
    
                     textInput("location", label = "Desired Location (Address, Neighborhood, City/State or Zip; cannot be empty):",
                               value = "Berkeley, CA", placeholder = "Location"),
    
                     numericInput("radius", label = "Search Radius (in Meters; 0 to 40000):",
                                  value = 16000, min = 0, max = 40000),
                     
                     numericInput("offset", label = "Offset: Return Search Results from N - N+50 (e.g. 51-100 for offset=50):",
                                  value = 0, min = 0),
    
                     textInput("csv_filepath1", label=".csv filepath (default: output/search/yelpsearchdata.csv)",
                               value = "output/search/yelpsearchdata.csv"),
                     
                     downloadButton("writecsv1", label = "Download Data Frame as .csv")
                     ),
    
    # Inputs for business lookup tab (tab 2).
    conditionalPanel(condition = 'input.tabselected==2', h4("Business Lookup"),
                     
                     textInput("lid", label = "Business ID (Use Business Search to get specific ID):",
                               value = "taco-bell-berkeley-2"),
                     
                     textInput("csv_filepath2", label=".csv filepath (default: output/lookup/yelplookupdata.csv)",
                               value = "output/lookup/yelplookupdata.csv"),
                     
                     downloadButton("writecsv2", label = "Download Data Frame as .csv")
                     ),
    
    # Inputs for business hours tab (tab 3).
    conditionalPanel(condition = 'input.tabselected==3', h4("Business Hours"),
                     
                     textInput("bid", label = "Business ID (Use Business Search to get specific ID):",
                               value = "taco-bell-berkeley-2"),
                     
                     textInput("csv_filepath3", label=".csv filepath (default: output/hours/hoursdata.csv)",
                               value = "output/hours/hoursdata.csv"),
                     
                     downloadButton("writecsv3", label = "Download Data Frame as .csv")
                     
                     ),
    
    # Inputs for business reviews tab (tab 4).
    conditionalPanel(condition = 'input.tabselected==4', h4("Business Reviews (Max. 3 by Yelp API Default)"),
                     
                     textInput("rid", label = "Business ID (Use Business Search to get specific ID):",
                               value = "taco-bell-berkeley-2"),
                     
                     textInput("csv_filepath4", label=".csv filepath (default: output/reviews/reviewdata.csv)",
                               value = "output/reviews/reviewdata.csv"),
                     
                     downloadButton("writecsv4", label = "Download Data Frame as .csv"),
                     
                     textInput("txt_filepath", label=".txt filepath (default: output/reviews/reviews.txt)",
                               value = "output/reviews/reviews.txt"),
                     
                     downloadButton("writetxt", label = "Download Reviews as .txt")
                     ),
    
    # Inputs for app. notes tab (tab 5).
    conditionalPanel(condition = 'input.tabselected==5', h4("Notes"))
    
  ),
  
  # Creating the 5 tabs.
  mainPanel(
    tabsetPanel(type="tab", id = "tabselected",
                tabPanel("Business Search", value=1, tableOutput("search")),
    
                tabPanel("Business Lookup", value=2, tableOutput("lookup")),
                
                tabPanel("Business Hours", value=3, tableOutput("bhours")),
                
                tabPanel("Business Reviews", value=4, tableOutput("reviews")),
                
                tabPanel("Notes", value=5, htmlOutput("notes")))
  )
))

server <- function(input, output) {
  
  # Returns Yelp Business Search data (a data frame). See business_search.R.
  searchdata <- reactive({
    filter(yelp_business_search(term = input$term, 
                         location = input$location,
                         offset = input$offset,
                         radius = input$radius,
                         price = priceString(input$price),
                         client_id = client_id,
                         api_key = api_key),
           rating >= input$slider[1] & rating <= input$slider[2] 
           & review_count >= input$rvcount)
  })
  
  # Returns Yelp Business Lookup data (a data frame; 1 row.). See business_lookup.R.
  lookupdata <- reactive({
    yelp_business_lookup(business_id = input$lid)
  })
  
  # Returns a business's hours from Yelp Business Lookup (a data frame; 1 row).
  # See business_lookup.R.
  hoursdata <- reactive({
    business_hours(business_id = input$bid)
  })
  
  # Returns Yelp Business Reviews data (a data frame; max. 3 reviews by default).
  # See reviews.R.
  reviewdata <- reactive({
    business_reviews(business_id = input$rid)
  })
  
  # Displays business search data in a table in tab 1.
  output$search <- renderTable({
    searchdata()
  })
  
  # Displays business lookup data in a table in tab 2.
  output$lookup <- renderTable({
    lookupdata()
  })  
  
  # Displays business hours data in a table in tab 3.
  output$bhours <- renderTable({
    hoursdata()
  })
  
  # Displays business reviews data in a table in tab 4.
  output$reviews <- renderTable({
    reviewdata()
  })
  
  # Displays bugs, app. info, instructions, etc. in text format in tab 5.
  output$notes <- renderUI({
    HTML(paste(offsetNotEmpty, needsWork1, explainHours, sep="<br/>"))
  })
  
  # Downloads business search data into a .csv file.
  output$writecsv1 <- downloadHandler(
    filename = "business_search.csv",
    
    content = function(file) {
      write.csv(searchdata(), file)
    }
  )

  # Downloads business lookup data into a .csv file.
  output$writecsv2 <- downloadHandler(
    filename = "business_lookup.csv",
    
    content = function(file) {
      write.csv(lookupdata(), file)
    }
  )
  
  # Downloads business hours data into a .csv file.
  output$writecsv3 <- downloadHandler(
    filename = "business_hours.csv",
    
    content = function(file) {
      write.csv(hoursdata(), file)
    }
  )
  
  # Downloads business reviews data into a .csv file.
  output$writecsv4 <- downloadHandler(
    filename = "business_reviews.csv",
    
    content = function(file) {
      write.csv(reviewdata(), file)
    }
  )
  
  # Writes the reviews column (in business reviews data) into a .txt file following given filepath.
  # Note: Needs improvement/rewrite for better text formatting in .txt file.
  output$writetxt <- downloadHandler(
    filename = "business_reviews.txt",
    
    content = function(file) {
      write.csv(reviewdata()$text, file)
    }
  )
}

# Run the application.
shinyApp(ui = ui, server = server)
