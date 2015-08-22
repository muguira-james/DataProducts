
library(quantmod)
library(caret)
library(e1071)
library(ggplot2)

# input == the symbol name, and the date range (from, to)
#
# by default this uses yahoo finance as the data source
#
# output is a xts data type
getMyData1 <- function(sym, f, t) {
  data <- getSymbols(sym, from = f, to = t, auto.assign=F)
  
  return(data)
}

# input == an xts data type
# output == data frame
transformData <- function(data) {
  # apple <- as.data.frame(Cl(data['2015']))\
  apple <- as.data.frame(Cl(data))
  indx <- 1:dim(apple)[1]
  r <- rownames(as.data.frame(apple))
  aapl <- cbind(indx, as.Date(r), apple)
  colnames(aapl) <- c("indx", "date", "close")
  
  return (aapl)
}

# input == data.frame
# output == a linear model data type
generalLinear <- function(aapl) {
  
  modelGLM <- glm(aapl$close ~ aapl$indx)
  return(modelGLM)
}

# input == data.frame
# output is a list/matrix/vector of numbers
supportVectorMachine <- function(data) {
  
  modelSVM <- svm(data$close ~ data$indx)
  predictedSVM <- predict(modelSVM, data)
  return (predictedSVM)
}

# input == data.frame
# output is a list/matrix/vector of numbers
randomForest <- function(data) {
  
  modelRF <- train(data$close ~ data$indx, data=data)
  predictedRF <- predict(modelRF, data)
  return(predictedRF)
}

# input == a number
# output == a number
rmse <- function(error)
{
  sqrt(mean(error^2))
}
# ------------------------------------------------------------------
shinyServer(function(input, output) {
  # this is a delayed poll of the input
  # the is smart in that it knows if the underlying data changed and only
  # resamples if there is a change
  dataInput <- reactive(
  {
    getMyData1(input$symb, input$dates[1], input$dates[2])
  })
  
  # only fired when the button is pressed
  randFor <- eventReactive(input$go,
    {
      z <- dataInput()
      data <- transformData(z)
      predictedY <- randomForest(data)
      return (predictedY)
    })
  
  output$getSymbol <- renderText(
    {
      input$symb
    })

  output$generalLinearModel <- renderText(
    {
      z <- dataInput()
      data <- transformData(z)
      model <- generalLinear(data)
      err <- model$residuals
      return (rmse(err))
    })
  
  output$generalLinearModel_p <- renderPlot(
    {
      z <- dataInput()
      data <- transformData(z)
      modelGLM <- glm(data$close ~ data$indx)
      predictedY <-predict(modelGLM, data)
      plot(data$date, data$close, type='l', main="Fit of a General Linear Model to closing price", xlab="Date", ylab="Closing Price")
      points(data$date, predictedY, col='blue', type='l')
    })
  output$SVM <- renderText(
    {
      z <- dataInput()
      data <- transformData(z)
      predictedY <- supportVectorMachine(data)
      err <- data$close - predictedY
      return(rmse(err))
    })
  output$SVM_p <- renderPlot(
    {
      z <- dataInput()
      data <- transformData(z)
      predictedSVM <- supportVectorMachine(data)
      plot(data$date, data$close, type='l', main="Fit of a SVM Model to closing price", xlab="Date", ylab="Closing Price")
      points(data$date, predictedSVM, col='red', type='l')
    })
  
  output$RF <- renderText(
  {
    predictedY <- randFor()
    err <- transformData(dataInput())$close - predictedY
    return(rmse(err))
  })

  output$plotRF <- renderPlot(
    {
      z <- dataInput()
      data <- transformData(z)
      plot(data$date, data$close, type='l', main="Fit of a Random Forest Model to closing price", xlab="Date", ylab="Closing Price")
      points(data$date, randFor(), col='green', type='l')
    })
})

