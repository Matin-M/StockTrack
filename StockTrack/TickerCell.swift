//
//  TickerCell.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import UIKit

class TickerCell: UITableViewCell {
    
    //FetchObj.
    var fetchFinancials: FetchFinacialData!
    //UIKit Views.
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    @IBOutlet weak var afterHoursChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
