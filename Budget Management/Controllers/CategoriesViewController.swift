//
//  CategoriesViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import XLPagerTabStrip

class CategoriesViewController: ButtonBarPagerTabStripViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        
        setupXLPagerStrip()
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //XLPagerTabStripMethod
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.expense) as! ExpenseViewController
        child1.childNumber = "EXPENSE"
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.income) as! IncomeViewController
        child2.childNumber = "INCOME"

        
        return [child1, child2]
    }
}

