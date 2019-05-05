#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(shinydashboard))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(DT))

combine_df <- read.csv('../data/combine_data_hunger.csv')


# Define UI for application that draws a histogram
ui <- dashboardPage(

    # Application title
    dashboardHeader(title = "The Hunger Game ", titleWidth = 200),
    
    dashboardSidebar(width = 200,
        sliderInput("yearInput", "Select Year Range",
            min = 1961, max = 2017, value = c(1961, 2017), sep = ""),
        sidebarMenu(id = 'tabs',
            menuItem("Dashboards", tabName = "dashboard", icon = icon("bar-chart-o"),
                menuSubItem("Time Series Data", tabName = "timeseries"),
                menuSubItem("Emission Data", tabName = "emission"),
                menuSubItem('Undernourishment Data', tabName = "unnourish")),
            menuItem('Data', tabName = 'data', icon = icon('th')),
            menuItem('Info', tabName = 'info', icon = icon('info-circle')),
            menuItem("Source code", icon = icon("github"), 
                     href = "https://github.com/jielinyu/Girls_in_Tech")
        )

    ),

    # Sidebar with a slider input for number of bins 
    dashboardBody(
        tabItems(
            tabItem(tabName = 'dashboard'),
            tabItem(tabName = "timeseries",
                fluidRow(
                    column(width = 7,
                        box(title = "Global CO2 Emission", width = NULL,
                            status = "primary", solidHeader = T,
                            plotOutput('co2_timeplot')),
                        valueBoxOutput('global_diffBox', width = 6),
                        valueBoxOutput('unnourish_diffBox', width = 6)),
                    column(width = 5,
                    tabBox(title = "Food Statistics", side = 'right', height = 320, width = NULL,
                        tabPanel("CO2 Emissions", imageOutput('emission_timeplot')),
                        tabPanel("Production", imageOutput('product_timeplot'))),
                    box(title = "Undernourish Population", height = 320, width = NULL,
                        imageOutput('unnourish_timeplot'))))),
            tabItem(tabName = "emission",
                fluidRow(
                    box(title = "Total Production Value vs. Production CO2 Emission",
                        status = 'primary', solidHeader = T,
                        plotOutput('emi_val_compPlot')),
                    tabBox(title = 'Relation with Global CO2 Emission', side = 'left',
                        tabPanel("Production Emission", plotOutput('emissionPlot')),
                        tabPanel('Total Production Value', plotOutput('productPlot'))))),
            tabItem(tabName = "unnourish",
                fluidRow(
                    box(title = "Undernourished Population vs. Global CO2 Emission",
                        status = 'primary', solidHeader = T,
                        plotOutput('unnourish_global_compPlot')),
                    tabBox(title = "Relation with Food Production", side = 'left',
                        tabPanel('Production CO2 Emission', plotOutput('unnourish_emi_compPlot')),
                        tabPanel('Production Value', plotOutput('unnourish_val_compPlot'))))),
            tabItem(tabName = 'data',
                fluidRow(
                    column(width = 12,
                        box(width = NULL, status = 'primary', title = "Raw Data", solidHeader = T,
                           dataTableOutput('datatable'))
                    )
                ),
                fluidRow(
                    box(title = 'Metadata', width = NULL, 
                        dataTableOutput('metadata'),
                        downloadButton("download", label = "Download data as csv"))
                    )
                ),
            tabItem(tabName = "info", includeMarkdown("../README.md"))
            
        )
    )
)


#####################
# Define server logic 
#####################

