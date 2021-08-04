#Scrape data, append to BE, DE and their adjusteds and find new mean
#Create new dif that itterates. If dif of day is greater than running averge,
#record "trade" and post.
library(rvest)
library(dplyr)
library(stringr)

load("C:/Users/jackh/Documents/Daily_Trade.RData")


################################################################################

#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/

#DE

MDO.BE.webpage <- read_html(MDO.BE.link)
MDO.DE.webpage <- read_html(MDO.DE.link)



date <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[1]/span") %>% html_text()
open <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[2]/span") %>% html_text() %>% as.double()
high <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[3]/span") %>% html_text() %>% as.double()
low <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[4]/span") %>% html_text() %>% as.double()
close <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[5]/span") %>% html_text() %>% as.double()
adjusted <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[6]/span") %>% html_text() %>% as.double()
volume <- MDO.DE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[7]/span") %>% html_text() %>% gsub(",", "", .) %>% as.double()


yr <- substr(date, start = 9, stop = 12)
mon <- substr(date, start = 5, stop = 6)
day <- months[substr(date, start=1, stop=3)]

new_date <- str_c(yr, day, mon, sep ="-")

if (new_date == rownames(MDO.DE)[nrow(MDO.DE)]){
  quit()
}



new <- data.frame(open, high, low, close, volume, adjusted)



for (i in 1:length(colnames(MDO.DE))){
  colnames(new)[i] <- colnames(MDO.DE) [i]
}

MDO.DE <- rbind(MDO.DE, new) 


rownames(MDO.DE)[length(rownames(MDO.DE))] <- new_date



#BE

date <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[1]/span") %>% html_text()
open <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[2]/span") %>% html_text() %>% as.double()
high <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[3]/span") %>% html_text() %>% as.double()
low <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[4]/span") %>% html_text() %>% as.double()
close <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[5]/span") %>% html_text() %>% as.double()
adjusted <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[6]/span") %>% html_text() %>% as.double()
volume <- MDO.BE.webpage %>% html_node(xpath = "//*[@id='Col1-1-HistoricalDataTable-Proxy']/section/div[2]/table/tbody/tr[1]/td[7]/span") %>% html_text() %>% gsub(",", "", .) %>% as.double()



new <- data.frame(open, close, high, low, volume, adjusted)

if (is.na(new[,5])){
  new[,5] <- 0
}


for (i in 1:length(colnames(MDO.BE))){
  colnames(new)[i] <- colnames(MDO.BE) [i]
}

MDO.BE <- rbind(MDO.BE, new)


rownames(MDO.BE)[length(rownames(MDO.BE))] <- new_date


tail(MDO.BE)
#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/#/



#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.

new.adjusted <- data.frame(MDO.BE[nrow(MDO.BE), "MDO.BE.Adjusted"], MDO.DE[nrow(MDO.DE) , "MDO.DE.Adjusted"])

for (i in 1:length(colnames(MDO.Adjusted.comb))){
  colnames(new.adjusted)[i] <- colnames(MDO.Adjusted.comb) [i]
}

rownames(new.adjusted)[1] <- new_date

MDO.Adjusted.comb <- rbind(MDO.Adjusted.comb, new.adjusted)

new.dif <- abs(MDO.BE[nrow(MDO.BE), "MDO.BE.Adjusted"] - MDO.DE[nrow(MDO.DE) , "MDO.DE.Adjusted"])

MDO.Adjusted.dif <- c(MDO.Adjusted.dif, new.dif)

MDO.Adjusted.difmean <- mean(MDO.Adjusted.dif)
MDO.Adjusted.difmed <- median(MDO.Adjusted.dif)
MDO.Adjusted.difsd<- sd(MDO.Adjusted.dif)


#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.

z <- length(MDO.Adjusted.dif)


if (active == FALSE){
  if (MDO.Adjusted.dif[z]>=act){
    act.index <- c(act.index,z)
    act.value <- c(act.value,MDO.Adjusted.dif[z])
    c <- length(act.index)
    
    if(MDO.BE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.BE.Close"] 
       > MDO.DE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.DE.Close"]){
      
      
      long.enter <- MDO.DE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.DE.Close"]
      long.ticker <- 'MDO.DE'
      
      short.enter <- MDO.BE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.BE.Close"]
      short.ticker <- 'MDO.BE'
      
      
      
      
    }
    else{
      
      long.enter <- MDO.BE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.BE.Close"]
      long.ticker <- 'MDO.BE'
      
      short.enter <- MDO.DE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.DE.Close"]
      short.ticker <- 'MDO.DE'
      
    }
    
    system(sprintf("python Tweet.py enter %s %G %s %G", long.ticker, long.enter, short.ticker, short.enter), wait=FALSE)
    
    
    active <- TRUE
  }
}

if(active == TRUE){
  
  if (MDO.Adjusted.dif[z]<=end){
    end.index <- c(end.index, z)
    end.value <- c(end.value, MDO.Adjusted.dif[z])
    
    if(MDO.BE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.BE.Close"] 
       > MDO.DE[rownames(MDO.Adjusted.comb)[act.index[c]], "MDO.DE.Close"]){
      
      
      long.exit <- MDO.DE[rownames(MDO.Adjusted.comb)[end.index[c]], "MDO.DE.Close"]
      long.ticker <- 'MDO.DE'
      
      short.exit <- MDO.BE[rownames(MDO.Adjusted.comb)[end.index[c]], "MDO.BE.Close"]
      short.ticker <- 'MDO.BE'
      
    }
    else{
      
      long.exit <- MDO.BE[rownames(MDO.Adjusted.comb)[end.index[c]], "MDO.BE.Close"]
      long.ticker <- 'MDO.BE'
      
      short.exit <- MDO.DE[rownames(MDO.Adjusted.comb)[end.index[c]], "MDO.DE.Close"]
      short.ticker <- 'MDO.DE'
      
    }
    
    long.profit <- long.exit - long.enter
    short.profit <- short.enter - short.exit
    
    total.profit <- long.profit + short.profit
    
    system(sprintf("python Tweet.py exit %s %G %s %G %G %G %G", long.ticker, long.exit, short.ticker, short.exit, long.profit, short.profit, total.profit), wait=FALSE)
    
    active <- FALSE
  }
}



save.image("C:/Users/jackh/Documents/Daily_Trade.RData")




################################################################################



