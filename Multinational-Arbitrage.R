library(quantmod)
library(dplyr)


#Extracting equities data from US then German market
MCD <- data.frame(getSymbols("MCD", from='2010-01-01', to='2020-01-01', auto.assign=F))
MDO.BE <- data.frame(getSymbols("MDO.BE", from='2010-01-01', to='2020-01-01', auto.assign=F))
RIO <- data.frame(getSymbols("RIO", from='2010-01-01', to='2020-01-01', auto.assign=F))
RIO1.BE <- data.frame(getSymbols("RIO1.BE", from='2010-01-01', to='2020-01-01', auto.assign=F))
XOM <- data.frame(getSymbols("XOM", from='2010-01-01', to='2020-01-01', auto.assign=F))
XONA.BE <- data.frame(getSymbols("XONA.BE", from='2010-01-01', to='2020-01-01', auto.assign=F))

MDO.DE <- data.frame(getSymbols("MDO.DE", from='2010-01-01', to='2020-01-01', auto.assign=F))
RIO1.DE <- data.frame(getSymbols("RIO1.DE", from='2010-01-01', to='2020-01-01', auto.assign=F))
XONA.DE <- data.frame(getSymbols("XONA.DE", from='2010-01-01', to='2020-01-01', auto.assign=F))



MCD<-data.frame(na.omit(MCD))
MDO.BE<-data.frame(na.omit(MDO.BE))
RIO<-data.frame(na.omit(RIO))
RIO1.BE<-data.frame(na.omit(RIO1.BE))
XOM<-data.frame(na.omit(XOM))
XONA.BE<-data.frame(na.omit(XONA.BE))

MDO.DE<-data.frame(na.omit(MDO.DE))
RIO1.DE<-data.frame(na.omit(RIO1.DE))
XONA.DE<-data.frame(na.omit(XONA.DE))


MCD.Adjusted<- select(MCD, 'MCD.Adjusted')
MDO.BE.Adjusted<- select(MDO.BE, 'MDO.BE.Adjusted')
RIO.Adjusted<- select(RIO, 'RIO.Adjusted')
RIO1.BE.Adjusted<- select(RIO1.BE, 'RIO1.BE.Adjusted')
XOM.Adjusted<- select(XOM, 'XOM.Adjusted')
XONA.BE.Adjusted<- select(XONA.BE, 'XONA.BE.Adjusted')

MDO.DE.Adjusted<- select(MDO.DE, 'MDO.DE.Adjusted')
RIO1.DE.Adjusted<- select(RIO1.DE, 'RIO1.DE.Adjusted')
XONA.DE.Adjusted<- select(XONA.DE, 'XONA.DE.Adjusted')

################################################################################
MDO.BE2 <- data.frame(getSymbols("MDO.BE", from='2020-01-01', to=Sys.Date(), auto.assign=F))
MDO.DE2 <- data.frame(getSymbols("MDO.DE", from='2020-01-01', to=Sys.Date(), auto.assign=F))
MDO.BE2<-data.frame(na.omit(MDO.BE2))
MDO.DE2<-data.frame(na.omit(MDO.DE2))
MDO.BE2.Adjusted<- select(MDO.BE2, 'MDO.BE.Adjusted')
MDO.DE2.Adjusted<- select(MDO.DE2, 'MDO.DE.Adjusted')
MDO2.Adjusted.comb<- cbind(MDO.BE2.Adjusted, MDO.DE2.Adjusted)


MDO.Adjusted.update <- rbind(MDO.Adjusted.comb, MDO2.Adjusted.comb)

MDO.Adjusted.comb <- MDO.Adjusted.update

MDO.BE <- rbind(MDO.BE, MDO.BE2)
MDO.DE <- rbind(MDO.DE, MDO.DE2)

################################################################################



MDO.BE.Adjusted.save <- MDO.BE.Adjusted

#MDO.BE.Adjusted <- MDO.BE.Adjusted.save




#Check for non-matching rows

i<-1

while(rownames(MDO.BE.Adjusted.save)[i+609+3] == rownames(MDO.DE.Adjusted)[i+2]){
  i<- i+1
}


#98 "2012-11-01 DE
#329 "2013-10-03 BE
#581 "2014-10-03 BE
#738 "2015-05-25 BE
#890 "2015-12-25 DE


match('2012-11-01', rownames(MDO.DE.Adjusted))
match('2015-12-25', rownames(MDO.DE.Adjusted))
match('2013-10-03', rownames(MDO.BE.Adjusted))
match('2014-10-03', rownames(MDO.BE.Adjusted))
match('2015-05-25', rownames(MDO.BE.Adjusted))


MDO.rows <- rownames(MDO.DE.Adjusted)

MDO.remove <- c('2012-11-01', '2013-10-03', '2014-10-03', '2015-05-25', '2015-12-25')

