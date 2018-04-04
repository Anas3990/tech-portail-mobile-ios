//
//  UserProgressCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-08.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class UserProgressCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    /* MARK: View's subviews */
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height), style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userUpcomingEventCell")
        
        return tableView
    }()
    
    /* MARK: Init method */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* MARK: TableView configuration */
    internal final func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal final func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Statistiques"
        }
        
        return "Vos prochaines rencontres"
    }
    
    internal final func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 5
    }
    
    internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "userUpcomingEventCell", for: indexPath)
    }
    
    internal final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200.0
        }
        
        return 90.0
    }
}
