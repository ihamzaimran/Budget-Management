//
//  AccountsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var balanceLBL: UILabel!
    @IBOutlet weak var currencyLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .clear
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- extension tableview delegate

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource, GetDropDownCellNumDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.accountBalanceIdentifierCell, for: indexPath) as! AccountBalanceTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func didTapDropdownIcon(cell: AccountBalanceTableViewCell) {
        guard let cell = self.tableView.indexPath(for: cell) else{fatalError("error getting index path")}
        print("row  = \(cell.row)")
    }
}
