//
//  Attendance.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct Attendance {
    var eventName: String
    var eventBody: String
    var startsAt: Date
    var endsAt: Date
    var confirmedAt: Date
    var userName: String
    var attending: Bool

    var dictionary: [String: Any] {
        return [
            "eventName": eventName,
            "eventBody": eventBody,
            "startsAt": startsAt,
            "endsAt": endsAt,
            "confirmedAt": confirmedAt,
            "userName": userName,
            "attending": attending
        ]
    }
}

extension Attendance: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let eventName = dictionary["eventName"] as? String,
            let eventBody = dictionary["eventBody"] as? String,
            let startsAt = dictionary["startsAt"] as? Date,
            let endsAt = dictionary["endsAt"] as? Date,
            let confirmedAt = dictionary["confirmedAt"] as? Date,
            let userName = dictionary["userName"] as? String,
            let attending = dictionary["attending"] as? Bool else { return nil }
        
        self.init(eventName: eventName, eventBody: eventBody, startsAt: startsAt, endsAt: endsAt, confirmedAt: confirmedAt, userName: userName, attending: attending)
    }
}
