//
//  SavingsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import SideMenu
import XLPagerTabStrip

class SavingsViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    @IBAction func addGoalButton(_ sender: UIButton) {
        let addGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addGoal) as! AddGoalViewController
        self.navigationController?.pushViewController(addGoalVC, animated: true)
    }
    
    
    //get data from realm
    
    private func getData(){
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
}

extension SavingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.savingsCellIdentifier, for: indexPath) as! SavingsTableViewCell
        cell.backgroundColor = .clear
        cell.savingsView.layer.cornerRadius = 5
//        cell.goalName = "Home"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
