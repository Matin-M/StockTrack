//
//  MenuTableViewTableViewController.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/28/20.
//

import UIKit

class MenuTableView: UITableViewController {
    
    var menuItems: [String]!
    public var delegate: MenuControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = ["Settings","About","Usage"]
        tableView.backgroundColor = UIColor.gray
        tableView.tintColor = UIColor.gray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.gray
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }


}
