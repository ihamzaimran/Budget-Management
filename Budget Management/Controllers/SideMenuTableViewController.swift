//
//  SideMenuTableViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import RealmSwift

class SideMenuTableViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    private let nameArr = Constants.Text.tableViewListNames
    private let imagesArr = Constants.Images.tableViewImages
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    var shareDelegate: ShareSheetProtocol?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        let nib = UINib(nibName: Constants.TableViewIdentifier.headerView, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: Constants.TableViewIdentifier.headerViewIdentifier)
    }
}

//MARK:- extension tableview delegate

extension SideMenuTableViewController: UITableViewDataSource, UITableViewDelegate, didTapProfileImage {
    
    func profileImageBtnPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.updateProfile) as! UpdateProfileViewController
        self.navigationController?.pushViewController(newVC, animated: false)
        revealViewController()?.revealToggle(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.sideMenuTableCelllIdentifier, for: indexPath)  as! SideMenuTableViewCell
        cell.backgroundColor = .white
        cell.label.textColor = .black
        cell.label.text = nameArr[indexPath.row]
        cell.sideMenuImageView.image = (UIImage(named: imagesArr[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        switch index {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.tabBar) as! UITabBarController
            self.navigationController?.pushViewController(newVC, animated: false)
            revealViewController()?.revealToggle(animated: true)
            break
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.budget) as! BudgetViewController
            self.navigationController?.pushViewController(newVC, animated: false)
            revealViewController()?.revealToggle(animated: true)
            break
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.manageCategoryTab) as! CategoriesViewController
            self.navigationController?.pushViewController(newVC, animated: false)
            revealViewController()?.revealToggle(animated: true)
            break
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.account) as! AccountsViewController
            self.navigationController?.pushViewController(newVC, animated: false)
            revealViewController()?.revealToggle(animated: true)
            break
        case 4:
            //            self.dismiss(animated: true) {
            //                print("Dismiss Completion working.")
            //                self.shareDelegate?.MenuDismissed()
            //            }
            let description = "Budget Management is a free to download app.\n Download it now from the App Store."
            let shareAll = [description]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        case 5:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.settings) as! SettingsViewController
            self.navigationController?.pushViewController(newVC, animated: false)
            revealViewController()?.revealToggle(animated: true)
            break
        default:
            print("No Controller Found")
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch deviceIdiom {
        case .phone:
            return 50
        default:
            return 60
        }
    }
    
    
    //giving table view header size 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    //tableview header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewIdentifier.headerViewIdentifier) as! HeaderView
        header.contentView.backgroundColor = UIColor.init(named: "HeaderColor")
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! HeaderView
        
        let data = realm.objects(ProfileModel.self)
        header.delegate = self
        
        for data in data
        {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", data.id).first {
                
                header.HeaderLabel.text = details.name
                header.headerImage.contentMode = .scaleAspectFill
                
                if let imageData = details.profileImageData {
                    header.headerImage.image = UIImage(data: imageData)
                } else {
                    header.headerImage.image = UIImage(named: "user_dummy")
                }
                
                header.headerImage.makeRoundedImage()
            }
        }
    }
}




//MARK:- ShareSheet Protocol

protocol ShareSheetProtocol {
    func MenuDismissed()
}
