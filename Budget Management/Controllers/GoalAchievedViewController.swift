//
//  GoalAchievedViewController.swift
//  Budget Management
//
//  Created by Intern on 26/10/2020.
//

import UIKit
import XLPagerTabStrip

class GoalAchievedViewController: UIViewController, IndicatorInfoProvider {
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
}
