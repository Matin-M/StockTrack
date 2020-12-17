//
//  TickerLocal.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import Foundation

/**
 Local ticker object used for generating tableView
 */
class TickerLocal{
    
    var fetchFinancials: FetchFinacialData!
    
    var tickerStr: String?
    var percentChange: String?
    var afterHoursChange: String?
    var volume: String?
    var companyName: String?
    var currentPrice: String?
    
    init(tickerName: String){
        tickerStr = tickerName
        percentChange = "0.000%"
        afterHoursChange = "0.000%"
        volume = "0"
        companyName = "Display Name N/A"
        currentPrice = "Refresh"
    }
    
}
