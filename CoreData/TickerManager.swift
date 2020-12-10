//
//  TickerManager.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import Foundation
import CoreData

class TickerManager{
    
    var tickerList: [TickerLocal] = []
    
    var insertContext: NSManagedObjectContext?
    var viewContext: NSManagedObjectContext?
    var fetchedResults = [Ticker]()
    
    init(insertContext: NSManagedObjectContext, viewContext: NSManagedObjectContext){
        self.insertContext = insertContext
        self.viewContext = viewContext
        
        //Fetch saved tickers from persistant storage.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ticker")
        fetchedResults = ((try? insertContext.fetch(fetchRequest)) as? [Ticker])!
        
        //Clear local tickerList
        tickerList.removeAll()
    }
    
    func getCount() -> Int
    {
        return tickerList.count
    }
    
    func getTickerObject(item:Int) -> TickerLocal{
        
        return tickerList[item]
    }
    
    func removeCityObject(item:Int) {
        
        tickerList.remove(at: item)
        insertContext!.delete(fetchedResults[item])
        fetchedResults.remove(at: item)
        
        do{
            try insertContext!.save()
        }catch {
            print("Error in deletion!")
        }
        
    }
    
    func addCityObject(tickerStr: String) -> TickerLocal{
        //Append a new local ticker object.
        let newTicker = TickerLocal(tickerName: tickerStr)
        tickerList.append(newTicker)
        
        // get a handler to the Contacts entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "City", in: self.insertContext!)
        
        // create a contact object instance for insert
        let newTickerSave = Ticker(entity: ent!, insertInto: insertContext)
        
        // add data to each field in the entity
        newTickerSave.tickerStr = tickerStr
        
        //save the new entity
        do {
            try insertContext!.save()
            print("Ticker Saved!")
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return newTicker
    }
    
}
