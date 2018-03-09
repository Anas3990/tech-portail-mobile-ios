//
//  DashboardController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class DashboardController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private let dashboardSectionCell: DashboardSectionCell = DashboardSectionCell()
    
    private lazy var viewTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        
        label.text = NSLocalizedString("dashboardViewTitleLabel", comment: "Describes the view title of the DashboardController")
        label.textColor = .white
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        
        mb.dashboardController = self
        
        mb.translatesAutoresizingMaskIntoConstraints = false
        
        return mb
    }()
    
    private let sectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.0)
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private final func setupMenuBar() {        
        view.addSubview(menuBar)
        
        // x, y, width, height constraints
        menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private final func setupSectionsCollectionView() {
        view.addSubview(sectionsCollectionView)
        
        // x, y, width, height constraints
        sectionsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sectionsCollectionView.topAnchor.constraint(lessThanOrEqualTo: menuBar.bottomAnchor).isActive = true
        sectionsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sectionsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    /* MARK: View's life cycle */
    override internal final func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the view's constraints
        setupMenuBar()
        setupSectionsCollectionView()
    
        // Setup the navigation bar
        navigationItem.titleView = viewTitleLabel
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Setup the collection view
        sectionsCollectionView.dataSource = self
        sectionsCollectionView.delegate = self

        sectionsCollectionView.register(DashboardSectionCell.self, forCellWithReuseIdentifier: "dashboardSectionCell")
        sectionsCollectionView.register(NewsFeedCell.self, forCellWithReuseIdentifier: "newsFeedCell")
        sectionsCollectionView.register(UserProgressCell.self, forCellWithReuseIdentifier: "userProgressCell")
    }
    
    override internal final func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dashboardSectionCell.stopObserving()
    }
    
    
    /* MARK: Scrolling managment */
    internal final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarViewLeftAnchor?.constant = scrollView.contentOffset.x / 4
    }

    public final func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.tabsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    public final func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: 0, section: menuIndex)
        sectionsCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    /* MARK: Collection view delegates configuration */
    internal final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "newsFeedCell", for: indexPath)
        } else if indexPath.section == 3 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "userProgressCell", for: indexPath)
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardSectionCell", for: indexPath) as! DashboardSectionCell
    }
        
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sectionsCollectionView.frame.width, height: sectionsCollectionView.frame.height)
    }
}
