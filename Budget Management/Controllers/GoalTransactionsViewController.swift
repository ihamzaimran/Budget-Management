//
//  GoalTransactionsViewController.swift
//  Budget Management
//
//  Created by Intern on 12/11/2020.
//

import UIKit
import RealmSwift

class GoalTransactionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noListLBL: UILabel!
    
    internal var selectedGoalTransactions: GoalDetails?
    private var transactionsList = List<GoalTransactions>()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
        getData()
    }
    
    private func getData(){
        if let selectedTransaction = selectedGoalTransactions {
            transactionsList = selectedTransaction.goalTransactions
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- extension tableview delegate

extension GoalTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactionsList.isEmpty{
            tableView.isHidden = true
            noListLBL.isHidden = false
            noListLBL.text = "You've no savings yet!"
        } else {
            tableView.isHidden = false
            noListLBL.isHidden = true
        }
        
        return transactionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.goalTransactionsCellIdentifer, for: indexPath) as! GoalTransactionsTableViewCell
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 5
        let transactions = transactionsList[indexPath.row]

        cell.amountLBL.text = ("\(transactions.amount)")
        cell.currencyLBL.text = "PKR"
        cell.dateLBL.text = "\(transactions.date)"
        cell.descriptionLBL.text = "\(transactions.goalDescription)"
        cell.nameLBL.text = "\(transactions.goalName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
