//
//  Folder.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-29.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

struct FolderObject {
    var name: String
    var timestamp: Any
    
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "timestamp": timestamp
        ]
    }
}

extension FolderObject: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let timestamp = dictionary["timestamp"] as? Any else { return nil }
        
        self.init(name: name, timestamp: timestamp)
    }
}
