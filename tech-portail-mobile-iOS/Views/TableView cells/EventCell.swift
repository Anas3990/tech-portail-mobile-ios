//
//  EventCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-04-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    /* MARK: View's subviews */
    private let timestampLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let blackBandView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Test"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    /* MARK: Subviews' constraints setup */
    private final func setupSubviewsConsraints() {
        addSubview(timestampLabel)
        addSubview(blackBandView)
        addSubview(detailStackView)
        
        // x, y, width and height constraints
        timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timestampLabel.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        timestampLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // x, y, width and height constraints
        blackBandView.leadingAnchor.constraint(equalTo: timestampLabel.trailingAnchor).isActive = true
        blackBandView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blackBandView.widthAnchor.constraint(equalToConstant: 3.0).isActive = true
        blackBandView.heightAnchor.constraint(equalTo: detailStackView.heightAnchor).isActive = true
        
        // x, y, width and height constraints
        detailStackView.leadingAnchor.constraint(equalTo: blackBandView.trailingAnchor, constant: 10.0).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        detailStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    /* MARK: */
    public final func populateCell(withActivity activity: Activity) {
        if let startDate = activity.startDate {
            timestampLabel.text = DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short)
        } else {
            timestampLabel.text = DateFormatter.localizedString(from: activity.timestamp, dateStyle: .none, timeStyle: .long)
        }
        
        titleLabel.text = activity.title
        bodyLabel.text = activity.body
    }
    
    /* MARK: Init method */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviewsConsraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
