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
    
    var sideMenuVC: SideMenuTableViewController?
    
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

