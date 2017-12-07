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
    var firstName: String
    var name: String
    var email: String

    var dictionary: [String: Any] {
        return [
            "firstName": firstName,
            "name": name,
            "email": email
        ]
    }
}

extension UserObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String else { return nil }
        
        self.init(firstName: firstName, name: name, email: email)
        
    }
}

