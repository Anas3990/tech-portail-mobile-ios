//
//  DashboardSectionCell
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DashboardSectionCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {    
    public var activites = [Activity]()
    public var documents = [DocumentSnapshot]()
    public var listener: ListenerRegistration?
    
    public var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeActivities()
            }
        }
    }
    
    public lazy var recentActivitiesTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(MostRecentActivityCell.self, forCellReuseIdentifier: "mostRecentActivityCell")
        tableView.register(RecentActivityCell.self, forCellReuseIdentifier: "recentActivityCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private final func setupTableView() {
        addSubview(recentActivitiesTableView)
        
        // x, y, width, height constraints
        recentActivitiesTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        recentActivitiesTableView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        recentActivitiesTableView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        recentActivitiesTableView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
    /* MARK: */
    public func baseQuery() -> Query {
        return Firestore.firestore().collection("events").limit(to: 10).order(by: "timestamp", descending: true)
    }
    
    public final  func stopObserving() {
        listener?.remove()
    }
    
    public func observeActivities() {
        guard let query = query else  { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Activity in
                if let model = Activity(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(New.self) with dictionary \(document.data())")
                }
            }
            self.activites = models
            self.documents = snapshot.documents
                        
            DispatchQueue.main.async {
                self.recentActivitiesTableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
        
        query = baseQuery()
        observeActivities()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DashboardSectionCell {
    internal final func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activites.count
    }
    
    internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activites[indexPath.row]
        
        if indexPath.row == 0 {
            let mostRecentActivityCell = tableView.dequeueReusableCell(withIdentifier: "mostRecentActivityCell")! as! MostRecentActivityCell
            
            mostRecentActivityCell.populateCell(withActivity: activity)
            
            return mostRecentActivityCell
        } else {
            let recentActivityCell = tableView.dequeueReusableCell(withIdentifier: "recentActivityCell", for: indexPath) as! RecentActivityCell
        
            recentActivityCell.populateCell(withActivity: activity)
            
            return recentActivityCell
        }
    }
    
    internal final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        
        return 85.0
    }
    
    internal final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityDetailCtrl = ActivityDetailController()
        
        activityDetailCtrl.activity = activites[indexPath.row]
        activityDetailCtrl.activityReference = documents[indexPath.row].reference
    }
    
    internal final func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        
        return true
    }
}
