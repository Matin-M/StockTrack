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

    //UIKit elements.
    @IBOutlet weak var rangeSelector: UISegmentedControl!
    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var statsView: UIView!
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
        chartView.animate(xAxisDuration: 1)
        //chartView.animate(yAxisDuration: 1)
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
    let priceData: [ChartDataEntry]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFinancials = ticker?.fetchFinancials
        tickerLabel.text = "\(ticker!.companyName ?? " ")(\(ticker!.tickerStr ?? " "))"
        
        //Configure lineChartView.
        lineChartView.addSubview(stockPriceLineChart)
        stockPriceLineChart.centerInSuperview()
        stockPriceLineChart.width(to: lineChartView)
        stockPriceLineChart.height(to: lineChartView)
        
        //Make call to API.
        fetchFinancials.fetchStockChart(interval: "5m", range: "1d")
        print(fetchFinancials.getChartData()!.x)
        print(fetchFinancials.getChartData()!.y)
        
        //Set graph data.
        //setPriceData()
        
        //Configure stats view.
        statsView.backgroundColor = .gray
        statsView.frame = CGRect(x: statsView.frame.origin.x, y: statsView.frame.origin.y, width: statsView.frame.width, height: statsView.frame.height)
        statsView.layer.cornerRadius = 8
        
    }
    
    func setPriceData() -> Void{
        let dataSet = LineChartDataSet(entries: priceData!, label: "Price history")
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
        
    }
    
    @IBAction func rangeAction(_ sender: Any) {
        
    }
    
    //MARK: - Chart Protocols
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
}
