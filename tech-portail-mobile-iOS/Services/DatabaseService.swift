//
//  DatabaseService.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation

import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    var dbRef: CollectionReference!
    
    //
    let author = ["uid": Auth.auth().currentUser!.uid, "email": Auth.auth().currentUser!.email!, "photoUrl": "https://firebasestorage.googleapis.com/v0/b/tech-portail-production.appspot.com/o/profiles-images%2Fdefault-image%2Fplaceholder-profile-image.jpg?alt=media&token=ef4fc919-1169-4cf9-8ce2-2c3792609757"]

    // Fonction qui permet de rajouter une nouvelle sur la base de données
    func writeNew(withTitle title: String, body: String) {
        dbRef = Firestore.firestore().collection("news")
        
        let new = NewObject(title: title, body: body, author: author, timestamp: Date())
        
        // Ajouter le post à la collection des nouvelles
        dbRef.addDocument(data: new.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeEvent(withTitle title: String, startDate: Date, endDate: Date, body: String) {
         dbRef = Firestore.firestore().collection("events")
        
        let event = EventObject(past: false, author: author, body: body, endDate: endDate, startDate: startDate, timestamp: Date(), title: title)
        
        // Ajouter le post à la collection des nouvelles
        dbRef.addDocument(data: event.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
