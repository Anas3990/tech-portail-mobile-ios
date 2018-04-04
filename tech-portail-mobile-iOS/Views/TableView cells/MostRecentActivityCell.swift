//
//  MostRecentActivityCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class MostRecentActivityCell: UITableViewCell {
    
    /* MARK: Views' declarations */
    private let containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 6.0
        view.backgroundColor = .gray
        
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)

        // Add a motion (parallax) effect to the view
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -13
        xMotion.maximumRelativeValue = 13
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -13
        yMotion.maximumRelativeValue = 13
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.textColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -5.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    /* MARK: Views' Auto layout constraints */
    private final func setupContainerView() {
        addSubview(containerView)
        
        // x, y, width, height constraints
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.90).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    private final func setupLabelsContainerStackView() {
        containerView.addSubview(labelsContainerStackView)
        
        // Adding the arranged subviews to the stack view
        labelsContainerStackView.addArrangedSubview(timestampLabel)
        labelsContainerStackView.addArrangedSubview(titleLabel)
        labelsContainerStackView.addArrangedSubview(bodyLabel)
        
        // x, y, width, height constraints
        labelsContainerStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        labelsContainerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        labelsContainerStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.35).isActive = true
        labelsContainerStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.90).isActive = true
    }
 
    public final func populateCell(withActivity activity: Activity) {
        timestampLabel.text = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .medium, timeStyle: .none)
        titleLabel.text = activity.title
        bodyLabel.text = activity.body
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContainerView()
        setupLabelsContainerStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
