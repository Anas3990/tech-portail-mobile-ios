//
//  BodyCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-04-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class BodyCell: UITableViewCell {
    
    /* MARK: View's subviews */
    private let contentLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /* MARK: */
    private final func setupSubviewsConstraints() {
        addSubview(contentLabel)
        
        // x, y, width and height constraints
        contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -15.0).isActive = true
        contentLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    /* MARK: */
    public final func populateCell(withDescription description: String) {
        contentLabel.text = description
    }
    
    /* MARK: Init method */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
