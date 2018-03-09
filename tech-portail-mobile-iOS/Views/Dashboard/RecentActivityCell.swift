//
//  RecentActivityCell
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class RecentActivityCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -40.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private final func setupLabelsContainerStackView() {
        addSubview(labelsContainerStackView)
        
        // Adding the arranged subviews to the stack view
        labelsContainerStackView.addArrangedSubview(titleLabel)
        labelsContainerStackView.addArrangedSubview(bodyLabel)
        
        // x, y, width, height constraints
        labelsContainerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelsContainerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelsContainerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.95).isActive = true
        labelsContainerStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    
    public final func populateCell(withActivity activity: Activity) {
        titleLabel.text = activity.title
        bodyLabel.text = activity.body
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        accessoryType = .disclosureIndicator
        
        setupLabelsContainerStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentActivityCell {
    public final func populate(withTitle title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}
