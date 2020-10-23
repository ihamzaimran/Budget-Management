//
//  BudgetsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import SideMenu

class BudgetsTabViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(named: Constants.Images.budgetTab), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


