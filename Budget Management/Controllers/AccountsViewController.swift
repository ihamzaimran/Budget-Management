//
//  AccountsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import DropDown
import RealmSwift

class AccountsViewController: UIViewController {
    
    @IBOutlet weak var balanceLBL: UILabel!
    @IBOutlet weak var currencyLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noAccountLBL: UILabel!
    
    private let dropDown = DropDown()
    private let realm = try! Realm()
    private var accountDetails = List<AccountDetails>()
    private var userID: String?
    private let userDefault = UserDefaults.standard
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userID = userDefault.string(forKey: "UserID")
        getData()
    }
    
    private func getData(){
        if let userId = userID {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", userId).first{
                accountDetails = details.accountDetails
                
                if details.totalBalance < 0 {
                    balanceLBL.textColor = .systemRed
                    balanceLBL.text = ("\(details.totalBalance)")
                } else {
                    balanceLBL.textColor = UIColor(named: "PrimaryColor")
                    balanceLBL.text = ("\(details.totalBalance)")
                }
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @IBAction func AddAccountBtn(_ sender: UIButton) {
        let addAccountVC = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addAccount) as! AddAccountViewController
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }
}


//MARK:- extension tableview delegate

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource, GetDropDownCellNumDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if accountDetails.isEmpty {
            tableView.isHidden = true
            noAccountLBL.text = "You haven't added any account yet! Try adding one from button below."
            noAccountLBL.isHidden = false
        }else{
            tableView.isHidden = false
            noAccountLBL.isHidden = true
        }
        return accountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.accountBalanceIdentifierCell, for: indexPath) as! AccountBalanceTableViewCell
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let details = accountDetails[indexPath.row]
        cell.accountImage.image = UIImage(named: details.icon)
        cell.accountType.text = details.name
    
        if details.balance < 0 {
            cell.balanceLBL.textColor = .systemRed
            cell.balanceLBL.text = ("\(details.balance)")
        } else {
            cell.balanceLBL.text = ("\(details.balance)")
            cell.balanceLBL.textColor = UIColor(named: "PrimaryColor")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func didTapDropdownIcon(cell: AccountBalanceTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else{fatalError("error getting index path")}
        
        if let cell = tableView.cellForRow(at: indexPath) {
            dropDown.dataSource = ["Edit", "Pin", "Activities"]
            dropDown.anchorView = cell
            dropDown.bottomOffset = CGPoint(x: cell.frame.width, y: cell.frame.size.height)
            dropDown.width = 125
            dropDown.direction = .bottom
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                guard let _ = self else { return }
                
                switch item {
                case "Edit":
                    let editAccountVC = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addAccount) as! AddAccountViewController
                    editAccountVC.isSelectedAccount = self?.accountDetails[indexPath.row]
                    editAccountVC.edit = true
                    self?.navigationController?.pushViewController(editAccountVC, animated: true)
                case "Pin":
                    print("pin")
                case "Activities":
                    print("activities")
                default:
                    print("not found")
                    break
                }
            }
        }
        
        dropDown.show()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
