//
//  FirebaseTableViewDelegate.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-10.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol FirebaseTableViewDelegate: UITableViewDataSource {
    
    var data: [Any] { get set }
    
    var documents: [DocumentSnapshot] { get set }
    
    var listener: ListenerRegistration? { get set }
    
    var query: Query? { get set }
    
    func baseQuery() -> Query
    
    func observeData() -> Void
    
    func stopObserving() -> Void
}
