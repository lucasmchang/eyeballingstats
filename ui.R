library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Eyeballing Statistical Tests"),
    sidebarPanel(
        h6("Welcome to Eyeballing Statistical Tests. This app is an educational tool for you to get an intuitive idea of what data should look like in order to reach a specific p-value in some common tests. Often, data is presented only numerically or only graphically, so it's useful to be able to convert roughly between the two in your head. You can choose from 'One-Sample T', 'Two-Sample T (Equal Variance)', and 'Simple Linear Regression' in the drop-down box, and you can also specify an alpha-level. Then, click the 'Generate' button to create a dataset. A plot of the dataset will appear on the right side of the screen. (Note that datasets will have between 10 and 200 points and are normally distributed). Then test yourself by choosing to reject or fail to reject the null, and see if the results match your intuition!"),
        selectInput("select", label = h3("Choose test type:"), 
                    choices = list("One-Sample T" = "One-Sample T",
                                   "Two-Sample T (Equal Variance)" = "Two-Sample T", 
                                   "Simple Linear Regression" = "Regression"), 
                    selected = "One-Sample T"),
        numericInput("alpha", "Choose an alpha level", 0.05, min = 0, max = 1, step = 0.01),
        actionButton("generateButton", "Generate"),
        actionButton("yesButton", "Reject Null"),
        actionButton("noButton", "Fail To Reject Null")

    ),
    mainPanel(
        h4("You selected"),
        verbatimTextOutput("omode"),
        plotOutput("oplot"),
        verbatimTextOutput("ofeedback")
    )
))