//
//  SavingsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import SideMenu
import XLPagerTabStrip

class SavingsViewController: UIViewController, IndicatorInfoProvider {

    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }

}

