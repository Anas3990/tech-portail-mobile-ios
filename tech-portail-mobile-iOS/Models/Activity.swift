//
//  Activity.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-08.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct Activity {
    var title: String
    var body: String
    var author: [String: String]
    var timestamp: Date
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "body": body,
            "author": author,
            "timestamp": timestamp
        ]
    }
}

extension Activity: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let body = dictionary["body"] as? String,
            let author = dictionary["author"] as? [String: String],
            let timestamp = dictionary["timestamp"] as? Date else { return nil }
        
        self.init(title: title, body: body, author: author, timestamp: timestamp)
    }
}

