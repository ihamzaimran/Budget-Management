//
//  BudgetsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import XLPagerTabStrip

class BudgetsTabViewController: ButtonBarPagerTabStripViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(named: Constants.Images.budgetTab), tag: 1)
    }
    
    override func viewDidLoad() {
    
        setupXLPagerStrip()
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.expense) as! ExpenseViewController
        child1.childNumber = "EXPENSE"
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.income) as! IncomeViewController
        child2.childNumber = "INCOME"
        
        return [child1, child2]
    }
}

