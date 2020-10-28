//
//  ProfileModel.swift
//  Budget Management
//
//  Created by Intern on 28/10/2020.
//

import Foundation
import RealmSwift

class ProfileModel: Object {
    
    @objc dynamic var email = ""
    let details = List<ProfileDetails>()
}


class ProfileDetails: Object {
    @objc dynamic var name = ""
    @objc dynamic var mobile = ""
    @objc dynamic var gender = ""
    @objc dynamic var profession = ""
    @objc dynamic var profileImageData: Data? = nil
    var parentDetails = LinkingObjects(fromType: ProfileModel.self, property: "details")
}
