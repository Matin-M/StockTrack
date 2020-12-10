//
//  Ticker.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import Foundation
import CoreData

/**
 Ticker Class used for persistant storage via Core Data.
 */
public class Ticker: NSManagedObject{
    
    //Ticker string
    @NSManaged var tickerStr: String?
    
}
