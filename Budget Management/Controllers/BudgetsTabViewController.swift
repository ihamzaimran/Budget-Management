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
    
    
    //XLPagerTabStrip mehtod
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let dateFormatter = DateFormatter()
        let today = Date()
        let currentCalendar = Calendar.current
        let yearComponents: DateComponents? = currentCalendar.dateComponents([.year], from: today)
        let currentYear = Int(yearComponents!.year!)
        
        var childs = [UIViewController]()
        for months in 0..<12 {
            let d = "\(dateFormatter.shortMonthSymbols[months]) \(currentYear)"
            let child1 = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.overAllBudgetStoryboard) as! OverAllBudgetsTabViewController
            child1.childNumber = d
            childs.append(child1)
        }
        
        return childs
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let curMonth = "May 2020"
        if curMonth == "Apr 2020" {
            moveToViewController(at: 3, animated: true)
        } else {
            moveToViewController(at: 11, animated: true)
        }
    }
}

