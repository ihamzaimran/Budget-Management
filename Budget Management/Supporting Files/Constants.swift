//
//  Constants.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import Foundation

struct Constants {
    
    struct StoryboardIDs {
        static let sideMenu = "SideMenuTableStoryboard"
        static let sideMenuNavigationController = "SideMenuNavigationController"
        static let dashboard = "DashboardStoryboard"
        static let budget = "BudgetViewStoryboard"
        static let category = "CategoriesViewStoryboard"
        static let account = "AccountsViewStoryboard"
        static let settings = "SettingsViewStoryboard"
        static let updateProfile = "updateProfileStoryboard"
    }
    
    struct TableViewIdentifier {
        static let sideMenuTableCelllIdentifier = "sideMenuTableCell"
        static let headerViewIdentifier = "sideMenuHeader"
        static let headerView = "HeaderView"
        static let settingsCellIdentifier = "settingsTableCell"
    }
    
    struct Images {
        static let settingsImages = ["user_profile_mini", "icon_currency", "icon_currency", "wipe_all_data", "like_app" ,"share_app"]
    }
    
    struct Text {
        static let settingsText = ["Profile", "Currency", "Country", "Wipe All Data" , "Rate Our App", "Share Our App"]
        static let settingssubText = ["name, email, gender, profile picture", "Set your native currency", "Set your Country of Origin", "This Action will clear records" , "", ""]
    }
}
