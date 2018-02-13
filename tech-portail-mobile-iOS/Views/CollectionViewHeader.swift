//
//  CollectionViewHeader.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-13.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class CollectionViewHeader:UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    public final func populateHeader(withTitle title: String, subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
}
