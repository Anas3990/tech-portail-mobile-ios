//
//  ActivitiesContainerTableViewCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-03.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class ActivitiesContainerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    public final func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        activitiesCollectionView.delegate = dataSourceDelegate
        activitiesCollectionView.dataSource = dataSourceDelegate
        activitiesCollectionView.tag = row
        activitiesCollectionView.reloadData()
    }
}
