//
//  TickerDetailView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/11/20.
//

import UIKit
import Charts
import TinyConstraints

class TickerDetailView: UIViewController {
    
    var fetchFinancials: FetchFinacialData!
    var ticker: TickerLocal?

    //UIKit elements.
    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    lazy var stockPriceLineChart: LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticker?.fetchFinancials = fetchFinancials
        tickerLabel.text = "\(ticker!.companyName ?? " ")(\(ticker!.tickerStr ?? " "))"
        
        //Configure lineChartView.
        lineChartView.addSubview(stockPriceLineChart)
        stockPriceLineChart.centerInSuperview()
        stockPriceLineChart.width(to: lineChartView)
        stockPriceLineChart.height(to: lineChartView)
    }
    
    @IBAction func refresh(_ sender: Any) {
        
    }
    
}
