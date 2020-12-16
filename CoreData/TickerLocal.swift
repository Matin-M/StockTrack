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
    
    var tickerStr: String?
    var percentChange: String?
    var afterHoursChange: String?
    var volume: String?
    var companyName: String?
    
    init(tickerName: String){
        tickerStr = tickerName
        percentChange = "0.0%"
        afterHoursChange = "0.0%"
    }
    
}
