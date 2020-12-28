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
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tickerCellViewMaster: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickerCellViewMaster.backgroundColor = UIColor.clear
        cellView.frame = CGRect(x: cellView.frame.origin.x, y: cellView.frame.origin.y, width: cellView.frame.width, height: cellView.frame.height)
        cellView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
