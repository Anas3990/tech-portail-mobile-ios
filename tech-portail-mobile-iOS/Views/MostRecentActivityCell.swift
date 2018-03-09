//
//  MostRecentActivityCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class MostRecentActivityCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 6.0
        view.backgroundColor = .gray
            
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = .white
        
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    private let additionalDetailContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = -40.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .white
    
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
    
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.text = "Aucune description n'a été fourni"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -27.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private final func setupContainerView() {
        addSubview(containerView)
        
        // x, y, width, height constraints
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.95).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }

    private final func setupAdditionalDetailContainerStackView() {
        addSubview(additionalDetailContainerStackView)
        
        //
        additionalDetailContainerStackView.addArrangedSubview(authorLabel)
        additionalDetailContainerStackView.addArrangedSubview(timestampLabel)
        
        // x, y, width, height constraints
        additionalDetailContainerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -10).isActive = true
        additionalDetailContainerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        additionalDetailContainerStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.35).isActive = true
        additionalDetailContainerStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
    
    private final func setupLabelsContainerStackView() {
        containerView.addSubview(labelsContainerStackView)
        
        //
        labelsContainerStackView.addArrangedSubview(titleLabel)
        labelsContainerStackView.addArrangedSubview(bodyLabel)
        
        // x, y, width, height constraints
        labelsContainerStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        labelsContainerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        labelsContainerStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.35).isActive = true
        labelsContainerStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.90).isActive = true
    }
 
    
    public final func populateCell(withActivity activity: Activity) {
        if let authorName = activity.author["name"] {
            authorLabel.text = authorName
        } else {
            authorLabel.text = "N/A"
        }
        
        timestampLabel.text = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .medium, timeStyle: .none)
        titleLabel.text = activity.title
        bodyLabel.text = activity.body
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContainerView()
        setupAdditionalDetailContainerStackView()
        setupLabelsContainerStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
