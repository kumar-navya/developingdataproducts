# Choose Model App
# Back end to execute models and prediction, then deliver appropriate plots


library(shiny)
library(caret)
library(rattle)
library(e1071)

# Define server logic required 
shinyServer(function(input, output) {
   
    data("iris")

    # fit the RPART model per chosen predictors    
    modelfit <- reactive({
        
        set.seed(321321)
        
        Xs = input$predictors
        
        train(data = iris[,c("Species", Xs)], Species ~., method = "rpart")
        
    })
    
    # generate predictions
    predictfit <- reactive({
        
        fit = modelfit()
        
        Xs = input$predictors
        
        predict(fit, newdata = iris[,c("Species", Xs)])
        
    })
    
    
   # plot the actuals and predictions and tree
   output$predplot <- renderPlot({
       
       fit = modelfit()
       prediction = predictfit()
        
       colors = c("#228B22", "#FFD700", "#1E90FF")
               
       # Actuals
       plot(x = iris$Petal.Width, y = iris$Petal.Length,
            pch = 20, cex = 2, col = colors[as.numeric(iris$Species)],
            xlab = "Petal Width", ylab = "Petal Length")
                       
       # Predictions
       points(x = iris$Petal.Width, y = iris$Petal.Length,
              cex = 3, col = colors[as.numeric(prediction)])
                       
       legend("topleft", pch=c(20, 1), pt.cex = 2, 
              legend=c("Actual", "Prediction"))
                       
       legend("bottomright", pch=20, pt.cex = 2, 
              col=colors,
              legend=c("setosa", "versicolor", "virginica"))
                       
       title(main = paste("PREDICTION ACCURACY = ",
                          round(max(fit$results[,"Accuracy"]), 2)
                          )
             )
                       
    })
   
   # Draw the RPART decision tree
   output$fittree <- renderPlot({
       
       fit = modelfit()
       
       fancyRpartPlot(fit$finalModel)
                       
    })
               
   
   output$chosenactual <- renderUI({
       
       irissubset = nearPoints(iris, input$chooseiris, 
                               xvar = "Petal.Width", 
                               yvar = "Petal.Length",
                               maxpoints = 1
                               )
       
       colors = c("#228B22", "#FFD700", "#1E90FF")
       chosencolor = colors[as.numeric(irissubset$Species)]
       
       em(style = paste("color:", chosencolor, sep=""), 
                        as.character(irissubset$Species))
       
   })
   
   output$chosenpred <- renderUI({
       
       prediction = predictfit()
       irissubset = nearPoints(iris, input$chooseiris, 
                               xvar = "Petal.Width", 
                               yvar = "Petal.Length",
                               maxpoints = 1,
                               allRows = TRUE
       )
       
       colors = c("#228B22", "#FFD700", "#1E90FF")
       chosencolor = colors[as.numeric(prediction[irissubset$selected])]
       
       em(style = paste("color:", chosencolor, sep=""),
       as.character(prediction[irissubset$selected]))
   })

})
