//
//  UsageView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/1/21.
//

import UIKit

class UsageView: UIViewController {
    
    //UI Elements.
    @IBOutlet weak var totalRequests: UILabel!
    @IBOutlet private weak var chartRequests: UILabel!
    @IBOutlet private weak var detailRequests: UILabel!
    @IBOutlet private weak var quoteRequests: UILabel!
    
    enum stat{
        case total
        case chart
        case detail
        case quote
    }
    
    //Usage trackers.
    var total: Int = 0
    var chart: Int = 0
    var detail: Int = 0
    var quote: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setStats()
        
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setStats() -> Void {
        totalRequests.text = String(total)
        chartRequests.text = String(chart)
        detailRequests.text = String(detail)
        quoteRequests.text = String(quote)
    }
    
    func incrementStat(whichStat: stat, inc: Int) -> Void{
        if whichStat == stat.total{
            total += inc
        }else if whichStat == stat.chart{
            chart += inc
        }else if whichStat == stat.detail{
            detail += inc
        }else{
            quote += inc
        }
    }
    

}
