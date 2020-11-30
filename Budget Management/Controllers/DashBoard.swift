//
//  ViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SideMenu
import XLPagerTabStrip
import GoogleSignIn
import RealmSwift

class DashBoard: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sideMenuVC: SideMenuTableViewController?
    private var accountDetails = List<AccountDetails>()
    private let userDefault = UserDefaults.standard
    private var userID: String?
    private let realm = try! Realm()
    private var totalBalance = 0
    private let arr = List<AccountDetails>()
    private var transactions: Results<GoalTransactions>?
    private var count = 0
    private var date = [String]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: Constants.Images.dashboard), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        sideMenuVC?.shareDelegate = self
        navigationItem.hidesBackButton = true
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let navBar: NavBar = Bundle.main.loadNibNamed("NavBar", owner: self, options: nil)?.first as! NavBar
        navBar.titleLBL.text = "Dashboard"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .clear
        
        count = 0
        arr.removeAll()
        totalBalance = 0
        userID = userDefault.string(forKey: "UserID")
        getDetails()
        amountTxt.text = "\(totalBalance)"
    }
    
    private func getDetails() {
        
        if let id = userID{
            if let profile = self.realm.objects(ProfileModel.self).filter("id = %@", id).first {
                
                accountDetails = profile.accountDetails
                for detail in accountDetails {
                    if detail.isPinToDashboard == true {
                        totalBalance += detail.balance
                        arr.append(detail)
                    }
                }
                collectionView.reloadData()
            }
            
            transactions = self.realm.objects(GoalTransactions.self)
            
            if let transaction = transactions {
                let records = transaction.enumerated()
                for (index,detailTransaction) in records.reversed() {
                    count += 1
                    print(detailTransaction.date)
                    date.append(detailTransaction.date)
                    print("index = \(index), detail = \(detailTransaction.amount)")
                    if count == 3 {
                        break
                    } else {
                        print("continue...")
                    }
                    
                }
            } else {
                print("empty")
            }
        }
    }
    
    @IBAction func addAccountBtn(_ sender: UIButton) {
        let addAccountVC = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addAccount) as! AddAccountViewController
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }
    
    @IBAction func manageDashboardTapped(_ sender: UITapGestureRecognizer) {
        
        print("Manage dashboard vc Tapped")
        let manageDashboardVC = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.manageDashboard) as! ManageDashboardViewController
        self.navigationController?.pushViewController(manageDashboardVC, animated: true)
    }
    
    @IBAction func showMoreAccountsBtn(_ sender: UIButton) {
        let addAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.account) as! AccountsViewController
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }
    
    @IBAction func showMoreRecords(_ sender: UIButton) {
        print("Show More Records")
    }
}

//MARK:- ShareSheet Delegate

extension DashBoard: ShareSheetProtocol {
    func MenuDismissed() {
        print("Function working")
        let description = "Budget Management is a free to download app. \n Download it now from the App Store."
        let shareAll = [description]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: extension collectionview

extension DashBoard: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.TableViewIdentifier.dasboardAccountsCell, for: indexPath) as! DashboardAccountsCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.accountsStackView.layer.cornerRadius = 5
        
        let details = arr[indexPath.row]
        
        cell.accountBalanceTxt.text = "\(details.balance)"
        cell.accountNameTxt.text = details.name
        let color = hexStringToUIColor(hex: details.colorHexString)
        cell.accountsStackView.backgroundColor = color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellSize = collectionView.frame.size.width
        return CGSize(width: 315/3, height: collectionCellSize/8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let itemIndex = indexPath.row
        print(itemIndex)
    }
    
}


//MARK:- tableview delegate

extension DashBoard: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.dashboardRecordCell, for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
