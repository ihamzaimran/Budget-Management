//
//  ManageDashboardViewController.swift
//  Budget Management
//
//  Created by Intern on 26/11/2020.
//

import UIKit

class ManageDashboardViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backIcon(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
