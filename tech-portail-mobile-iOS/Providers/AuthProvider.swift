//
//  AuthProvider.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {
    
    public final func disconnetUser(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            completion(error)
        }
    }
    
}
