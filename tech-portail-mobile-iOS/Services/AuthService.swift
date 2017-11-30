//
//  AuthService.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation

import FirebaseAuth

class AuthService {
    // Fonction sert à déconnecter un utilisateur de l'application
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            print("Le token a bel-et-bien été enlevé")
            
            return true
        } catch let signOutError as NSError {
            print ("Une erreur est survenue lors de la tentative de déconnexion : %@", signOutError)
            
            return false
        }
    }
}
