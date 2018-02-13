//
//  NewTableViewCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func populate(new: New) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        
        
        //
        dateLabel.text = "Le " + dateFormatter.string(from: new.timestamp)
        titleLabel.text = new.title
        bodyLabel.text = new.body
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
