//
//  ViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SideMenu
import XLPagerTabStrip

class DashBoard: UIViewController {
    
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
        
        navigationItem.hidesBackButton = true
        setupSideMenu()
        updateMenus()
        sideMenuVC?.shareDelegate = self
    }
    
}



// MARK:- Side Menu Setup

extension DashBoard {
    
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        //        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIDs.sideMenuNavigationController) as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: SideMenuManager.PresentDirection.left)
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        //          return modes[presentationStyleSegmentedControl.selectedSegmentIndex]
        return .menuSlideIn
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.menuStartAlpha = CGFloat(0.5)
        presentationStyle.menuScaleFactor = CGFloat(1.0)
        presentationStyle.presentingEndAlpha = CGFloat(0.5)
        presentationStyle.presentingScaleFactor = CGFloat(1.0)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.75)
        
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0
        
        return settings
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

