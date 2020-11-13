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
    
    private var achievedGoalDetails = List<GoalAchieved>()
    private let realm = try! Realm()
    private var userID: String?
    private let userDefault = UserDefaults.standard
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userID = userDefault.string(forKey: "UserID")
        getData()
    }
    
    private func getData(){
        if let userId = userID {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", userId).first{
                achievedGoalDetails = details.goalAchievedDetails
                tableView.reloadData()
            }
        }

    }
    
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
}


extension GoalAchievedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if achievedGoalDetails.isEmpty {
            tableView.isHidden = true
            noGoalsLBL.isHidden = false
            noGoalsLBL.text = "You have not achieved any goals yet! Try completing one."
        }else{
            tableView.isHidden = false
            noGoalsLBL.isHidden = true
        }
        return achievedGoalDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.achievedTableCellIdentifier, for: indexPath) as! AchievedTableViewCell
        cell.backgroundColor = .clear
        
        let details = achievedGoalDetails[indexPath.row]
        cell.goalName.text = details.goalName
        cell.targetDate.text = ("Target Date: \(details.targetDate)")
        cell.achievedDate.text = ("Achieved Date: \(details.achievedDate)")
        cell.goalTotal.text = ("Goal: \(details.totalGoalAmount)")
        cell.goalIcon.image = UIImage(named: details.goalIcon)
        cell.progress.progress = Float(details.totalGoalAmount)/Float(details.totalGoalAmount)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
 
        let goalDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.AchievedGoalDetailStoryboard) as! AchievedGoalDetailsViewController
        goalDetailVC.goalDetail = achievedGoalDetails[indexPath.row]
        self.navigationController?.pushViewController(goalDetailVC, animated: true)
    }
    
}
