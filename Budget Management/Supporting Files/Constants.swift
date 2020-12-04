//
//  Constants.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import Foundation

struct Constants {
    
    struct StoryboardName {
        static let secondStoryboard = "SecondStoryboard"
    }
    
    struct StoryboardIDs {
        static let sideMenu = "SideMenuTableStoryboard"
        static let sideMenuNavigationController = "SideMenuNavigationController"
        static let dashboard = "DashboardStoryboard"
        static let budget = "BudgetViewStoryboard"
        static let account = "AccountsViewStoryboard"
        static let settings = "SettingsViewStoryboard"
        static let updateProfile = "updateProfileStoryboard"
        static let tabBar = "tabBarController"
        static let goalAchieved = "GoalAchievedStoryboard"
        static let savings = "SavingStoryboard"
        static let manageCategoryTab = "ManageCategoryTabStoryboard"
        static let expense = "ExpenseStoryboard"
        static let income = "IncomeStoryboard"
        static let login = "LoginPagerStoryboard"
        static let GuestLogin = "GuestLoginStoryboard"
        static let addGoal = "AddGoalStoryboard"
        static let newGoal = "NewGoalStoryboard"
        static let goalDetails = "GoalDetailsStoryboard"
        static let addSavingAmount = "AddSavingAmountStoryboard"
        static let goalTransactions = "GoalTransactionsStoryboard"
        static let AchievedGoalDetailStoryboard = "AchievedGoalDetailStoryboard"
        static let addAccount = "AddAccountStoryboard"
        static let manageDashboard = "ManageDashboardStoryboard"
        static let allActivityStoryboard = "allActivityStoryboard"
        static let ActivitiesTabVC = "ActivitiesTabVC"
        static let editBudgetStoryboard = "EditMonthlyBudgetStoryboard"
        static let setBudgetStoryboard = "setMonthlyBudgetStoryboard"
        static let overAllBudgetStoryboard = "overAllBudgetStoryboard"
    }
    
    struct TableViewIdentifier {
        static let sideMenuTableCelllIdentifier = "sideMenuTableCell"
        static let headerViewIdentifier = "sideMenuHeader"
        static let headerView = "HeaderView"
        static let settingsCellIdentifier = "settingsTableCell"
        static let expenseCellIdentifier = "expenseTableCellIdentifier"
        static let incomeCellIdentifier = "incomeTableCellIdentifier"
        static let loginCollectionCellIdentifier = "loginCollectionCellIdentifier"
        static let savingsCellIdentifier = "savingsTableCellIdentifier"
        static let newGoalCollectionCellIdentifier = "newGoalCollectionCellIdentifier"
        static let goalTransactionsCellIdentifer = "goalTransactionsCellIdentifer"
        static let achievedTableCellIdentifier = "achievedTableCellIdentifier"
        static let accountBalanceIdentifierCell = "accountBalanceIdentifierCell"
        static let addAccountTableCellIdentifier = "addAccountTableCellIdentifier"
        static let dasboardAccountsCell = "dashboardAccountsCellIdentifier"
        static let dashboardRecordCell = "dashboardLastRecordsCell"
        static let activitiesTableCell = "activitiesTableCell"
        static let setBudget = "setBudgetCell"
        static let overallBudgetCellIndentifier = "overallBudgetCellIndentifier"
    }
    
    struct Images {
        static let settings = ["user_profile_mini", "icon_currency", "icon_currency", "wipe_all_data", "like_app" ,"share_app"]
        static let dashboard = "dash_bottom_colored"
        static let budgetTab = "budget_bottm_colored"
        static let activityTab = "activity_bottm_color"
        static let savingsTab = "savings_bottom_colored"
        static let loginPager = ["into_image_1", "into_image_2", "into_image_3", "into_image_4"]
        static let tableViewImages = ["dashboard", "budget", "categories", "accounts", "share", "settings"]
        static let iconArray =  ["education_e", "personal", "wedding",
                                 "medical_m", "family_expense", "grocery", "house_hold","entertainment_e", "gifts_g", "clothing", "fuel_transport","eatin_outg", "utilities_u", "salary", "investment","commission", "other_income", "bank_icon", "home_icon","car_icon", "edu_icon", "wedding_icon", "clock_icon", "palm_icon","savings"]
        static let expenseIcon = ["education_e", "personal", "wedding",
                                 "medical_m", "family_expense", "grocery", "house_hold","entertainment_e", "gifts_g", "clothing", "fuel_transport","eatin_outg", "utilities_u", "salary", "investment"]
    }
    
    struct Text {
        static let settingsText = ["Profile", "Currency", "Country", "Wipe All Data" , "Rate Our App", "Share Our App", "Sign Out"]
        static let settingssubText = ["name, email, gender, profile picture", "Set your native currency", "Set your Country of Origin", "This Action will clear records" , "Like our app on App Store", "Share our app with others"]
        static let tableViewListNames = ["Dashboard", "Budgets", "Categories", "Accounts", "Share", "Settings"]
        static let expenseIconText = ["Education", "Personal", "Wedding", "Medical", "Family Expense", "Grocery", "HouseHold", "Entertainment", "Gifts", "Clothing", "Fuel & Transport", "Eating-Out", "Utilities", "Salary", "Investment"]
        static let overViewSwitch = "overViewSwitch"
        static let accountsSwitch = "accountsSwitch"
        static let lastRecordsSwitch = "lastRecordsSwitch"
    }
    
    struct Links {
        static let appStore = "https://itunes.apple.com/pk/developer/suave-solutions/id415880778"
    }
    
    struct Colors{
        
        static let colorString = ["#38C5B2", "#008577", "#006400", "#ff0000", "#3232FF", "#3232FF", "#008577", "#3CB371",
                                  "#FFD12A", "#006400", "#5A6351", "#006B54", "#32CD32", "#3E766D", "#B4EEB4", "#596C56",
                                  "#B4EEB4", "#40664D", "#34925E", "#006B54"]
    }
}
