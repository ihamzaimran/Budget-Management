//
//  SettingsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SKCountryPicker
import GoogleSignIn
import RealmSwift

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let images = Constants.Images.settings
    private let text = Constants.Text.settingsText
    private let subTitle = Constants.Text.settingssubText
    private let budgetBrain = BudgetBrain()
    private let userDefault = UserDefaults.standard
    private let realm = try! Realm()
    private var userID: String?
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .white
        userID = userDefault.string(forKey: "UserID")
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- extension tableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.settingsCellIdentifier, for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = .clear
        cell.settingsImageView.image = UIImage(named: images[indexPath.row])
        cell.titleLBL.text = text[indexPath.row]
        cell.subtitleLBL.text = subTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        switch index {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.updateProfile) as! UpdateProfileViewController
            self.navigationController?.pushViewController(newVC, animated: false)
        case 1:
            //            break
            selectCurrency()
        case 2:
            selectCountry()
        case 3:
            print("wiping data...")
            confirmAction()
        case 4:
            budgetBrain.openExternalLink(with: Constants.Links.appStore)
        case 5:
            showShareSheet()
        //        case 6:
        //            disconnectGoogleAccount()
        default:
            break
        }
    }
    
    
    //modified alert to get user confirmation
    private func confirmAction(){
        let TitleString = NSAttributedString(string: "Important", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor")!])
        
        let MessageString = NSAttributedString(string: "Are you sure you want to delete everything?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor")!])
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.setValue(TitleString, forKey: "attributedTitle")
        alert.setValue(MessageString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            do {
                try self.realm.write{
                    let goalDetail = self.realm.objects(GoalDetails.self)
                    let goalAchieved = self.realm.objects(GoalAchieved.self)
                    let goalTransactions = self.realm.objects(GoalTransactions.self)
                    let accounts = self.realm.objects(AccountDetails.self)
                    self.realm.delete(goalDetail)
                    self.realm.delete(goalAchieved)
                    self.realm.delete(goalTransactions)
                    self.realm.delete(accounts)
                    
                    if let id = self.userID {
                        if let profile = self.realm.objects(ProfileModel.self).filter("id = %@", id).first {
                            profile.totalBalance = 0
                        }
                    }
                    
                    print("data deleted!")
                    self.view.makeToast("Data deleted successfully!")
                }
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (_) in
            print("user canceled the action.")
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        alert.view.tintColor = UIColor(named: "PrimaryColor")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //signout from google account/ de authorize google account
    private func disconnectGoogleAccount() {
        
        if userDefault.string(forKey: "UserID") != nil {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (_) in
                GIDSignIn.sharedInstance()?.signOut()
                print("Log Out successful.")
                self.userDefault.removeObject(forKey: "UserID")
                self.userDefault.synchronize()
                let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.login) as! LoginPageViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}


//MARK:- extension to show share sheet

extension SettingsViewController {
    
    
    fileprivate func showShareSheet(){
        let description = "Budget Management is a free to download app.\n Download it now from the App Store."
        let shareAll = [description]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    fileprivate func selectCountry(){
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            guard self != nil else { return }
            print(country.countryCode)
            
        }
        countryController.flagStyle = .circular
        countryController.isCountryDialHidden = true
        //        countryController.detailColor = UIColor(named: "PrimaryColor")!
    }
    fileprivate func selectCurrency(){
        
    }
}

