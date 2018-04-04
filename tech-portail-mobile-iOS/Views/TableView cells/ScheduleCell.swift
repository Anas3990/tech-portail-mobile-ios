//
//  ScheduleCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-10.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    /* MARK: View's subviews */
    private let yellowBandView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.92, blue: 0.08, alpha: 1.0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, timestampLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    /* MARK: Subviews' constraints setup */
    private final func setupSubviewsConsraints() {
        addSubview(yellowBandView)
        addSubview(detailStackView)
        
        // x, y, width and height constraints
        yellowBandView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        yellowBandView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        yellowBandView.widthAnchor.constraint(equalToConstant: 3.0).isActive = true
        yellowBandView.heightAnchor.constraint(equalTo: detailStackView.heightAnchor).isActive = true
        
        // x, y, width and height constraints
        detailStackView.leadingAnchor.constraint(equalTo: yellowBandView.trailingAnchor, constant: 10.0).isActive = true
        detailStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    /* MARK: Methods for populating the cell */
    public final func populateCell(withActivity activity: Activity) {
        titleLabel.text = activity.title
        
        if let startDate = activity.startDate, let endDate = activity.endDate {
            timestampLabel.text = "\(DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .short)) - \(DateFormatter.localizedString(from: endDate, dateStyle: .none, timeStyle: .short))"
        } else {
            timestampLabel.text = "N/A"
        }
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
