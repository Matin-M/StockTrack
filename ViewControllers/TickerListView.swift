//
//  TickerListView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import UIKit
import CoreData
import SideMenu

class TickerListView: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuControllerDelegate, APIErrorDelegate{
    
    //CoreData and Model objects.
    var tickerModel: TickerManager?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //TickerListView UI Items.
    @IBOutlet weak var tickerTable: UITableView!
    var menu: SideMenuNavigationController?
    
    //Menu Views.
    var settingsView: UIViewController!
    var aboutView: UIViewController!
    var usageView: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiate tickerModel.
        tickerModel = TickerManager(managedObject: managedObjectContext)
        
        //Configure menu View Controller.
        let sideMenuObject = MenuTableView()
        sideMenuObject.delegate = self
        menu = SideMenuNavigationController(rootViewController: sideMenuObject)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        //Designating tableview delegate and datasource.
        tickerTable.delegate = self
        tickerTable.dataSource = self
        
        //Remove TableLines.
        self.tickerTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //Set color of tableView.
        self.tickerTable.backgroundColor = UIColor.gray
        
        //Set tableview row height.
        self.tickerTable.rowHeight = 90.0
        
        //Update tickers with data upon open.
        refreshTickers()
        
        //Declare Menu Subviews.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        settingsView = storyboard.instantiateViewController(withIdentifier: "SettingsView")
        usageView = storyboard.instantiateViewController(withIdentifier: "UsageView")
        aboutView = storyboard.instantiateViewController(withIdentifier: "AboutView")
    }
    
    //Handle sidemenu interactions.
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    func didSelectMenuItem(named: String) {
        menu?.dismiss(animated: true, completion: {
            if named == "Usage"{
                self.present(self.usageView, animated: true, completion: nil)
            }else if named == "About" {
                self.present(self.aboutView, animated: true, completion: nil)
            }else if named == "Settings"{
                self.present(self.settingsView, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: - API Error handling.
    func clientError() {
        let alertController = UIAlertController(title: "ERROR 408: Request Timeout", message: "Failed to fetch data. Make sure you are connected to the internet and try again.", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancel)

        if self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func serverError() {
        
        let alertController = UIAlertController(title: "ERROR 408: Request Timeout", message: "Failed to fetch data. The server is no longer accepting requests at the moment, please try again later.", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancel)

        if self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - TableView delegate functions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return number of saved tickers.
        return tickerModel!.getCount()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath) as! TickerCell
        
        // calling the model to get the city object each row
        let ticker = tickerModel!.getTickerObject(item:indexPath.row)
        
        cell.tickerLabel.text = ticker.tickerStr
        cell.backgroundColor = UIColor.clear
        
        //Cell variables.
        let changeFloat = Float(ticker.percentChange ?? "0.0")
        let changeFormatted = String(format: "%.2f", changeFloat!)
        
        //Change color of %change labels to reflect gains/losses.
        if(ticker.percentChange?.contains("-") == false){
            cell.percentChange.textColor = UIColor.green
            cell.percentChange.text = "↑\(changeFormatted)%"
        }else{
            cell.percentChange.textColor = UIColor.red
            cell.percentChange.text = "↓\(changeFormatted)%"
        }
        
        if(ticker.afterHoursChange != nil && ticker.afterHoursChange != "0.0"){
            let afterChangeFloat = Float(ticker.afterHoursChange!)
            let afterChangeFormatted = String(format: "%.2f", afterChangeFloat!)
            
            if(ticker.afterHoursChange!.contains("-") == false){
                cell.afterHoursChange.textColor = UIColor.green
                cell.afterHoursChange.text = "↑\(afterChangeFormatted)%"
            }else{
                cell.afterHoursChange.textColor = UIColor.red
                cell.afterHoursChange.text = "↓\(afterChangeFormatted)%"
            }
        }else{
            cell.afterHoursChange.textColor = UIColor.yellow
            cell.afterHoursChange.text = "Δ = 0.00%"
        }
        
        //Set remaining attributes. 
        cell.companyName.text = ticker.companyName
        cell.volume.text = ticker.volume
        cell.currentPrice.text = "$\(ticker.currentPrice ?? "Error")"
        return cell
    }
    
    //Table Cell deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        tickerModel!.removeTickerObject(item: indexPath.row)
        self.tickerTable.beginUpdates()
        self.tickerTable.deleteRows(at: [indexPath], with: .automatic)
        self.tickerTable.endUpdates()
    }
    
    //Adds a ticker.
    @IBAction func addTicker(_ sender: Any) {
        //Create Alertcontroller object.
        let alertController = UIAlertController(title: "Add a stock to your watchlist", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Ticker Symbol (i.e. TSLA)"
            }
        //Add "Add" Action.
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [self] alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            //Add ticker object w/ textfield str.
            let addedTickerObj = tickerModel!.addTickerObject(tickerStr: firstTextField.text!)
            let fetch = FetchFinacialData(ticker: addedTickerObj.tickerStr!)
            addedTickerObj.fetchFinancials = fetch
            addedTickerObj.fetchFinancials.delegate = self
            fetch.fetchStockQuote()
            
            if((fetch.extractData(data: FetchFinacialData.Databases.data, toFind: "result", delimiter: ",", skipAmnt: 2)) == "[]"){
                print("Not Found!")
                let alert = UIAlertController(title: "ERROR 404: Ticker Not Found", message: "Failed to fetch data. The ticker symbol you entered is either invalid or does not exist.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            addedTickerObj.percentChange = fetch.getQuoteData(toFind: "regularMarketChangePercent")
            addedTickerObj.afterHoursChange = fetch.getQuoteData(toFind: "postMarketChangePercent")
            addedTickerObj.companyName = fetch.getQuoteData(toFind: "displayName")?.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
            addedTickerObj.volume = fetch.getQuoteData(toFind: "regularMarketVolume")
            addedTickerObj.currentPrice = fetch.getQuoteData(toFind: "regularMarketPrice")
            //Set FetchFinancialData object.
            tickerTable.reloadData()
        })
        //Add "Cancel" Action.
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
        //Present UIAlert.
        self.present(alertController, animated: true, completion: nil)
    }
    
    func refreshTickers() -> Void{
        for tickerFromList in tickerModel!.tickerList{
            //Set stats.
            let fetch = FetchFinacialData(ticker: tickerFromList.tickerStr!)
            tickerFromList.fetchFinancials = fetch
            tickerFromList.fetchFinancials.delegate = self
            fetch.fetchStockQuote()
            tickerFromList.percentChange = fetch.getQuoteData(toFind: "regularMarketChangePercent")
            tickerFromList.afterHoursChange = fetch.getQuoteData(toFind: "postMarketChangePercent")
            tickerFromList.companyName = fetch.getQuoteData(toFind: "displayName")?.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
            tickerFromList.volume = fetch.getQuoteData(toFind: "regularMarketVolume")
            tickerFromList.currentPrice = fetch.getQuoteData(toFind: "regularMarketPrice")
            //Set FetchFinancialData object.
        }
        
    }
    
    //Refresh watchlist.
    @IBAction func refresh(_ sender: Any) {
        refreshTickers()
        tickerTable.reloadData()
    }
    
    //Send stock details to detailView.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let selectedIndex: IndexPath = self.tickerTable.indexPath(for: sender as! UITableViewCell)!
            let tickerObj = tickerModel!.getTickerObject(item: selectedIndex.row)
            if let detail: TickerDetailView = segue.destination as? TickerDetailView {
                detail.ticker = tickerObj
            }
        }
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
