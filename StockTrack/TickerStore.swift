//
//  TickerStore.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/10/20.
//

import Foundation
import CoreData

/**
 Ticker Class used for persistant storage via Core Data.
 */
@objc(TickerStore)
public class TickerStore: NSManagedObject{
    
    //Ticker string
    @NSManaged var tickerStr: String?
    
    
}
