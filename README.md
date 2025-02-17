# Statistical Arbitrage: McDonald's Price Discrepancies in Frankfurt & Berlin  

## Overview  
This project explores statistical arbitrage opportunities by analyzing McDonald's ($MCD) daily closing prices across the **Frankfurt** and **Berlin** stock exchanges. Inspired by *The Quants* by Scott Patterson, the experiment aimed to identify and exploit discrepancies between historical price differences in these two markets.  

## Methodology  
- **Data Collection**: Web-scraped daily closing prices for $MCD from Yahoo Finance for both exchanges.  
- **Analysis**: Examined the historical mean price difference and identified deviations that could signal an arbitrage opportunity.  
- **Trading Strategy**:  
  - Implemented a simulated long-short strategy when price differences fell out of sync with their historical mean.  
  - Tested different historical periods to optimize the strategy.  
  - Did **not** account for trading fees.  
- **Live Updates**: Results were live-tweeted (since deleted).  

## Key Findings  
1. **Simulated Profitability**: The strategy appeared profitable in a paper-trading environment.  
2. **Real-World Limitations**:  
   - **Trading Fees**: Would have eroded all simulated profits.  
   - **Liquidity Issues**: The Berlin Stock Exchange is highly illiquid. Real trades could have impacted prices, making it difficult to predict convergence.  

## Challenges  
- Technical challenges in web-scraping and formatting the data.  
- The most difficult part was **finding** a viable arbitrage opportunity. It required iterative trial-and-error.  
- Identifying a ticker with usable price data took some experimentation.  

## Conclusion  
While the experiment confirmed that historical price discrepancies can present arbitrage opportunities, the limitations of fees and market liquidity rendered the strategy impractical for real-world execution. This project served as a valuable learning experience in market inefficiencies, data collection, and systematic trading approaches. Although no further development is planned, it remains an interesting case study in exploring market inefficiencies at a small scale.  


