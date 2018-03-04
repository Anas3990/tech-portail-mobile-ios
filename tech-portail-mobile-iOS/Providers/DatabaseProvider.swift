//
//  DatabaseProvider.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseProvider {
    
    private let eventsCollection: CollectionReference = Firestore.firestore().collection("events")
    private let newsCollection: CollectionReference = Firestore.firestore().collection("news")
    
    public final func publishEvent(_ event: Event, completion: @escaping (_ error: Error?) -> Void) {
        self.eventsCollection.addDocument(data: ["title": event.title, "body": event.body, "start_date": event.startDate, "end_date": event.endDate, "author": event.author, "timestamp": event.timestamp]) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    public final func publsishNew(_ new: New, completion: @escaping (_ error: Error?) -> Void) {
        self.newsCollection.addDocument(data: ["title": new.title, "body": new.body, "author": new.author, "timestamp": new.timestamp]) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
}
