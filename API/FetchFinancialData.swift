//
//  FetchFinancialData.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/12/20.
//

import Foundation

class FetchFinacialData{
    
    //Delegate.
    var delegate: APIErrorDelegate?
    
    //Retrieved data.
    var retrievedData: String?
    var retrievedDetails: String?
    var retrievedChart: String?
    
    //API key and headers.
    let API_KEY: String = "d1207125c7msh17c2c423fd6eb41p12ce5ajsna5cdc9a75064"
    var headers: [String:String]
    var ticker: String?
    
    //Database selector.
    enum Databases: CaseIterable {
        case data, details, chart
    }
    
    //Init using ticker symbol.
    init(ticker: String){
        self.retrievedData = ""
        self.retrievedDetails = ""
        self.retrievedChart = ""
        self.ticker = ticker
        headers = [
            "x-rapidapi-key": API_KEY,
            "x-rapidapi-host": "yahoo-finance-low-latency.p.rapidapi.com"]
    }
    
    //Parse JSON data. NOTE: retrievedData is not JSON compliant.
    func getQuoteData(toFind: String) -> String? {
        let str = retrievedData!
        var index: Int = 0

        if let range: Range<String.Index> = str.range(of: toFind) {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
            print("index: ", index)
        }
        else {
            return nil
        }

        var i = index+toFind.count+2
        var result: String = ""

        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                break
            }else{
                result.append(str[offset])
            }
            i+=1
        }

        print(result)
        
        return extractData(data: Databases.data, toFind: toFind, delimiter: ",", skipAmnt: 2)
    }
    
    func extractData(data dataToParse: Databases, toFind: String, delimiter: Character, skipAmnt: Int) -> String?{
        var str = ""
        switch dataToParse {
        case .data:
            str = retrievedData!
        case .details:
            str = retrievedDetails!
        case .chart:
            str = retrievedChart!
        }
        
        var index: Int = 0
        if let range: Range<String.Index> = str.range(of: toFind) {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
            print("index: ", index)
        }
        else {
            return nil
        }

        var i = index+toFind.count+skipAmnt
        var result: String = ""

        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == delimiter){
                break
            }else{
                result.append(str[offset])
            }
            i+=1
        }

        print(result)
        
        return result
    }
    
    func getChartData() -> (x: [Double],y: [Double])?{
        let str = retrievedChart!
        var index: Int = 0

        //Find timestamps.
        if let range: Range<String.Index> = str.range(of: "timestamp") {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
            print("index: ", index)
        }
        else {
            return nil
        }

        var i = index+12
        var result: String = ""
        var count: Int = 0
        var timeStamps: [Double] = []
        
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                count += 1
                timeStamps.append(Double(result)!)
                result = ""
            }else{
                result.append(str[offset])
            }
            i+=1
            if(str[offset] == "]"){
                break
            }
        }
        
        //Find price values.
        if let range: Range<String.Index> = str.range(of: "high") {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
            print("index: ", index)
        }
        else {
            return nil
        }
        
        i = index+7
        result = ""
        count = 0
        var values: [Double] = []
        
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                count += 1
                values.append(Double(result)!)
                result = ""
            }else{
                result.append(str[offset])
            }
            i+=1
            if(str[offset] == "]"){
                break
            }
        }

        return (timeStamps,values)
    }
 
    
    func fetchStockQuote() -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v6/finance/quote?symbols=\(ticker!)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        retrievedData = requestData(request: request)
    }
    
    func fetchStockDetails() -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v11/finance/quoteSummary/\(ticker!)?modules=defaultKeyStatistics%2CassetProfile%2CsummaryDetail%2CcashflowStatementHistory%2CsecFilings%2CrecommendationTrend%2Cearnings%2CearningsTrend%2C%2CesgScores%2CcalendarEvents&region=US&lang=en")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        retrievedDetails = requestData(request: request)
    }
    
    func fetchStockChart(interval: String, range: String) -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v8/finance/chart/\(ticker!)?interval=\(interval)&range=\(range)&region=US&lang=en")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        retrievedChart = requestData(request: request)
    }
    
    //Make a RESTful API request to yahoo finance.
    func requestData(request: NSMutableURLRequest) -> String {

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let sem = DispatchSemaphore(value: 0)
        
        var jsonData: String = " "
        
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
                
                //Check response MIME adherance to JSON.
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                
                //Deserialize JSON object: NOT WORKING
                //jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                   jsonData = dataString
                }
            }
            //Signal semaphore.
            sem.signal()
        })

        dataTask.resume()
        sem.wait()
        return jsonData
    }
    
    //MARK: - HTTP Request error handlers.
    
    func handleClientError(error: Optional<Any>) -> Void{
        print("A client error occurred!")
        delegate?.clientError()
    }
    
    func handleServerError(response: HTTPURLResponse) -> Void{
        //Caused when number of API requests exceeds daily quota.
        print("A server error occurred!")
        delegate?.serverError()
    }
    
}
