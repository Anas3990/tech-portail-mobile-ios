//
//  AuthService.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation

import FirebaseFirestore
import FirebaseAuth

class AuthService {
    
    // Fonction qui permet de récupérer les informations sur l'utilisateur présentement connecté et de les placer dans la variable currentUser
    func getCurrentUserData(completion: @escaping (UserObject) -> Void) {
        if let FIRUser = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(FIRUser.uid).getDocument(completion: { (snapshot, error) in
                if error != nil {
                    return
                } else {
                    if let _ = snapshot {
                        let currentUser = snapshot.flatMap({ UserObject(dictionary: $0.data()) })
                        completion(currentUser!)
                    } else {
                        completion(UserObject(approved: false, email: "N/A", firstName: "N/A", group: "N/A", homePhoneNumber1: "N/A", homePhoneNumber2: "N/A", mobilePhoneNumber: "N/A", name: "N/A", photoUrl: "N/A", professionalTitle: "N/A", roles: ["admin": false, "mentor": false], timestamp: Date(), uid: "N/A"))
                    }
                }
            })
        } else {
            return
        }
    }
    
    // Fonction qui sert à déconnecter un utilisateur de l'application
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
