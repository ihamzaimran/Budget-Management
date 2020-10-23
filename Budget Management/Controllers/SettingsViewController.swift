//
//  SettingsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SKCountryPicker

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let images = Constants.Images.settingsImages
    private let text = Constants.Text.settingsText
    private let subTitle = Constants.Text.settingssubText
    private let budgetBrain = BudgetBrain()
    
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
        default:
            break
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

