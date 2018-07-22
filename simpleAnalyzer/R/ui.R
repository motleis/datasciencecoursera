library(shiny)

# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Charts"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(type="tabs",

                  # The slider tab
                  tabPanel("Slider", br(),

                           sliderInput("bins",
                                       "Number of bins:",
                                       min = 1,
                                       max = 50,
                                       value = 30),
                           br(),
                           "Control the number of bins in the box-plot",
                           br(),
                           "Open the Histogram tab to see effect"
                  ),

                  # The Input Tab
                  tabPanel("Input", br(),

                           fileInput("File", "Choose CSV File",
                                     accept = c(
                                       "text/csv",
                                       "text/comma-separated-values,text/plain",
                                       ".csv")
                           ),
                           tags$hr(),
                           checkboxInput("header", "Header", TRUE)
                            ),

                  #
                  tabPanel("Stats", br(),
                           h3("Slope"),
                           textOutput("slopeOut"),
                           h3("Intercept"),
                           textOutput("intOut"),
                           h3("Response Stats:"),
                           uiOutput("responseStats"),
                           h3("Predictor Stats:"),
                           uiOutput("predictorStats")
                  )
      )),


    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Histogram", br(), plotOutput("distPlot", brush=brushOpts(id="brush1"))),
                  tabPanel("lm-Plot", br(), plotOutput("lmPlot", brush=brushOpts(id="brush1"))),
                  tabPanel("Data", br(), uiOutput("text")),
                  tabPanel("Help", br(), uiOutput("help")),
                  tabPanel("About", br(), textOutput("about")))
    )
  )
))
