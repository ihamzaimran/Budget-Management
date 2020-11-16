//
//  ExpenseViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import XLPagerTabStrip

class ExpenseViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.backgroundColor = .white
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
}
