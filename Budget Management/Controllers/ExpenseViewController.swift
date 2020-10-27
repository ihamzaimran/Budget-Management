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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXPENSE")
    }
}
