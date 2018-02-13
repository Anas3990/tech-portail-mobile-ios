//
//  DocumentSerializable.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-10.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}
