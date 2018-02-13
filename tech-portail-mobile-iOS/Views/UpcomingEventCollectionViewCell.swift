//
//  UpcomingEventCollectionViewCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-10.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class UpcomingEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    public final func populate(event: Event) {
        self.titleLabel.text = event.title
        self.authorLabel.text = event.author["name"]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
