//
//  FirebaseExtensions.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-04-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation
import Firebase

/* MARK: Database */

/* MARK: Authentification*/
extension User {
    public final func getProfile(completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            completion(snapshot?.data(), error)
        }
    }
}
