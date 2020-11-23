//
//  CustomTableViewController.swift
//  AppInfraMicroApp
//
//  Created by philips on 12/4/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS


@objc public protocol TableViewControlDelegate : NSObjectProtocol {
    func updateControl( _ selectedOption : Int )
}


@objc public class CustomTableViewController: UITableViewController {

    @objc public var delegate : TableViewControlDelegate?
    @objc public var dataSource : [String]? = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var previousIndexPath : IndexPath?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableFooterView  = UIView()
        self.tableView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
    }

    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource!.count
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataTableView", for: indexPath)
        cell.textLabel?.text = dataSource?[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        if previousIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (previousIndexPath != nil )
        {
            let cell = tableView.cellForRow(at: previousIndexPath!)
            cell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        previousIndexPath = indexPath
        delegate?.updateControl(indexPath.row)
        navigationController?.popViewController(animated:true)
    }
}
