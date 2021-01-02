//
//  UsageView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/1/21.
//

import UIKit

class UsageView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
