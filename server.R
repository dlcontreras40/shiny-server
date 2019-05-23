#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library("ggplot2")
library("maptools")
library("sp")
library("rgdal")
library("stpp")
library("plot3D")
library("ggmap")
library("bbmle")
library("spatstat")
library("RColorBrewer")
library('data.table')
library('readxl')
library('plotly')
library('dplyr')
library("viridis")
library("leaflet")
library("raster")
library("tidyr")
library("DT")


shp <- readOGR("AlleghenyCounty__ZipCodeBoundaries2016.shp")
shapeData <- spTransform(map, CRS("+proj=longlat +datum=WGS84 +no_defs"))
bouds<-bbox(shapeData)
shp@data$id<-rownames(shp@data)
shp.df<-fortify(shp)


dt<-read.csv("table.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  
  
  data.reactive<-reactive({
    dt.dt<-filter(dt, year==input$year)
    dt.dt$X<-as.character(dt.dt$X)
    data.reactive<-shp.df %>% left_join(dt.dt, by=c('id'='X'))})
  
  getDataSet<-reactive({
    dataSet_year<-filter(dt, year==input$year)
    dataSet<-data.frame(X=dataSet_year$X,
                              ZIP=dataSet_year$ZIP,
                              year=dataSet_year$year,
                              column_to_plot=switch(input$industry_code,
                                                    "11. Agriculture, Forestry, Fishing and Hunting" = dataSet_year$X11,
                                                    "21. Mining" = dataSet_year$X21,
                                                    "22. Utilities" = dataSet_year$X22,
                                                    "23. Construction" = dataSet_year$X23,
                                                    "42. Wholesale Trade" = dataSet_year$X42,
                                                    "51. Information" = dataSet_year$X51,
                                                    "52. Finance and Insurance" = dataSet_year$X52,
                                                    "53. Real State Rental and Leasing" = dataSet_year$X53,
                                                    "54. Professional, Scientific, and Technical Services" = dataSet_year$X54,
                                                    "55. Management of Companies and Enterprises" = dataSet_year$X55,
                                                    "56. Administrative and Support" = dataSet_year$X56,
                                                    "61. Educational Services" = dataSet_year$X61,
                                                    "62. Health Care and Social Assistance" = dataSet_year$X62,
                                                    "71. Arts, Entertainment, and Recreation" = dataSet_year$X71,
                                                    "72. Accomodation and Food Services" = dataSet_year$X72,
                                                    "81. Other Services" = dataSet_year$X81,
                                                    "92. Public Administration"  = dataSet_year$X92))
    
    dataSet$ZIP<-as.integer(dataSet$ZIP)
    joinedDataSet<-shapeData
    joinedDataSet@data$ZIP<-as.integer(joinedDataSet@data$ZIP)
    joinedDataSet@data<-suppressWarnings(left_join(joinedDataSet@data,dataSet, by="ZIP"))
    joinedDataSet
  })

  
  subset.2013<-subset(dt, year==2013)
  subset.2014<-subset(dt, year==2014)
  subset.2015<-subset(dt, year==2015)
  subset.2016<-subset(dt, year==2016)
  
  
  total.table<-data.frame(year=c(2013,2014,2015,2016),
                          X11=c(sum(subset.2013$X11),sum(subset.2014$X11),sum(subset.2015$X11),sum(subset.2016$X11)),
                          X21=c(sum(subset.2013$X21),sum(subset.2014$X21),sum(subset.2015$X21),sum(subset.2016$X21)),
                          X22=c(sum(subset.2013$X22),sum(subset.2014$X22),sum(subset.2015$X22),sum(subset.2016$X22)),
                          X23=c(sum(subset.2013$X23),sum(subset.2014$X23),sum(subset.2015$X23),sum(subset.2016$X23)),
                          X42=c(sum(subset.2013$X42),sum(subset.2014$X42),sum(subset.2015$X42),sum(subset.2016$X42)),
                          X51=c(sum(subset.2013$X51),sum(subset.2014$X51),sum(subset.2015$X51),sum(subset.2016$X51)),
                          X52=c(sum(subset.2013$X52),sum(subset.2014$X52),sum(subset.2015$X52),sum(subset.2016$X52)),
                          X53=c(sum(subset.2013$X53),sum(subset.2014$X53),sum(subset.2015$X53),sum(subset.2016$X53)),
                          X54=c(sum(subset.2013$X54),sum(subset.2014$X54),sum(subset.2015$X54),sum(subset.2016$X54)),
                          X55=c(sum(subset.2013$X55),sum(subset.2014$X55),sum(subset.2015$X55),sum(subset.2016$X55)),
                          X56=c(sum(subset.2013$X56),sum(subset.2014$X56),sum(subset.2015$X56),sum(subset.2016$X56)),
                          X61=c(sum(subset.2013$X61),sum(subset.2014$X61),sum(subset.2015$X61),sum(subset.2016$X61)),
                          X62=c(sum(subset.2013$X62),sum(subset.2014$X62),sum(subset.2015$X62),sum(subset.2016$X62)),
                          X71=c(sum(subset.2013$X71),sum(subset.2014$X71),sum(subset.2015$X71),sum(subset.2016$X71)),
                          X72=c(sum(subset.2013$X72),sum(subset.2014$X72),sum(subset.2015$X72),sum(subset.2016$X72)),
                          X81=c(sum(subset.2013$X81),sum(subset.2014$X81),sum(subset.2015$X81),sum(subset.2016$X81)),
                          X99=c(sum(subset.2013$X99),sum(subset.2014$X99),sum(subset.2015$X99),sum(subset.2016$X99))
                          )
  
  
  
  sociodemografic.table<-read.csv("socio_table.csv")
  
  socio.reactive<-reactive({
    socio.dt<-filter(sociodemografic.table, year==input$year2)
    socio.dt$X<-as.character(socio.dt$X)
  socio.reactive<-shp.df %>% left_join(socio.dt, by=c('id'='X'))})
  
  pal <- colorNumeric(palette = "YlGnBu", NULL)
  
  
  
  output$headerOne<-renderText({
    paste0("Number of establishments of ", input$industry_code, " during ", input$year)
  })
  

  
  output$Plot<- renderLeaflet(
    leaflet()  %>% addTiles() %>% 
      setView(lng = -79.9959 , lat=40.4406,zoom=9)%>% 
      addProviderTiles(providers$CartoDB.Positron)
  )
  observe({
    theData<-getDataSet()
    pal<-colorNumeric("YlOrRd", theData$column_to_plot)
    leafletProxy("Plot", data = theData)%>%clearShapes()%>%
      addPolygons(data = theData,
                  fillColor = pal(theData$column_to_plot),
                  fillOpacity = 1.0,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = paste0("ZIP Code ",theData$ZIP, ":",theData$column_to_plot))%>%
      clearControls()%>%
      addLegend("bottomleft", pal = pal, values = theData$column_to_plot, 
                title="Number of Establishments",
                opacity = 1)
    
  })
  
  output$Plot2<-renderPlot( ggplot(data = total.table,aes(x=year, y=switch (input$industry_code,
                                                    "11. Agriculture, Forestry, Fishing and Hunting" = X11,
                                                    "21. Mining" = X21,
                                                    "22. Utilities" = X22,
                                                    "23. Construction" = X23,
                                                    "42. Wholesale Trade" = X42,
                                                    "51. Information" = X51,
                                                    "52. Finance and Insurance" = X52,
                                                    "53. Real State Rental and Leasing" = X53,
                                                    "54. Professional, Scientific, and Technical Services" = X54,
                                                    "55. Management of Companies and Enterprises" = X55,
                                                    "56. Administrative and Support" = X56,
                                                    "61. Educational Services" = X61,
                                                    "62. Health Care and Social Assistance" = X62,
                                                    "71. Arts, Entertainment, and Recreation" = X71,
                                                    "72. Accomodation and Food Services" = X72,
                                                    "81. Other Services" = X81,
                                                    "92. Public Administration"  = X99
    )))+geom_line(colour="orange", size=2)+xlab("Year")+
      ylab("Number of Establishments")+theme_bw()+geom_point(colour="orange", size=5)+labs(fill="Scale")
      )
  
  
  output$plotsocio<- renderPlot({
   
    if (input$socio=="Sex") {
      ggplot(data = socio.reactive())+ 
        aes(long,lat,group=group, fill=switch (input$sex,
                                               "Male"=male,
                                               "Female"=female
        )) + 
        geom_polygon()+geom_path(color = "white")+ scale_fill_viridis(option="A", direction=-1)+theme_bw()+labs(fill="Scale")} 
    
    else { if (input$socio=="Education") {
      ggplot(data = socio.reactive())+ 
        aes(long,lat,group=group, fill=switch (input$education,
                                               "Less than 24 years:No high school"=lesshigh,
                                               "Less than 24 years:High School"=high_school,
                                               "Less than 24 years:Some College"=Somecollege,
                                               "Less than 24 years:Bachelor"=Bachelor_degree,
                                               "Older than 25 years:Less than 9th grade"=olderthan250lessthan9,
                                               "Older than 25 years:9th to 12th"=olderthan2509to12,
                                               "Older than 25 years:high school"=olderthan250highschool,
                                               "Older than 25 years:some college, no degree"=olderthan250somecollege0nodegree,
                                               "Older than 25 years:associate degree"=olderthan250associate_degree,
                                               "Older than 25 years:bachelor degree"=olderthan250bachelor_degree,
                                               "Older than 25 years:graduate degree"=olderthan250graduate_degree)) + 
        geom_polygon()+geom_path(color = "white")+ scale_fill_viridis(option="A", direction=-1)+theme_bw()+labs(fill="Scale")
      
    }
     else {
      ggplot(data = socio.reactive())+ 
        aes(long,lat,group=group, fill=switch (input$socio,
                                               "Population"=population,
                                               "Poverty"=poverty
        )) + 
        geom_polygon()+geom_path(color = "white")+ scale_fill_viridis(option="A", direction=-1)+theme_bw()+labs(fill="Scale")
    }}
    })
  output$headertwo<-renderText({
    if (input$socio=="Sex") {
      
    }

    else { if (input$socio=="Education") {

    }
      else {

              }}
    
    
    paste0("Number of establishments of ", input$industry_code, " during ", input$year)
  })
  
    
    })



# 
# {
#   ggplot(data = data.reactive())+ 
#     aes(long,lat,group=group, fill=switch (input$industry_code,
#                                            "11. Agriculture, Forestry, Fishing and Hunting" = X11,
#                                            "21. Mining" = X21,
#                                            "22. Utilities" = X22,
#                                            "23. Construction" = X23,
#                                            "42. Wholesale Trade" = X42,
#                                            "51. Information" = X51,
#                                            "52. Finance and Insurance" = X52,
#                                            "53. Real State Rental and Leasing" = X53,
#                                            "54. Professional, Scientific, and Technical Services" = X54,
#                                            "55. Management of Companies and Enterprises" = X55,
#                                            "56. Administrative and Support" = X56,
#                                            "61. Educational Services" = X61,
#                                            "62. Health Care and Social Assistance" = X62,
#                                            "71. Arts, Entertainment, and Recreation" = X71,
#                                            "72. Accomodation and Food Services" = X72,
#                                            "81. Other Services" = X81,
#                                            "92. Public Administration"  = X99
#     )) + 
#     geom_polygon()+geom_path(color = "white")+ scale_fill_viridis(option="A", direction=-1)+theme_bw()+labs(fill="Scale")
# }
# # 
