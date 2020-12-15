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
    
    init(tickerName: String, tickerChange: String, afterHours: String){
        tickerStr = tickerName
        percentChange = tickerChange
        afterHoursChange = afterHours
    }
    
}
