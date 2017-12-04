//
//  NonAttendance.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-03.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

/*
 ["nonAttendantName": Anas Merbouh, "confirmedAt": 2017-12-03 05:03:06 +0000, "present": 0]
*/
struct NonAttendanceObject {
    var nonAttendantName: String
    var confirmedAt: Date
    var present: Bool
    
    
    var dictionary: [String: Any] {
        return [
            "nonAttendantName": nonAttendantName,
            "confirmedAt": confirmedAt,
            "present": present
        ]
    }
}

extension NonAttendanceObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let nonAttendantName = dictionary["nonAttendantName"] as? String,
            let confirmedAt = dictionary["confirmedAt"] as? Date,
            let present = dictionary["present"] as? Bool else { return nil }
        
        self.init(nonAttendantName: nonAttendantName, confirmedAt: confirmedAt, present: present)
    }
}

