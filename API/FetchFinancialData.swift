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
    let API_KEY: String = "REDACTED"
    var headers: [String:String]
    var ticker: String?
    
    //Database selector.
    enum Databases: CaseIterable {
        case data, details, chart
    }
    
    //API Errors.
    enum NetworkError: Error {
        case ServerError
        case ClientError
        case OtherError
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
        
        return result
    }
    
    func getChartData() -> (x: [Double], y: [Double])?{
        let str = retrievedChart!
        var index: Int = 0

        //Find timestamps.
        if let range: Range<String.Index> = str.range(of: "timestamp") {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
        }
        else {
            return nil
        }

        var i = index+12
        var result: String = ""
        var timeStamps: [Double] = []
        
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                timeStamps.append(Double(result) ?? 0.0)
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
        if let range: Range<String.Index> = str.range(of: "open") {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
        }
        else {
            return nil
        }
        
        i = index+7
        result = ""
        var values: [Double] = []
        
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                values.append(Double(result) ?? 0.0)
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
    
    func getEarningsData() -> (actual: [Double], expected: [Double])?{
        let str = retrievedDetails!
        var index: Int = 0

        //Find timestamps.
        if let range: Range<String.Index> = str.range(of: "earningsChart") {
            index = str.distance(from: str.startIndex, to: range.lowerBound)
        }
        else {
            return nil
        }
        
        print(index)
        
        var i = index+62
        var result: String = ""
        var count = 0
        var actual: [Double] = []
        //Parse Data.
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                actual.append(Double(result) ?? 0.0)
                result = ""
                i += 86
                count += 1
            }else{
                result.append(str[offset])
                i+=1
            }
            if(count == 4){
                break
            }
        }
        
        i = index+99
        result = ""
        count = 0
        var expected: [Double] = []
        //Parse Data.
        while(true){
            let offset = str.index(str.startIndex, offsetBy: i)
            if(str[offset] == ","){
                expected.append(Double(result) ?? 0.0)
                result = ""
                i += 86
                count += 1
            }else{
                result.append(str[offset])
                i+=1
            }
            if(count == 4){
                break
            }
        }
        return (actual,expected)
    }
 
    
    func fetchStockQuote() -> Void {
        let encodedRequest: String = ticker!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v6/finance/quote?symbols=\(encodedRequest)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        retrievedData = requestData(request: request)
    }
    
    func fetchStockDetails() -> Void {
        let encodedRequest: String = ticker!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v11/finance/quoteSummary/\(encodedRequest)?modules=defaultKeyStatistics%2CassetProfile%2CsummaryDetail%2CcashflowStatementHistory%2CsecFilings%2CrecommendationTrend%2Cearnings%2CearningsTrend%2C%2CesgScores%2CcalendarEvents&region=US&lang=en")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        retrievedDetails = requestData(request: request)
    }
    
    func fetchStockChart(interval: String, range: String) -> Void {
        let encodedRequest: String = ticker!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let request = NSMutableURLRequest(url: NSURL(string: "https://yahoo-finance-low-latency.p.rapidapi.com/v8/finance/chart/\(encodedRequest)?interval=\(interval)&range=\(range)&region=US&lang=en")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
                //Handle any errors.
                do{
                    //Check error flag.
                    if error != nil {
                        throw NetworkError.ClientError
                    }
                    
                    //Validate httpResponse feedback.
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.ServerError
                    }
                    
                    //Check response MIME adherance to JSON.
                    guard let mime = response?.mimeType, mime == "application/json" else {
                        print("Wrong MIME type!")
                        throw NetworkError.OtherError
                    }
                    
                    //Deserialize JSON object: NOT WORKING
                    //jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       jsonData = dataString
                        }

                }catch NetworkError.ClientError{
                    self.handleClientError(error: error)
                }catch NetworkError.ServerError{
                    self.handleServerError(response: response! as! HTTPURLResponse)
                }catch NetworkError.OtherError{
                    print("Other error occurred!")
                }catch{
                    
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
        DispatchQueue.main.async{
            self.delegate?.clientError()
        }
        
    }
    
    func handleServerError(response: HTTPURLResponse) -> Void{
        print("A server error occurred!")
        DispatchQueue.main.async{
            self.delegate?.serverError()
        }
    }
    
}
