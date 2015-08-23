# DataProducts
Coursera data products project

This directory contains my shiny work and shiny.io work.

The files: ui.R and server.R form a shiny webapp that compares the fit for 3 different machine learning algorithms:
1.  simple linear model
2.  Support Vector Machine
3.  Random Forest

To use the webapp either load the ui.R & server.R files on your system or try the shinyio version (though the final output for randomforest does not seem to display).  The user interface for the app asks for a symbol name (e.g. goog or aapl) and a date range.  After a moment the app will display the root mean square error for the fit and a plot of the symbol closing price + the algorithm fit.

The URL for the shinyio is { https://muguira-james.shinyapps.io/DataProducts }
I did a simple pitch for this app on rpubs.  It only uses one symbol (AAPL), but it shows all the fitted algorithms.  That URL is: { http://rpubs.com/muguira_james/103160 }
