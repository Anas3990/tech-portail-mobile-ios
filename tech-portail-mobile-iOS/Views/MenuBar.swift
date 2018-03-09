//
//  MenuBar.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-08.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let imagesNames = ["calendar", "advertising", "clock", "person"]
    public var dashboardController: DashboardController = DashboardController()
    
    public lazy var tabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "tabCell")
        
        collectionView.backgroundColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.0)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let horizontalBarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private final func setupTabsCollectionView() {
        addSubview(tabsCollectionView)
        
        // x, y, width, height constraints
        tabsCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tabsCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tabsCollectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        tabsCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    public var horizontalBarViewLeftAnchor: NSLayoutConstraint?
    
    private final func setupHorizontalBarView() {
        addSubview(horizontalBarView)
        
        // x, y, width, height constraints
        horizontalBarViewLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarViewLeftAnchor?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabsCollectionView()
        setupHorizontalBarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuBar {
    internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as! MenuCell
        
        cell.iconImageView.image = UIImage(named: imagesNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dashboardController.scrollToMenuIndex(indexPath.item)
    }
}
