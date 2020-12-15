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
    
    init(tickerName: String, tickerChange: String){
        tickerStr = tickerName
        percentChange = tickerChange
    }
    
}
