//
//  EventDetailController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-08.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var event: Event? {
        didSet {
            navigationItem.title = event?.title
        }
    }
    
    /* MARK: View's subviews */
    private lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(BodyCell.self, forCellReuseIdentifier: "bodyCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let confirmAttendanceButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .black
        
        button.setTitle("Confirmer ma présence", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    /* MARK: Subviews' constraints setup */
    private final func setupSubviewsContraints() {
        view.addSubview(detailTableView)
        view.addSubview(confirmAttendanceButton)
        
        // x, y, width and height constraints
        detailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: confirmAttendanceButton.topAnchor).isActive = true
        detailTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // x, y, width and height constraints
        confirmAttendanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmAttendanceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        confirmAttendanceButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        confirmAttendanceButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 10 / 100).isActive = true
    }
    
    /* MARK: View's lifecycle */
    override internal final func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        setupSubviewsContraints()
        
        detailTableView.reloadData()
    }

    /* MARK: */
    internal final func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "bodyCell", for: indexPath) as! BodyCell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
    }

    internal final func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
