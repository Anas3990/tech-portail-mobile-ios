//
//  DashboardCell
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DashboardCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    public var dashboardController: DashboardController?
    
    public var activities = [Activity]()
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
        tableView.register(EventCell.self, forCellReuseIdentifier: "eventCell")
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "workshopScheduleCell")
        
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
                    fatalError("Unable to initialize type \(Activity.self) with dictionary \(document.data())")
                }
            }
            self.activities = models
            
            DispatchQueue.main.async {
                self.recentActivitiesTableView.reloadData()
            }
        }
    }
    
    public final  func stopObserving() {
        listener?.remove()
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

extension DashboardCell {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        guard let startDate = activities[section].startDate else {
            return "N/A"
        }
        
        return DateFormatter.localizedString(from: startDate, dateStyle: .full, timeStyle: .none)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.section]
        
        if indexPath.section == 0 {
            let mostRecentActivityCell = tableView.dequeueReusableCell(withIdentifier: "mostRecentActivityCell")! as! MostRecentActivityCell
            mostRecentActivityCell.populateCell(withActivity: activity)
            
            return mostRecentActivityCell
        } else {
            let recentActivityCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
            recentActivityCell.populateCell(withActivity: activity)
            
            return recentActivityCell
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        }

        return 70.0
    }
        
    internal func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        
        return true
    }
}
