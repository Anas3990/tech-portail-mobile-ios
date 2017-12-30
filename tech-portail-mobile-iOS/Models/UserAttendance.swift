//
//  UserAttendance.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-29.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct UserAttendanceObject {
    var attendanceStartsAt: Date
    var attendanceEndsAt: Date
    var eventStartDate: Date
    var eventEndDate: Date
    var confirmedAt: Date
    var eventTitle: String
    var eventBody: String
    
    var dictionary: [String: Any] {
        return [
            "attendanceStartsAt": attendanceStartsAt,
            "attendanceEndsAt": attendanceEndsAt,
            "eventStartDate": eventStartDate,
            "eventEndDate": eventEndDate,
            "confirmedAt": confirmedAt,
            "eventTitle": eventTitle,
            "eventBody": eventBody
        ]
    }
}

extension UserAttendanceObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let attendanceStartsAt = dictionary["attendanceStartsAt"] as? Date,
            let attendanceEndsAt = dictionary["attendanceEndsAt"] as? Date,
            let eventStartDate = dictionary["eventStartDate"] as? Date,
            let eventEndDate = dictionary["eventEndDate"] as? Date,
            let confirmedAt = dictionary["confirmedAt"] as? Date,
            let eventTitle = dictionary["eventTitle"] as? String,
            let eventBody = dictionary["eventBody"] as? String else { return nil }
        
        self.init(attendanceStartsAt: attendanceStartsAt, attendanceEndsAt: attendanceEndsAt, eventStartDate: eventStartDate, eventEndDate: eventEndDate, confirmedAt: confirmedAt, eventTitle: eventTitle, eventBody: eventBody)
    }
}
