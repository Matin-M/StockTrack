//
//  TickerListView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import UIKit
import CoreData

class TickerListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tickerModel: TickerManager?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tickerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiate tickerModel
        tickerModel = TickerManager(managedObject: managedObjectContext)
        
        //Designating tableview delegate and datasource.
        tickerTable.delegate = self
        tickerTable.dataSource = self
        
        //Remove TableLines.
        self.tickerTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //Set color of tableView.
        self.tickerTable.backgroundColor = UIColor.gray
        
        //Set tableview row height.
        self.tickerTable.rowHeight = 90.0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return number of saved tickers.
        return tickerModel!.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath) as! TickerCell
        
        // calling the model to get the city object each row
        let ticker = tickerModel!.getTickerObject(item:indexPath.row)
        
        cell.tickerLabel.text = ticker.tickerStr
        cell.tickerObject = ticker

        return cell
    }
    
    //Table Cell deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        tickerModel!.removeTickerObject(item: indexPath.row)

        self.tickerTable.beginUpdates()
        self.tickerTable.deleteRows(at: [indexPath], with: .automatic)
        self.tickerTable.endUpdates()
    }
    
    //Adds a ticker.
    @IBAction func addTicker(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add a stock to your watchlist", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Ticker Symbol (i.e. TSLA)"
            }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [self] alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                //Add ticker object w/ textfield str.
                tickerModel!.addTickerObject(tickerStr: firstTextField.text!)
                tickerTable.reloadData()
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            
        self.present(alertController, animated: true, completion: nil)
        
        print(tickerModel?.getCount())

    }
    
    //Unwind segue.
    @IBAction func returnFromDetailView(unwindSegue: UIStoryboardSegue){
        print("Returned from detailView!")
    }
    
    //Unwind segue.
    @IBAction func returnFromNewsView(unwindSegue: UIStoryboardSegue){
        print("Returned from newsView!")
    }
    
    
}
