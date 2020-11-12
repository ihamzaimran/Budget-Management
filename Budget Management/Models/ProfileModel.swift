//
//  ProfileModel.swift
//  Budget Management
//
//  Created by Intern on 28/10/2020.
//

import Foundation
import RealmSwift

class ProfileModel: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var email = ""
    @objc dynamic var name = ""
    @objc dynamic var mobile = ""
    @objc dynamic var gender = ""
    @objc dynamic var profession = ""
    @objc dynamic var profileImageData: Data? = nil
    let goalDetails = List<GoalDetails>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


class GoalDetails: Object {
    
    @objc dynamic var goalName = ""
    @objc dynamic var targetDate = ""
    @objc dynamic var goalDescription = ""
    @objc dynamic var  savedAmount = 0
    @objc dynamic var goalIcon = ""
    @objc dynamic var totalGoalAmount = ""
    @objc dynamic var accountType = ""
    @objc dynamic var lastAddedSavingAmount = 0
    let goalTransactions = List<GoalTransactions>()
    var parentDetails = LinkingObjects(fromType: ProfileModel.self, property: "goalDetails")
}

class GoalTransactions: Object {
    
    @objc dynamic var amount = 0
    @objc dynamic var goalName = ""
    @objc dynamic var goalDescription = ""
    @objc dynamic var date = ""
    var parentTransactions = LinkingObjects(fromType: GoalDetails.self, property: "goalTransactions")
}
