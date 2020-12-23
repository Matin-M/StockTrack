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
    lazy var stockPriceLineChart: LineChartView = {
        let chartView = LineChartView()
        //Customize chart.
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
    
    //Datasets.
    let priceData: [ChartDataEntry]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticker?.fetchFinancials = fetchFinancials
        tickerLabel.text = "\(ticker!.companyName ?? " ")(\(ticker!.tickerStr ?? " "))"
        
        //Configure lineChartView.
        lineChartView.addSubview(stockPriceLineChart)
        stockPriceLineChart.centerInSuperview()
        stockPriceLineChart.width(to: lineChartView)
        stockPriceLineChart.height(to: lineChartView)
        
        //Set graph data.
        setPriceData()
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
