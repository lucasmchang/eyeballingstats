library(shiny)
library(reshape2)
library(ggplot2)
npoints = 0
shinyServer(
    function(input, output) {
        output$oselect <- renderPrint({input$select})    
        output$oalpha <- renderPrint({input$alpha})
        output$omode <- renderPrint({paste(input$select, ": α =", input$alpha, ", n =", npoints)})
        p_value <- NA
        observeEvent(input$generateButton, {
            #generate data, save plot, compute p-value and correct answer
            
            if (input$select == "One-Sample T") {
                data <- rnorm(sample(c(10:100, seq(110,200,10)),1)) + rnorm(1)/3
                data[data < -3] <- -3
                data[data > 3] <- 3
                npoints <<- length(data)
                g <- ggplot(data.frame(data = data), aes(x = 0, y = data)) + 
                    geom_boxplot(outlier.shape=NA, width = .2) + #avoid plotting outliers twice
                    geom_jitter(position=position_jitter(width=.02), height=0, alpha = .6) + 
                    scale_x_continuous(limits = c(-1, 1)) +
                    scale_y_continuous(limits = c(-3.1, 3.1))
                output$oplot <- renderPlot({g})
                p_value <<- t.test(data)$p.value
                output$omode <- renderPrint({paste(input$select, ": α =", input$alpha, ", n =", npoints)})
            } else if (input$select == "Two-Sample T") {
                n <- sample(c(10:100, seq(110,200,10)),1)
                data1 <- rnorm(n) + rnorm(1)/3
                data2 <- rnorm(n) + rnorm(1)/3
                data <- data.frame(y1 = data1, y2 = data2)
                data <- melt(data)
                npoints <<- length(data)
                data$variable <- as.numeric(data$variable)
                g <- ggplot(data, aes(y = value, group = variable, x = variable)) +
                    geom_boxplot(outlier.shape=NA, width = .2) +
                    geom_jitter(position=position_jitter(width=.02), height=0, alpha = .6) + 
                    scale_x_continuous(limits = c(.5, 2.5)) +
                    scale_y_continuous(limits = c(-3.1, 3.1))
                output$oplot <- renderPlot({g})
                p_value <<- t.test(data1, data2, var.equal = T)$p.value
                output$omode <- renderPrint({paste(input$select, ": α =", input$alpha, ", n =", npoints)})
            } else if (input$select == "Regression") {
                n <- sample(c(50:100, seq(110,200,10)),1)
                npoints <<- n
                x <- rnorm(n)
                y <- rnorm(n)*rnorm(1) + x*rnorm(1)/12
                g <- ggplot(data.frame(x=x,y=y), aes(x=x, y=y)) +
                    geom_point() + 
                    geom_smooth(method="lm", se = F)
                output$oplot <- renderPlot({g})
                p_value <<- coef(summary(lm(y~x)))[2,4]
                output$omode <- renderPrint({paste(input$select, ": α =", input$alpha, ", n =", npoints)})
            }
        })
        
        observeEvent(input$yesButton, {
            correct =  (p_value < input$alpha)
            output$ofeedback <- renderText({
                paste( ifelse(correct, "Correct,", "Incorrect,"), 
                    "α =", input$alpha, ",", "p =", p_value)
            })
        })

        observeEvent(input$noButton, {
            correct =  (p_value >= input$alpha)
            output$ofeedback <- renderText({
                paste( ifelse(correct, "Correct,", "Incorrect,"), 
                    "α =", input$alpha, ",", "p =", p_value)
            })
        })
    }
)