//
//  AllActivityViewController.swift
//  Budget Management
//
//  Created by Intern on 01/12/2020.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class AllActivityViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    var childNumber: String = ""
    private var transactions: Results<GoalTransactions>?
    private let realm = try! Realm()
    private let userDefault = UserDefaults.standard
    private var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
        let nib = UINib(nibName: "ActivitiesHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "ActivitiesHeaderView")
        
        let footerNib = UINib(nibName: "ActivitiesFooterView", bundle: nil)
        tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "ActivitiesFooterView")
        
        userID = userDefault.string(forKey: "UserID")
        getDetails()
    }
    
    
    private func getDetails() {
        
        if userID != nil {
            transactions = self.realm.objects(GoalTransactions.self)
            if transactions != nil {
                tableView.reloadData()
            }
        }
    }
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
}


//MARK:- extension tableview

extension AllActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.activitiesTableCell, for: indexPath) as! ActivitiesTransactionsTableViewCell
        cell.backgroundColor = .clear
        
        if let index = transactions?[indexPath.row] {
            cell.amountLBL.text = "\(index.amount)"
            cell.goalNameLBL.text = index.goalName
            cell.descLBL.text = index.goalDescription
            cell.dateLBL.text = index.date
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    //tableview header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivitiesHeaderView") as! ActivitiesHeaderView
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivitiesFooterView") as! ActivitiesFooterView
        return footer
    }
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //
    //        let header = view as! ActivitiesHeaderView
    //
    //    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! ActivitiesFooterView
        if let total = transactions?.count {
            footer.totalTransactions.text = "Total Transactions = \(total)"
        } else {
            footer.totalTransactions.text = "Total Transactions = 0"
        }
        
    }
}
