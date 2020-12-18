//
//  TickerDetailView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/11/20.
//

import UIKit

class TickerDetailView: UIViewController {
    
    var fetchFinancials: FetchFinacialData!
    var ticker: TickerLocal?

    //UIKit elements.
    @IBOutlet weak var tickerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticker?.fetchFinancials = fetchFinancials
        tickerLabel.text = "\(ticker!.companyName ?? " ")(\(ticker!.tickerStr ?? " "))"
    }
    
    @IBAction func refresh(_ sender: Any) {
        
    }
    
}
