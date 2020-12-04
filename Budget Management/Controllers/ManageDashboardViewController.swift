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
    
    private var overviewState = false
    private var accountsState = false
    private var lastRecordsState = false
    private let userDefault = UserDefaults.standard
    private var overview:Bool?
    private var accounts:Bool?
    private var lastRecords:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overview = userDefault.bool(forKey: Constants.Text.overViewSwitch)
        accounts = userDefault.bool(forKey: Constants.Text.accountsSwitch)
        lastRecords =  userDefault.bool(forKey: Constants.Text.lastRecordsSwitch)
        
        setSwitchesState()
    }
    
    
    //turning on/off switches depending upon the saved state from userDefaults
    private func setSwitchesState(){
        
        if let overview = overview {
            overViewSwitch.setOn(overview, animated: true)
            overviewState = overview
        }
        
        if let accounts = accounts {
            accountsSwitch.setOn(accounts, animated: true)
            accountsState = accounts
        }
        if let lastRecords = lastRecords {
            lastRecordsSwitch.setOn(lastRecords, animated: true)
            lastRecordsState = lastRecords
        }
    }
    
    @IBAction func backIcon(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switches(_ sender: UISwitch) {
        
        if sender == overViewSwitch {
            if sender.isOn {
                sender.setOn(true, animated: true)
                overviewState = true
            } else {
                sender.setOn(false, animated: true)
                overviewState = false
            }
            userDefault.set(overviewState, forKey: Constants.Text.overViewSwitch)
        } else if sender == accountsSwitch {
            if sender.isOn {
                sender.setOn(true, animated: true)
                accountsState = true
            } else {
                sender.setOn(false, animated: true)
                accountsState = false
            }
            userDefault.set(accountsState, forKey: Constants.Text.accountsSwitch)
        } else if sender == lastRecordsSwitch {
            if sender.isOn {
                sender.setOn(true, animated: true)
                lastRecordsState = true
            } else {
                sender.setOn(false, animated: true)
                lastRecordsState = false
            }
            userDefault.set(lastRecordsState, forKey: Constants.Text.lastRecordsSwitch)
        }
        
        userDefault.synchronize()
    }
}
