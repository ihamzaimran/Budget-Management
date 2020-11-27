//
//  BudgetViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit

class BudgetViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backIcon(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
