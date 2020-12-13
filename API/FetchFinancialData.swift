//
//  FetchFinancialData.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/12/20.
//

import Foundation

class FetchFinacialData{
    
    var retrievedJSON: Any?
    var API_KEY: String = "d1207125c7msh17c2c423fd6eb41p12ce5ajsna5cdc9a75064"
    let headers: [String:String]
    
    init(){
        headers = [
            "x-rapidapi-key": API_KEY,
            "x-rapidapi-host": "yahoo-finance-low-latency.p.rapidapi.com"]
    }
    
    func getRetrievedJSON() -> Any? { return retrievedJSON }
    
    func fetchStockQuote(ticker: String) -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v6/finance/quote?symbols=TSLA")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        requestData(request: request)
    }
    
    func fetchStockDetails(ticker: String) -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v11/finance/quoteSummary/AAPL?modules=defaultKeyStatistics%2CassetProfile%2C%20earningsHistory%2C%20recommendationTrend%2C%20esgScores")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        requestData(request: request)
    }
    
    
    func fetchStockChart(ticker: String) -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v8/finance/chart/AAPL?comparisons=MSFT%2C%5EVIX")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        requestData(request: request)
    }
    
    func requestData(request: NSMutableURLRequest) -> Void {

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let sem = DispatchSemaphore(value: 0)
        
        var jsonData: Any = ""
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Error fetching data")
            } else {
                //Check error flag.
                if error != nil {
                    self.handleClientError(error: error)
                    return
                }
                
                //Validate httpResponse feedback.
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response: response! as! HTTPURLResponse)
                    return
                }
                
                //Check response MIME adherance to json.
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                
                //Deserialize JSON object
                jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
            }
            //Signal semaphore.
            sem.signal()
        })

        dataTask.resume()
        sem.wait()
        retrievedJSON = jsonData
    }
    
    //MARK: - HTTP Request error handlers.
    
    func handleClientError(error: Optional<Any>) -> Void{
        
    }
    
    func handleServerError(response: HTTPURLResponse) -> Void{
        
    }
    
}
