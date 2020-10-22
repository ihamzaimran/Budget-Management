//
//  ViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import SideMenu

class DashBoard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu()
        updateMenus()
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
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.65)
        
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0
        
        return settings
    }
}
