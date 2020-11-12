//
//  SettingsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SKCountryPicker
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let images = Constants.Images.settings
    private let text = Constants.Text.settingsText
    private let subTitle = Constants.Text.settingssubText
    private let budgetBrain = BudgetBrain()
    private let userDefault = UserDefaults.standard
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .white
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
            break
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

