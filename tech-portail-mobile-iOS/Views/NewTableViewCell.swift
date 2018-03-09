//
//  NewTableViewCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    
    
    public final func populate(new: New) {
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
