//
//  New.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-14.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct NewObject {
    var title: String
    var body: String
    var author: [String: String]
    var timestamp: Any
    
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "body": body,
            "author": author,
            "timestamp": timestamp
        ]
    }
}

extension NewObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
              let body = dictionary["body"] as? String,
              let author = dictionary["author"] as? [String: String],
              let timestamp = dictionary["timestamp"] as? Any else { return nil }
        
        self.init(title: title, body: body, author: author, timestamp: timestamp)
    }
}
