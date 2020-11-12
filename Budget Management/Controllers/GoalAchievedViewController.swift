//
//  GoalAchievedViewController.swift
//  Budget Management
//
//  Created by Intern on 26/10/2020.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class GoalAchievedViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGoalsLBL: UILabel!
    
    private var goalDetails = List <GoalDetails>()
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
}


extension GoalAchievedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if goalDetails.isEmpty {
            tableView.isHidden = true
            noGoalsLBL.isHidden = false
            noGoalsLBL.text = "You have not achieved any goals yet! Try completing one."
        }else{
            tableView.isHidden = false
            noGoalsLBL.isHidden = true
        }
        return goalDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.achievedTableCellIdentifier, for: indexPath) as! AchievedTableViewCell
        cell.backgroundColor = .clear
        
        let details = goalDetails[indexPath.row]
        cell.goalName.text = details.goalName
        cell.goalSaved.text = ("Saved: \(details.savedAmount)")
        cell.goalTotal.text = ("Total: \(details.totalGoalAmount)")
        cell.goalIcon.image = UIImage(named: details.goalIcon)
        
        if let total = Float(details.totalGoalAmount) {
            cell.progress.progress = Float(details.savedAmount)/total
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let goalDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.goalDetails) as! GoaldetailsViewController
        goalDetailVC.selectedGoal = goalDetails[indexPath.row]
        
        self.navigationController?.pushViewController(goalDetailVC, animated: true)
    }
    
}
