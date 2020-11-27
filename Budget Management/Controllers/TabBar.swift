//
//  TabBar.swift
//  Budget Management
//
//  Created by Intern on 17/11/2020.
//

import UIKit
import SideMenu
import DeviceKit

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    var navBar: NavBar?
    var navBarX: NavBarX?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Device = \(Device.current)")
        
        let groupOfAllowedDevices: [Device] = [.iPhone12ProMax, .iPhone12Pro, .iPhone12, .iPhone12Mini, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneXS, .iPhoneXR, .iPhoneXSMax, .iPhoneX, .simulator(.iPhone11Pro)]
        
        let device = Device.current
        
        if device.isOneOf(groupOfAllowedDevices) {
            navBarX = Bundle.main.loadNibNamed("NavBarX", owner: self, options: nil)?.first as? NavBarX
            loadNavBarViewX()
        } else {
            navBar = Bundle.main.loadNibNamed("NavBar", owner: self, options: nil)?.first as? NavBar
            loadNavBarView()
        }
        
        self.delegate = self
        
        setupSideMenu()
        updateMenus()
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is DashBoard {
            print("dashboard")
        } else if viewController is BudgetsTabViewController {
            if let nav = navBar {
                nav.titleLBL.text = "Budgets"
                print("budgets tab")
            } else if let navbar = navBarX {
                navbar.titleLBL.text = "Budgets"
                print("budgets tab")
            }
        } else if viewController is ActivitiesTabViewController {
            if let nav = navBar {
                nav.titleLBL.text = "Activity"
                print("activity tab")
            } else if let navbar = navBarX {
                navbar.titleLBL.text = "Activity"
                print("activity tab")
            }
        } else if viewController is PagerViewForsavingsViewController {
            if let nav = navBar {
                nav.titleLBL.text = "Savings"
                print("savings tab")
            } else if let navbar = navBarX {
                navbar.titleLBL.text = "Savings"
                print("savings tab")
            }
        }
    }
    
    private func loadNavBarView(){
        
        navBar?.menuIconBtn.addTarget(self, action: #selector(self.menuIconPressed(_:)), for: .touchUpInside)
        navBar?.titleLBL.text = "Dasboard"
        view.addSubview(navBar!)
    }
    
    private func loadNavBarViewX(){
        
        navBarX?.menuIconBtn.addTarget(self, action: #selector(self.menuIconPressed(_:)), for: .touchUpInside)
        navBarX?.titleLBL.text = "Dasboard"
        view.addSubview(navBarX!)
    }
    
    @objc private func menuIconPressed(_ sender: UIButton){
        let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.sideMenuNavigationController) as! SideMenuNavigationController
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.menuStartAlpha = CGFloat(0.5)
        menu.presentationStyle.menuScaleFactor = CGFloat(1.0)
        menu.presentationStyle.presentingEndAlpha = CGFloat(0.5)
        menu.presentationStyle.presentingScaleFactor = CGFloat(1.0)
        menu.settings.presentationStyle = menu.presentationStyle
        menu.settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.75)
        
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        menu.settings.blurEffectStyle = styles[0]
        menu.settings.statusBarEndAlpha = 0
        self.present(menu, animated: true, completion: nil)
        
    }
}


// MARK:- Side Menu Setup

extension TabBar {
    
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
        let _: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
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