server <- function(input, output) {
    # Reactively filter data
    filter_df <- reactive(
        combine_df %>% filter(Year >= input$yearInput[1] & Year <= input$yearInput[2]) %>% 
        mutate(agriculture_emi = agriculture_emi/1000000,
               livestock_emi = livestock_emi/1000000,
               global_emi = global_emi/1000000000,
               agriculture_value = agriculture_value/1000000000,
               livestock_value = livestock_value/1000000000) %>% 
        select(Year, global_emi, agriculture_emi, livestock_emi, 
               agriculture_value, livestock_value, undernourish))
    
    output$datatable <- renderDataTable(datatable(filter_df()))
    
    ######
    # Tab1
    ######
    
    # Create global CO2 emission timeplot
    co2_timeplot <- reactive(
        filter_df() %>% 
            ggplot(aes(x = Year, y = global_emi))+
            geom_line()+
            labs(y = expression("Total "*CO[2]*" Emission (Billion tonnes)"))+
            theme_bw()
    )
    output$co2_timeplot <- renderPlot(co2_timeplot())
    
    # Create food production CO2 emission timeplot
    emission_timeplot <- reactive({
        filter_df() %>% 
            ggplot(aes(Year)) + 
            geom_line(aes(y=agriculture_emi,colour="Agriculture")) + 
            geom_line(aes(y=livestock_emi,colour="Livestock")) + 
            ylab(expression(CO[2]*" Emission (Millions Gigagrams)"))+
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())

        ggsave('../img/emission_timeplot.PNG')
        list(src = '../img/emission_timeplot.PNG',width = 380,height = 290)
    })
    output$emission_timeplot <- renderImage(emission_timeplot(), deleteFile = T)

    # Create total food production value timeplot
    product_timeplot <- reactive({
        filter_df() %>%
            ggplot(aes(Year)) + 
            geom_line(aes(y=agriculture_value,colour="Agriculture")) + 
            geom_line(aes(y=livestock_value,colour="Livestock")) + 
            ylab("Total Production Value (Billions USD)")+
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())

        
        ggsave('../img/product_timeplot.PNG')
        list(src = '../img/product_timeplot.PNG',width = 380 ,height = 290)
    })
    output$product_timeplot <- renderImage(product_timeplot())

    # Create undernourished population timeplot
    unnourish_timeplot <- reactive({
        filter_df() %>% filter(Year >= 1999) %>% 
            ggplot(aes(Year, undernourish)) +
            geom_line(size = 1.5, alpha = 0.5, colour = "red") +
            ylim(c(0.12,0.16)) +
            ylab("Proportion of Population") +
            theme_bw()
        
        ggsave('../img/unnourish_timeplot.PNG')
        list(src = '../img/unnourish_timeplot.PNG',width = 390,height = 250)
    })
    output$unnourish_timeplot <- renderImage(unnourish_timeplot())
    
    # Create difference stats
    diff_df <- reactive(rbind(filter_df() %>% head(1), filter_df() %>% tail(1)) %>% 
        mutate(undernourish=replace_na(undernourish, 0)) %>% 
        summarise(global_diff = diff(global_emi),
                 undernourish_diff = diff(undernourish),
                 production_diff = diff(agriculture_value + livestock_value)))
    
    output$global_diffBox <- renderValueBox({
        valueBox(
            round(diff_df() %>% pull(global_diff),2), 
            "Net Change in Global CO2 \n(Billion Tonnes)", width = NULL,
            icon = icon("globe-americas"), color = "purple")
    })
    
    output$unnourish_diffBox <- renderValueBox({
        valueBox(
            round(diff_df() %>% pull(undernourish_diff), 2),
            "Net Change in Proportion of \nUndernourished Population", width = NULL,
            icon = icon('utensils'))
        
    })
    
    
    #######
    # Tab 2
    #######
    
    # Create total production value vs global emission plot
    productPlot <- reactive(
        filter_df() %>% 
            ggplot(aes(y = global_emi)) + 
            geom_point(aes(x=agriculture_value, colour = "Agriculture")) + 
            geom_point(aes(x=livestock_value,colour="Livestock")) +
            theme_bw()+
            labs(y = expression("Total "*CO[2]*" Emission (Billion tonnes)"),
                 x = "Food Production Value (Billion USD)") +
            theme(legend.position = "bottom",
                  legend.title = element_blank())
    )
    output$productPlot <- renderPlot(productPlot())

    # Create production emission vs. global emission plot
    emissionPlot <- reactive(
        filter_df() %>% 
        ggplot(aes(y = global_emi)) + 
            geom_point(aes(x=agriculture_emi,colour="Agriculture")) + 
            geom_point(aes(x=livestock_emi,colour="Livestock")) +
            xlab(expression("Agricultural "*CO[2]*" Emission (Million gigagrams)"))+
            ylab(expression("Global "*CO[2]*" Emission (Billion tonnes)"))+
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())
    )
    output$emissionPlot <- renderPlot(emissionPlot())

    # Create food production vs. production emission plot
    emi_val_compPlot <- reactive(
        filter_df() %>% 
            ggplot()+
            geom_point(aes(x = livestock_emi, y = livestock_value, color = "Livestock"), 
                       size = 2.5, alpha = 0.5) +
            geom_point(aes(x = agriculture_emi, y = agriculture_value, color = "Agriculture"), 
                       size = 2.5, alpha = 0.5) +
            xlab(expression(CO[2]*" Emission (Million gigagrams)")) +
            ylab("Total Production Value (Billion USD)") +
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())
    )
    output$emi_val_compPlot <- renderPlot(emi_val_compPlot())
    
    #######
    # Tab 3
    #######
    
    # Undernourishment vs total production value 
    unnourish_value_compPlot <- reactive(
        filter_df() %>%
            ggplot(aes(y = undernourish)) +
            geom_point(aes(x = livestock_value, color = "Livestock"), size = 2.5, alpha = 0.5) +
            geom_point(aes(x = agriculture_value, color = "Agriculture"), size = 2.5, alpha = 0.5) +
            ylim(c(0.12,0.16)) +
            xlab("Food Production Value (Billion USD)") +
            ylab("Proportion of Undernourished Population")+
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())
    )
    output$unnourish_val_compPlot <- renderPlot(unnourish_value_compPlot())

    # Undernourishment vs production emission
    unnourish_emi_compPlot <- reactive(
        filter_df() %>%
            filter(Year %in% c(1999:2016)) %>%
            ggplot(aes(y = undernourish)) +
            geom_point(aes(x = livestock_emi, color = "Livestock"), size = 2.5, alpha = 0.5) +
            geom_point(aes(x = agriculture_emi, color = "Agriculture"), size = 2.5, alpha = 0.5) +
            ylim(c(0.12,0.16)) +
            xlab(expression(CO[2]*" Emission (Million gigagrams)")) +
            ylab("Proportion of Undernourished Population")+
            theme_bw()+
            theme(legend.position = "bottom", legend.title = element_blank())
    )
    output$unnourish_emi_compPlot <- renderPlot(unnourish_emi_compPlot())
    
    # Undernourishment vs global emission plot
    unnourish_global_compPlot <- reactive(
        filter_df() %>% 
            ggplot(aes(x = global_emi, y = undernourish))+
            geom_point()+
            xlim(120, 200)+
            labs(x = expression("Global "*CO[2]*" Emission (Billion Tonnes)"),
                 y = "Proportion of Undernourished Population")+
            theme_bw()
    )
    output$unnourish_global_compPlot <- renderPlot(unnourish_global_compPlot())
    
    #######
    # Tab 4
    #######
    
    # Create download CSV link
    metadata <- tribble(
        ~"Variable Name", ~"Description", ~"Unit",
        "Year", "Range from 1961 to 2016", "year",
        "global_emi", "Global Emission: Total amount of GHG emission globally.", "Billion tonnes",
        "agriculture_emi", "Agriculture Emission: Total amount of GHG emissions from agriculture. ", "Million gigagrams",
        "livestock_emi", "Livestock Emission: Total amount of GHG emissions from livestocks.", "Million gigagram",
        "agriculture_value", "Agriculture Value: Various food and agriculture commodities',gross production values","$USD",
        "livestock_value", "Livestock Value: Total meat production from both commercial and farm slaughter.", "Million Head",
        
        "undernourish", "Undernourishment: Proportion of population considered undernourished under FOA threshold. Data only available from 1999-2015.", "N/A"
    )
    output$metadata <- renderDataTable(metadata,rownames= FALSE,
                                       options = list(pageLength = 7, searching = FALSE))
    
    output$download <- downloadHandler(
        filename = 'hungerGame.csv',
        content = function(file){write.csv(filter_df(), file)}
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
