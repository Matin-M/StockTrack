//
//  TickerDetailView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/11/20.
//

import UIKit
import Charts
import TinyConstraints

class TickerDetailView: UIViewController, ChartViewDelegate {
    
    
    //API and CoreData objects.
    var fetchFinancials: FetchFinacialData!
    var ticker: TickerLocal?

    //UIViews.
    @IBOutlet weak var rangeSelector: UISegmentedControl!
    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var earningsView: UIView!
    @IBOutlet weak var earningsBarChartView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var statsView: UIView!
    
    //Graphs.
    lazy var stockPriceLineChart: LineChartView = {
        let chartView = LineChartView()
        //Set chart properties.
        chartView.backgroundColor = .systemGray
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: CGFloat(10))
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: CGFloat(5))
        chartView.xAxis.setLabelCount(5, force: false)
        chartView.xAxis.axisLineColor = .white
        chartView.animate(xAxisDuration: 2)
        return chartView
    }()
    
    //Stats labels.
    @IBOutlet weak var eps: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var bid: UILabel!
    @IBOutlet weak var ask: UILabel!
    @IBOutlet weak var earningsDate: UILabel!
    @IBOutlet weak var beta: UILabel!
    @IBOutlet weak var divYield: UILabel!
    @IBOutlet weak var sector: UILabel!
    @IBOutlet weak var splitFactor: UILabel!
    @IBOutlet weak var splitDate: UILabel!
    @IBOutlet weak var profitMargins: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var forwardPE: UILabel!
    @IBOutlet weak var trailingPE: UILabel!
    
    //Datasets.
    var priceData: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFinancials = ticker?.fetchFinancials
        tickerLabel.text = "\(ticker!.companyName ?? " ")(\(ticker!.tickerStr ?? " "))"
        
        //Configure lineChartView.
        lineChartView.frame = CGRect(x: lineChartView.frame.origin.x, y: lineChartView.frame.origin.y, width: lineChartView.frame.width, height: lineChartView.frame.height)
        lineChartView.layer.cornerRadius = 8
        lineChartView.backgroundColor = .gray
        lineChartView.addSubview(stockPriceLineChart)
        stockPriceLineChart.centerInSuperview()
        stockPriceLineChart.width(to: lineChartView)
        stockPriceLineChart.height(to: lineChartView)
        
        //Make call to API.
        if(fetchFinancials.retrievedData != ""){
            fetchFinancials.fetchStockChart(interval: "5m", range: "1d")
            setPriceData()
        }else{
            print("Please update!")
        }
        
        //Configure stats view.
        statsView.backgroundColor = .gray
        statsView.frame = CGRect(x: statsView.frame.origin.x, y: statsView.frame.origin.y, width: statsView.frame.width, height: statsView.frame.height)
        statsView.layer.cornerRadius = 8
        
        //Configure earningsView.
        earningsView.backgroundColor = .gray
        earningsView.frame = CGRect(x: earningsView.frame.origin.x, y: earningsView.frame.origin.y, width: earningsView.frame.width, height: earningsView.frame.height)
        earningsView.layer.cornerRadius = 8
        earningsBarChartView.backgroundColor = UIColor.gray
        
        //Configure barChart.
        
        //Set values for stats.
        setStats()
    }
    
    func setStats() -> Void{
        fetchFinancials.fetchStockDetails()
        //Debug
        eps.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "trailingEps", delimiter: "\"", skipAmnt: 23)
        range.text =  "$\(fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "fiftyTwoWeekLow", delimiter: ",", skipAmnt: 9)!) - $\(fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "fiftyTwoWeekHigh", delimiter: ",", skipAmnt: 9)!)"
        bid.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "bid", delimiter: ",", skipAmnt: 9)
        ask.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "ask", delimiter: ",", skipAmnt: 9)
        earningsDate.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "earningsDate", delimiter: "\"", skipAmnt: 28)
        beta.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "beta", delimiter: "\"", skipAmnt: 25)
        if(fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "dividendYield", delimiter: "\"", skipAmnt: 3) != ""){
            divYield.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "dividentYield", delimiter: "\"", skipAmnt: 3)
        }else{
            divYield.text = "N/A"
        }
        sector.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "sector", delimiter: "\"", skipAmnt: 3)
        splitFactor.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "lastSplitFactor", delimiter: "\"", skipAmnt: 3)
        splitDate.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "lastSplitDate", delimiter: "\"", skipAmnt: 27)
        profitMargins.text = fetchFinancials.extractData(data: FetchFinacialData.Databases.details, toFind: "profitMargins", delimiter: "\"", skipAmnt: 25)
        marketCap.text = fetchFinancials.getQuoteData(toFind: "marketCap")
        forwardPE.text = fetchFinancials.getQuoteData(toFind: "forwardPE")
        trailingPE.text = fetchFinancials.getQuoteData(toFind: "trailingPE")
    }
    
    func setPriceData() -> Void{
        //Populate dataset.
        let chartData: (x: [Double],y: [Double]) = fetchFinancials.getChartData()!
        for(x, y) in zip(chartData.x, chartData.y){
            priceData.append(ChartDataEntry(x: x, y: y))
        }
        let dataSet = LineChartDataSet(entries: priceData, label: "Price history")
        
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(.white)
        dataSet.fill = Fill(color: .white)
        dataSet.fillAlpha = 0.3
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        stockPriceLineChart.data = data
    }
    
    @IBAction func refresh(_ sender: Any) {
        setStats()
    }
    
    @IBAction func rangeAction(_ sender: Any) {
        priceData.removeAll()
        let range: String = rangeSelector.titleForSegment(at: rangeSelector.selectedSegmentIndex)!
        fetchFinancials.retrievedChart = ""
        if(range == "1 Day"){
            fetchFinancials.fetchStockChart(interval: "5m", range: "1d")
        }else if(range == "5 Day"){
            fetchFinancials.fetchStockChart(interval: "1d", range: "1wk")
        }else if(range == "3 Month"){
            fetchFinancials.fetchStockChart(interval: "1d", range: "3mo")
        }else{
            fetchFinancials.fetchStockChart(interval: "1wk", range: "ytd")
        }
        setPriceData()
        stockPriceLineChart.notifyDataSetChanged()
        print(range)
    }
    
    //MARK: - Chart Protocols
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
}
