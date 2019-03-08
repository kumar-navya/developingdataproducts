# Choose Model App
# Front end to help user choose the predictors they want to include
# into a decision tree model for predicting Iris Species

library(shiny)

# Define UI for application 
shinyUI(fluidPage(
 
  titlePanel(title = "Predicting Iris Species with RPART Decision Tree",
             windowTitle = "Prediction with RPART"
             ),
  
  # Sidebar for user to input the predictors to include in the model 
  sidebarLayout(
    sidebarPanel(
        
        # choose predictors
        radioButtons("predictors",
                           "Choose predictors to include in RPART model", 
                           choices=c("Sepal.Length","Sepal.Width",
                                     "Petal.Length","Petal.Width"
                                     ), 
                           selected = "Sepal.Length"
                           )
        
        ),
    
    
    mainPanel(
        
        # Instroducing the app
        
        h4("Introduction"),
        p("The iris dataset in R contains 150 samples of three species of iris flowers (setosa, virginica, and versicolor) and four features of each sample (sepal length, sepal width, petal length, and petal width)."),
        
        p(strong("Our app uses RPART decision tree to classify each flower into one of the three species, based on one of the four features.")),
        
        h5("Please read the instructions and other details in the Instructions tab."),
        tabsetPanel(
            
            # Instructions for use
            
            tabPanel("Instructions", 
                     
                     p(br(), br(),strong("Sidepanel: "), "User can click the radio buttons to choose a flower feature on which to build the RPART model."),
                     p(br(), strong("Tab - Prediction: "),"Displays a scatterplot with the actual and predicted value of iris species, as well as the prediction accuracy.", br(), "There is also a fun mouse-hover feature!"),
                     p(br(), strong("Tab - Tree: "),"Displays the decision tree generated to perform the classification."),
                     p(br(), br(), br(), "Plots and charts can take a few seconds to generated and load. Please be patient.", align = "center")
                     
                     ),
            
            # plot showing actual and predicted values of species
            tabPanel("Prediction",
                     
                     p(br(), strong(
                       "Hover over plot points to see actual vs predicted
                       values and COLORS displayed to the right!"),
                       align = "center"
                       ),
                     fluidRow(column(width =9, 
                                     plotOutput("predplot", hover =
                                                    hoverOpts("chooseiris", 
                                                              delayType =
                                                                   "debounce"
                                                    )
                                     )
                     ),
                     column(width = 3,
                            br(), br(), br(),
                            strong("Actual: "),
                            htmlOutput("chosenactual", 
                                       inline = TRUE),
                            br(),
                            strong("Predicted: "),
                            htmlOutput("chosenpred", 
                                       inline = TRUE)
                            )
                     )
                     
                     ), 
            
            tabPanel("Tree", plotOutput("fittree"))
        )
        
        
        
            )
        
    )
  )
)

