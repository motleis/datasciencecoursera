#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

 model <- reactive({
    # brushed_data <- brushedPoints(trees, input$brush1, xvar="Girth", yvar="Volume")
   inputData <- NULL
   inFile <- input$File
   if (is.null(inFile)) {
     data(trees)
     inputData <- data.frame(trees$Volume, trees$Girth)
   }
   else {
     # inputData <- read.csv(input$File)
     inputData <- read.csv(inFile$datapath, header=input$header)
   }
    response = inputData[,1]
    predictor = inputData[,2]
    df <- data.frame(response = inputData[,1], predictor=inputData[,2])
    brushed_data <- brushedPoints(df, input$brush1, xvar="predictor", yvar="response")
    if(nrow(brushed_data) < 2) { return(NULL)
    }
    # lm(Volume~Girth, data=brushed_data)
    lm(response~predictor, data=brushed_data)
  })

  # didn't get it to work
  observeEvent(input$showTab, {
    showTab(inputId = "tabs", target = "Data")
  })

  output$slopeOut <- renderText({if(is.null(model())){"No Model Found!"
  } else {
    model()[[1]][2]
  }
  })

  output$intOut <- renderText({
    if(is.null(model())){
      "No Model Found!"
    } else {
      model()[[1]][1]
    }

  })

output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    inFile <- input$File
    inputData <- NULL
    if (is.null(inFile)) {
      data(trees)
      inputData <- data.frame(trees$Volume, trees$Girth)
    }
    else {
      # inputData <- read.csv(input$File)
      inputData <- read.csv(inFile$datapath, header=input$header)
    }
    x    <- inputData[,1]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white', main="Response Feature")
  })

  # output$text <- renderText({input$File})
  output$text <- renderUI({
    text <- "File Content : "
    text2 <- ""
    text3 <- ""
    inFile <- input$File
    if(is.null(inFile))
      text <- paste0(text, "File not found")
    else {
      inputData<-read.csv(inFile$datapath, header = input$header)
      # inputData <- read.csv(input$File)
      text2 <- paste0(text2, "Response Values: ")
      response <- inputData[,1]
      text2 <- paste0(text2, list(response))

      text3 <- paste0(text3, "Predictor Column:")
      feature <- inputData[,2]
      text3<-paste0(text3, list(feature))
    }
    HTML(paste(text, text2, text3, sep = '<br/>'))
  })

  output$lmPlot <- renderPlot({
    inFile <- input$File
    inputData <- NULL
    # plot(trees$Girth, trees$Volume, xlab="Girth", ylab="Volume", main="WOW!", cex=1.5, pch=16, bty="n")
     if (is.null(inFile)) {
       data(trees)
       inputData <- data.frame(trees$Volume, trees$Girth)
     }
    else {
      inputData <- read.csv(inFile$datapath, header=input$header)
    }

    plot(inputData[,2], inputData[,1], xlab="Main Predictor", ylab="Response", main="Predictor", cex=1.5, pch=16, bty="n")

    if(!is.null(model())) {
      abline(model(), col="red", lwd=2)
    }
  })


  output$predictorStats <- renderUI({
    inFile<-input$File
    if (is.null(inFile)) {
      data(trees)
      inputData <- data.frame(trees$Volume, trees$Girth)
    }
    else {
      inputData <- read.csv(inFile$datapath, header=input$header)
    }


    str1 <- paste0("Mean: " , format(round((mean(inputData[,2])),2)), nsmall=2)
    str2 <- paste0("Std: ", format(round(sd(inputData[,2]),2)), nsmall=2)
    HTML(paste(str1, str2, sep = '<br/>'))
  })

  output$responseStats <- renderUI({
    inFile<-input$File
    if (is.null(inFile)) {
      data(trees)
      inputData <- data.frame(trees$Volume, trees$Girth)
    }
    else {
      inputData <- read.csv(inFile$datapath, header=input$header)
    }

    str1 <- paste0("Mean: ", format(round(mean(inputData[,1], 2)),nsmall=2))
    str2 <- paste0("Std: " , format(round(sd(inputData[,1]),2)), nsmall=2)
    HTML(paste(str1, str2, sep = '<br/>'))
  })

  output$help <- renderUI({
    str1 <- paste("<h3>App Usage:</h3>")
    str2 <- "The idea of this app is to load a csv file containing two columns, a response and a predictor,
    The response is the first column in the csv file, and the predictor is the 2nd column.
    On the side panel, you can set the path of your csv file, set the number of bins for a histogram of the predictor,
    and view summary information regarding your dataset."
    str3 <- "The main panel contains five tabs. The first 'Histogram' shows a histogram for the predictor column.
    The second tab 'lm-plot' creates a linear model given the response and the predictor columns.
    Third tab 'data' shows the actual data in the input file. 'Help' tab contains this manual and the last tab
    'About' contain info about the developer of the app with version information"
    HTML(paste(str1, str2, str3, sep = '<br/>'))
  })

  output$about <- renderText({
    "Simple analyzer v.1.0, A shiny app developed by Mohamed Tleis as final project of Coursera Data Products Course"
  })

})
