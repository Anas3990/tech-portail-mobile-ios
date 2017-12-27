//
//  User.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation
import FirebaseFirestore

struct UserObject {
    var approved: Bool
    var email: String
    var firstName: String
    var group: String
    var homePhoneNumber1: String
    var homePhoneNumber2: String
    var mobilePhoneNumber: String
    var name: String
    var photoUrl: String
    var professionalTitle: String
    var roles: [String: Bool]
    var uid: String

    var dictionary: [String: Any] {
        return [
            "approved": approved,
            "email": email,
            "firstName": firstName,
            "group": group,
            "homePhoneNumber1": homePhoneNumber1,
            "homePhoneNumber2": homePhoneNumber2,
            "mobilePhoneNumber": mobilePhoneNumber,
            "name": name,
            "photoUrl": photoUrl,
            "professionalTitle": professionalTitle,
            "roles": roles,
            "uid": uid
        ]
    }
}

extension UserObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let approved = dictionary["approved"] as? Bool,
            let email = dictionary["email"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let group = dictionary["group"] as? String,
            let homePhoneNumber1 = dictionary["homePhoneNumber1"] as? String,
            let homePhoneNumber2 = dictionary["homePhoneNumber2"] as? String,
            let mobilePhoneNumber = dictionary["mobilePhoneNumber"] as? String,
            let name = dictionary["name"] as? String,
            let photoUrl = dictionary["photoUrl"] as? String,
            let professionalTitle = dictionary["professionalTitle"] as? String,
            let roles = dictionary["roles"] as? [String: Bool],
            let uid = dictionary["uid"] as? String else { return nil }
        
        
            self.init(approved: approved, email: email, firstName: firstName, group: group, homePhoneNumber1: homePhoneNumber1, homePhoneNumber2: homePhoneNumber2, mobilePhoneNumber: mobilePhoneNumber, name: name, photoUrl: photoUrl, professionalTitle: professionalTitle, roles: roles, uid: uid)
    }
}