MDO.rows <- MDO.rows[!(MDO.rows %in% MDO.remove)]

MDO.DE.Adjusted <- data.frame(MDO.DE.Adjusted[-c(98,891),])
MDO.BE.Adjusted <- data.frame(MDO.BE.Adjusted[-c(938,1191,1349),])




a<- 1:609

for (i in a){
  MDO.BE.Adjusted<-data.frame(MDO.BE.Adjusted[-c(1),])
}

b<- 1:length(MDO.rows)

for (i in b){
  rownames(MDO.BE.Adjusted)[i] <- MDO.rows[i]
  rownames(MDO.DE.Adjusted)[i] <- MDO.rows[i]
}


MDO.Adjusted.comb<- cbind(MDO.BE.Adjusted, MDO.DE.Adjusted)

colnames(MDO.Adjusted.comb)[1] <- "MDO.BE.Adjusted"
colnames(MDO.Adjusted.comb)[2] <- "MDO.DE.Adjusted"

################################################################################
#Statistics

#Make list of difference in stock prices each day
#fun stuff with that


b<- 1:length(rownames(MDO.Adjusted.comb))
MDO.Adjusted.dif <- b


for (i in b){
  dif <- abs(MDO.Adjusted.comb[i,"MDO.BE.Adjusted"]
             - MDO.Adjusted.comb[i,"MDO.DE.Adjusted"])
  MDO.Adjusted.dif[i]<-dif
}


MDO.Adjusted.difmean <- mean(MDO.Adjusted.dif)
MDO.Adjusted.difmed <- median(MDO.Adjusted.dif)
MDO.Adjusted.difsd<- sd(MDO.Adjusted.dif)

#MDO.Adjuested.difnd <- dnorm(MDO.Adjusted.dif, MDO.Adjusted.difmean, MDO.Adjusted.difsd)


###############################################################################

#Trading Strategy

#computer needs to figure out when dif goes xsd above mean to buy and when it
#goes x sd below mean to sell

#I will use brute force method based off my own calculations to start off but 
#then I will figure out the machine learning aspect of it

#because there is a lower bound at 0 (0.87 sd above the mean) That gives leway 
#for there to be more upside then downside (kind of logical) so I will buy above
#0.87 sd above mean(~1.2986282) and sell below mean(0.64931) 

#score is 341 with 0,0

#I was under the assumption that price inefficiencies were gradual, however, they
#are spontaneous, meaning that even the smallest above the mean are still profitable
#because they are usually *not* followed by a further difference increase


act1<-MDO.Adjusted.difmean + 0*MDO.Adjusted.difsd

end1<-MDO.Adjusted.difmean - 0*MDO.Adjusted.difsd

act.index<- vector()
act.value<- vector()
end.index<- vector()
end.value<- vector()



active<- FALSE

for (i in b){
  if (active == FALSE){
    if (MDO.Adjusted.dif[i]>=act1){
      act.index <- c(act.index,i)
      act.value <- c(act.value,MDO.Adjusted.dif[i])
      active <- TRUE
    }
    
  }
  if(active == TRUE){
    if (MDO.Adjusted.dif[i]<=end1){
      end.index <- c(end.index,i)
      end.value <- c(end.value,MDO.Adjusted.dif[i])
      active <- FALSE
    }
  }
}

score <- sum(act.value) - sum(end.value)



################################################################################

#Actual Trading



BE.profit<-0
DE.profit<-0
multi<-0

balance <- 1000


d <- 1:length(act.index)


#fix for buy/sell
for (i in d){
  
  bet <- .5*balance
  
  multi <- floor(
    (bet/2)/MDO.BE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.BE.Close"])
  
  if(MDO.BE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.BE.Close"] 
     > MDO.DE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.DE.Close"]){
    
    
    BE.profit <- multi* (MDO.BE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.BE.Close"] - 
                           MDO.BE[rownames(MDO.Adjusted.comb)[end.index[i]], "MDO.BE.Close"])
    
    DE.profit <- multi* ( MDO.DE[rownames(MDO.Adjusted.comb)[end.index[i]], "MDO.DE.Close"] - 
                            MDO.DE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.DE.Close"])
    
  }
  
  
  if(MDO.BE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.BE.Close"] 
     < MDO.DE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.DE.Close"]){
    
    
    BE.profit <- multi* (MDO.BE[rownames(MDO.Adjusted.comb)[end.index[i]], "MDO.BE.Close"] - 
                           MDO.BE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.BE.Close"])
    
    DE.profit <- multi* ( MDO.DE[rownames(MDO.Adjusted.comb)[act.index[i]], "MDO.DE.Close"] - 
                            MDO.DE[rownames(MDO.Adjusted.comb)[end.index[i]], "MDO.DE.Close"])
    
  }
  

  balance <- balance + BE.profit + DE.profit
}

balance



