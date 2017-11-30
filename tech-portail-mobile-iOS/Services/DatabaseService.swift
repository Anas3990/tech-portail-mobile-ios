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
    let author = ["uid": Auth.auth().currentUser!.uid, "email": Auth.auth().currentUser!.email!]
    let timestamp = FieldValue.serverTimestamp()
    
    // Fonction qui permet de rajouter une nouvelle sur la base de données
    func writeNew(withTitle title: String, body: String) {
        dbRef = Firestore.firestore().collection("news")
        
        let new = NewObject(title: title, body: body, author: author, timestamp: timestamp)
        
        // Ajouter le post à la collection des nouvelles
        dbRef.addDocument(data: new.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeEvent(withTitle title: String, startDate: Date, endDate: Date, body: String) {
         dbRef = Firestore.firestore().collection("events")
        
        let event = EventObject(past: false, author: author, body: body, endDate: endDate, startDate: startDate, timestamp: timestamp, title: title)
        
        // Ajouter le post à la collection des nouvelles
        dbRef.addDocument(data: event.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
