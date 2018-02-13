//
//  EventTableViewCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func populate(event: Event) {
        self.titleLabel.text = event.title
        self.bodyLabel.text = event.body
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
