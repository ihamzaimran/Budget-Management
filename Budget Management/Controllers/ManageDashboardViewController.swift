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
    
    @IBOutlet weak var overViewSwitch: UISwitch!
    @IBOutlet weak var accountsSwitch: UISwitch!
    @IBOutlet weak var lastRecordsSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backIcon(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switches(_ sender: UISwitch) {
    }
}
