//
//  TickerManager.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import Foundation
import CoreData

class TickerManager{
    //Local TickerList used for generating table.
    var tickerList: [TickerLocal] = []
    
    //Persistant storage objects.
    let managedObjectContext: NSManagedObjectContext?
    var fetchedResults = [TickerStore]()
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    init(managedObject: NSManagedObjectContext){
        
        self.managedObjectContext = managedObject
        //Fetch saved tickers from persistant storage.
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TickerStore")
        fetchedResults = ((try? managedObjectContext!.fetch(fetchRequest!)) as? [TickerStore])!
        
        //Clear local tickerList
        tickerList.removeAll()
        
        //Populate fetchedResults with stored Tickers.
        for ticker in fetchedResults{
            if let tickerString = ticker.tickerStr{
                tickerList.append(TickerLocal(tickerName: tickerString))
            }
        }
        
        for ticker in tickerList{
            ticker.percentChange = "Refresh!"
            ticker.afterHoursChange = "Refresh!"
            ticker.volume = "Refresh!"
        }
    }
    
    func getCount() -> Int
    {
        return tickerList.count
    }
    
    func getTickerObject(item:Int) -> TickerLocal{
        
        return tickerList[item]
    }
    
    func removeTickerObject(item:Int) {
        //Update local fetchedResults array to enable deletion.
        fetchedResults = ((try? managedObjectContext!.fetch(fetchRequest!)) as? [TickerStore])!
        
        //Remove local element.
        tickerList.remove(at: item)
        
        //Remove from CoreData database.
        managedObjectContext!.delete(fetchedResults[item])
        fetchedResults.remove(at: item)
        
        do{
            try managedObjectContext!.save()
        }catch {
            print("Error in deletion!")
        }
        
    }
    
    func addTickerObject(tickerStr: String, tickerChange: String, afterHours: String) -> TickerLocal{
        //Append a new local ticker object.
        let newTicker = TickerLocal(tickerName: tickerStr)
        newTicker.percentChange = tickerChange
        newTicker.afterHoursChange = afterHours
        tickerList.append(newTicker)
        
        //Ticker Entity
        let ent = NSEntityDescription.entity(forEntityName: "TickerStore", in: self.managedObjectContext!)
        
        // create a contact object instance for insert
        let newTickerSave = TickerStore(entity: ent!, insertInto: self.managedObjectContext)
        
        // add data to each field in the entity
        newTickerSave.tickerStr = tickerStr
        
        //save the new entity
        do {
            try self.managedObjectContext!.save()
            print("Ticker Saved!")
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return newTicker
    }
    
}
