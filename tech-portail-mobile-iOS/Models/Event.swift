//
//  Event.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-12.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct Event {
    var author: [String: String]
    var body: String
    var endDate: Date
    var startDate: Date
    var timestamp: Date
    var title: String
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "body": body,
            "endDate": endDate,
            "startDate": startDate,
            "author": author,
            "timestamp": timestamp
        ]
    }
}

extension Event: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
            let body = dictionary["body"] as? String,
            let endDate = dictionary["endDate"] as? Date,
            let startDate = dictionary["startDate"] as? Date,
            let author = dictionary["author"] as? [String: String],
            let timestamp = dictionary["timestamp"] as? Date else { return nil }
        
        self.init(author: author, body: body, endDate: endDate, startDate: startDate, timestamp: timestamp, title: title)
    }
}
