//
//  BaseCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    
    public func populateCell(withActivity activity: Activity) {
        timestampLabel.text = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .full, timeStyle: .none).capitalizeFirstLetter()
        titleLabel.text = activity.title
        bodyLabel.text = activity.body
    }
    
    public func populateCell(withNew new: New) {
        timestampLabel.text = DateFormatter.localizedString(from: new.timestamp, dateStyle: .full, timeStyle: .none).capitalizeFirstLetter()
        titleLabel.text = new.title
        bodyLabel.text = new.body
    }
    
    public func populateCell(withEvent event: Event) {
        timestampLabel.text = DateFormatter.localizedString(from: event.timestamp, dateStyle: .full, timeStyle: .none).capitalizeFirstLetter()
        titleLabel.text = event.title
        bodyLabel.text = event.body
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
}
