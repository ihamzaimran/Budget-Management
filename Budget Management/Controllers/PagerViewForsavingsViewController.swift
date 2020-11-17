//
//  PagerViewForsavingsViewController.swift
//  Budget Management
//
//  Created by Intern on 26/10/2020.
//

import UIKit
import XLPagerTabStrip
import SideMenu

class PagerViewForsavingsViewController: ButtonBarPagerTabStripViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Savings", image: UIImage(named: Constants.Images.savingsTab), tag: 3)
    }
    
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
