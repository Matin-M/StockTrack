//
//  TickerCell.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/9/20.
//

import UIKit

class TickerCell: UITableViewCell {
    
    var tickerObject: TickerLocal?
    
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
