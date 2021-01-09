//
//  GlobalMarketsView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/7/21.
//

import UIKit
import Charts
import TinyConstraints

class GlobalMarketsView: UIViewController, ChartViewDelegate {

    //Chart sections.
    @IBOutlet weak var USMarket: UIView!
    @IBOutlet weak var AsiaMarket: UIView!
    @IBOutlet weak var EUMarket: UIView!
    
    //Chart containers.
    @IBOutlet weak var USMarketChart: UIView!
    @IBOutlet weak var AsiaMarketChart: UIView!
    @IBOutlet weak var EUMarketChart: UIView!
    
    //Fetch chart API:
    //US
    let fetchDow = FetchFinacialData(ticker: "^DJI")
    let fetchSP = FetchFinacialData(ticker: "^GSPC")
    let fetchNasdaq = FetchFinacialData(ticker: "^IXIC")
    //Asia
    let fetchHSI = FetchFinacialData(ticker: "^HSI")
    let fetchNikkei = FetchFinacialData(ticker: "^N225")
    let fetchSSE = FetchFinacialData(ticker: "000001.SS")
    //Europe
    let fetchFTSE = FetchFinacialData(ticker: "^FCHI")
    let fetchEuro = FetchFinacialData(ticker: "^N100")
    let fetchDAX = FetchFinacialData(ticker: "^GDAXI")
    
    //Charts
    lazy var USChart: LineChartView = {
        return configureChartView()
    }()
    lazy var AsiaChart: LineChartView = {
        return configureChartView()
    }()
    lazy var EUChart: LineChartView = {
        return configureChartView()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        //Configure market sections.
        setBorder(viewToBorder: USMarket)
        setBorder(viewToBorder: AsiaMarket)
        setBorder(viewToBorder: EUMarket)
        
        //Assign charts to containers.
        USMarketChart.backgroundColor = UIColor.clear
        USMarketChart.addSubview(USChart)
        USChart.centerInSuperview()
        USChart.width(to: USMarketChart)
        USChart.height(to: USMarketChart)
        
        AsiaMarketChart.addSubview(AsiaChart)
        AsiaMarketChart.backgroundColor = UIColor.clear
        AsiaChart.centerInSuperview()
        AsiaChart.width(to: AsiaMarketChart)
        AsiaChart.height(to: AsiaMarketChart)
        
        EUMarketChart.addSubview(EUChart)
        EUMarketChart.backgroundColor = UIColor.clear
        EUChart.centerInSuperview()
        EUChart.width(to: EUMarketChart)
        EUChart.height(to: EUMarketChart)
        
        //Assign data.
        let DowData = setPriceData(fetch: fetchDow, color: UIColor.red)
        let SPData = setPriceData(fetch: fetchSP, color: UIColor.green)
        let NasdaqData = setPriceData(fetch: fetchNasdaq, color: UIColor.blue)
        USChart.data = LineChartData(dataSets: [NasdaqData, SPData, DowData])
        USChart.data?.setDrawValues(false)
        
        let HSIData = setPriceData(fetch: fetchHSI, color: UIColor.red)
        let NikkeiData = setPriceData(fetch: fetchNikkei, color: UIColor.green)
        let SSEdData = setPriceData(fetch: fetchSSE, color: UIColor.blue)
        AsiaChart.data = LineChartData(dataSets: [HSIData, NikkeiData, SSEdData])
        AsiaChart.data?.setDrawValues(false)
        
        let FTSEData = setPriceData(fetch: fetchFTSE, color: UIColor.red)
        let EuroData = setPriceData(fetch: fetchEuro, color: UIColor.green)
        let DaxData = setPriceData(fetch: fetchDAX, color: UIColor.blue)
        EUChart.data = LineChartData(dataSets: [FTSEData, EuroData, DaxData])
        EUChart.data?.setDrawValues(false)
        
    }
    
    func setBorder(viewToBorder: UIView) -> Void{
        viewToBorder.backgroundColor = UIColor.clear
        viewToBorder.frame = CGRect(x: viewToBorder.frame.origin.x, y: viewToBorder.frame.origin.y, width: viewToBorder.frame.width, height: viewToBorder.frame.height)
        viewToBorder.layer.cornerRadius = 12.5
        viewToBorder.layer.borderWidth = 2.5
        viewToBorder.layer.borderColor =  UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.5).cgColor
    }
    
    func configureChartView() -> LineChartView{
        let chartView: LineChartView = LineChartView()
        chartView.backgroundColor = UIColor.clear
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
        chartView.drawBordersEnabled = false
        chartView.setScaleEnabled(true)
        return chartView
    }
    
    func setPriceData(fetch: FetchFinacialData, color: UIColor) -> LineChartDataSet{
        //Populate dataset.
        fetch.retrievedChart = ""
        fetch.fetchStockChart(interval: "1d", range: "3mo")
        var min: Double = 0
        var max: Double = 0
        var priceData: [ChartDataEntry] = []
        let chartData: (x: [Double],y: [Double]) = fetch.getChartData()!
        min = chartData.y.min()!
        max = chartData.y.max()!
        for(x, y) in zip(chartData.x, chartData.y){
            let normalized: Double = (y-min)/(max-min)
            priceData.append(ChartDataEntry(x: x, y: normalized))
        }
        let dataSet = LineChartDataSet(entries: priceData, label: fetch.ticker!)
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(color)
        dataSet.drawFilledEnabled = false
        print(dataSet)
        return dataSet
    }
    
    
}
