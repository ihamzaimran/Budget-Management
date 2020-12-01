//
//  ActivitiesPagerControllerViewController.swift
//  Budget Management
//
//  Created by Intern on 01/12/2020.
//

import UIKit
import XLPagerTabStrip

class ActivitiesPagerControllerViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        setupXLPagerStrip()
        
        super.viewDidLoad()
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.savings) as! SavingsViewController
        child1.childNumber = "RUNNING"
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.goalAchieved) as! GoalAchievedViewController
        child2.childNumber = "ACHIEVED"
        
        
        return [child1, child2]
    }
}
