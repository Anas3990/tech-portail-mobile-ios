//
//  Attendance.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct AttendanceObject {
    var attendanceStartsAt: Date
    var attendanceEndsAt: Date
    var confirmedAt: Date
    var attendantName: String
    
    
    var dictionary: [String: Any] {
        return [
            "attendanceStartsAt": attendanceStartsAt,
            "attendanceEndsAt": attendanceEndsAt,
            "confirmedAt": confirmedAt,
            "attendantName": attendantName
        ]
    }
}

extension AttendanceObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let attendanceStartsAt = dictionary["attendanceStartsAt"] as? Date,
            let attendanceEndsAt = dictionary["attendanceEndsAt"] as? Date,
            let confirmedAt = dictionary["confirmedAt"] as? Date,
            let attendantName = dictionary["attendantName"] as? String else { return nil }
        
        self.init(attendanceStartsAt: attendanceStartsAt, attendanceEndsAt: attendanceEndsAt, confirmedAt: confirmedAt, attendantName: attendantName)
    }
}
