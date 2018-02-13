//
//  UpcomingEventCollectionViewCellContainer.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-13.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class UpcomingEventCollectionViewCellContainer: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var dashboardCtrl: DashBoardController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public final func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCell", for: indexPath)
        
        //
        cell.layer.cornerRadius = 6.0
        
        return cell
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dashboardCtrl?.showActivityDetail()
    }
    
}
