//
//  NewsFeedCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-08.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NewsFeedCell: DashboardCell {
    
    override func baseQuery() -> Query {
        return Firestore.firestore().collection("news").limit(to: 10).order(by: "timestamp", descending: true)
    }
}
