library(shiny)

shinyUI(fluidPage(
  title = "stockVis",
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine. 
               Information will be collected from yahoo finance."),
      
      textInput("symb", "Symbol", "SPY"),
      
      dateRangeInput("dates", 
                     "Date range",
                     start = "2015-01-01", 
                     end = as.character(Sys.Date())),
      br(),
      br(),
      p("Since the random forest computation is slow you must use this button control"),
      br(),
      actionButton("go", label="Compute Random Forest")
    ),
    
    mainPanel(
      h1("Synopsis"),
      div("This application will use the controls at left to grab stock closing prices for a selected symbol over a choosen date range.  The application employs 3 machine learning models to the data in order to examine and compare the predictive performance of each model."),
      br(),
      div("The 3 models examined are: "), strong("a linear model, a support vector machine, and a random forest"),
      br(),
      h1("The symbol is"),
      textOutput("getSymbol"),
      br(),
      h2("The Linear Model"),
      div("This section will fit a linear model to the symbol data.  The root mean square error is shown and then a plot of the fitted line is displayed"),
      br(),
      p("Root mean square error for the linear model's fit to the symbol is"),
      textOutput("generalLinearModel"),
      p("...the plot of the symbol closing price vs. the linear model"),
      plotOutput("generalLinearModel_p"),
      br(),
      h2("The Support vector machine learning model"),br(),
      p("This section employs a support vector machine to fit the symbol closing price data. The root mean square error is shown and then a plot of the model fit"),br(),
      p("The root mean square error"),
      textOutput("SVM"),
      p("...now the plot of the fit"),
      plotOutput("SVM_p"),
      h2("The Random Forest machine learning model"),
      p("This section takes a look at how the random forest machine learning technique performs."), strong("you must press the button in the side panel to the left to see this computation!"),br(),
      p("First, the root mean square error of the fit is shown"),
      textOutput("RF"),
      p("... and the plot of the fit"),
      plotOutput("plotRF"),
      #
      h2("Conclusion"),br(),
      div("This section draws some conclusions for this experiement."),br(),
      div("The first observation is that utilizing a linear model to predict stock data is tricky.  Fitting the model over a large range of data, such as a year, is less than optimal.  However, while not shown, fitting a linear model to short span of data (such as a few days to a week) can use be a useful and fast way to form predictions."),br(),
      div("The next observation is that both support vector machines and random forest machine learning techniques provide improved prediction performance over longer data ranges, such as months to years.  This performance is costly in terms of time to compute the fit.  Employing a random forest machine learning technique was so costly that addtional shiny techniques were employed to increase page page load time.")
      )
    )
  )
)
