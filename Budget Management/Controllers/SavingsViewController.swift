//
//  SavingsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import SideMenu
import XLPagerTabStrip
import RealmSwift

class SavingsViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addGoalBtn: UIButton!
    @IBOutlet weak var noGoalsLBL: UILabel!
    
    var childNumber: String = ""
    private var goalDetails = List<GoalDetails>()
    private let realm = try! Realm()
    private var userID: String?
    private let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userID = userDefault.string(forKey: "UserID")
        getData()
    }
    
    @IBAction func addGoalButton(_ sender: UIButton) {
        print("function called!")
        let addGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addGoal) as! AddGoalViewController
        self.navigationController?.pushViewController(addGoalVC, animated: true)
    }
    
    //get data from realm
    private func getData(){
        if let userId = userID {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", userId).first{
                goalDetails = details.goalDetails
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
}

extension SavingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if goalDetails.isEmpty {
            tableView.isHidden = true
            noGoalsLBL.isHidden = false
        }else{
            tableView.isHidden = false
            noGoalsLBL.isHidden = true
        }
        return goalDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.savingsCellIdentifier, for: indexPath) as! SavingsTableViewCell
        cell.backgroundColor = .clear
        cell.savingsView.layer.cornerRadius = 5
        
        let details = goalDetails[indexPath.row]
        cell.goalName.text = details.goalName
        cell.goalSaved.text = ("Saved: \(details.savedAmount)")
        cell.totalGoal.text = ("Total: \(details.totalGoalAmount)")
        cell.goalIcon.image = UIImage(named: details.goalIcon)
        
         let total = Float(details.totalGoalAmount)
         cell.goalProgress.progress = Float(details.savedAmount)/total
        
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
