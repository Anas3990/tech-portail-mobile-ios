//
//  DashboardController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import EventKit
import FirebaseFirestore

class DashBoardController: UITableViewController {
        
    private var upcomingEvents = [Event]()
    private var recentNews = [New]()
    
    private var listener: ListenerRegistration?
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeUpcomingEvents()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query = baseQuery()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeUpcomingEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("events").whereField("startDate", isGreaterThan: Date()).limit(to: 5)
    }
    
    fileprivate func stopObserving() {
        self.listener?.remove()
    }
    
    private final func observeUpcomingEvents() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Event in
                if let model = Event(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Event.self) with dictionary \(document.data())")
                }
            }
            self.upcomingEvents = models
            
            DispatchQueue.main.async {
                
            }
        }
    }
    
    /* MARK: */
    @objc private final func addEventToCalendar(withTitle title: String, startDate: Date, endDate: Date) {
        let eventKit = EKEventStore()
        
        eventKit.requestAccess(to: .event) { (isPermissionGranted, error) in
            if let error = error {
                print(error)
            }
            
            if isPermissionGranted != true {
                
            } else {
                let event: EKEvent = {
                    let eventToAdd = EKEvent()
                    
                    eventToAdd.title = title
                    eventToAdd.startDate = startDate
                    eventToAdd.endDate = endDate
                    
                    return eventToAdd
                }()
                
                do {
                    try EKEventStore().save(event, span: .thisEvent)
                } catch let error {
                    print("failed to save event with error : \(error)")
                }
            }
        }
    }
    
    /* MARK: Table View */
    override internal final func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override internal final func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activityTypeImage: UIImageView = {
            let imageView = UIImageView()
            
            switch section {
            case 0:
                imageView.image = UIImage(named: "calendar")
            case 1:
                imageView.image = UIImage(named: "advertising")
            case 2:
                imageView.image = UIImage(named: "clock")
            default:
                imageView.image = UIImage(named: "calendar")
            }
            
            imageView.frame = CGRect(x: 5, y: 12.5, width: 35, height: 35)
            
            return imageView
        }()
        
        let activityTypeLabel: UILabel = {
            let label = UILabel()
            
            label.frame = CGRect(x: 45, y: 4, width: 200, height: 35)
            
            switch section {
            case 0:
                label.text = "Évènements à venir"
            case 1:
                label.text = "Nouvelles"
            case 2:
                label.text = "Horaires de l'atelier"
            default:
                label.text = "Évènements à venir"
            }
            
            label.textColor = UIColor.black
            
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
            label.adjustsFontSizeToFitWidth = true
            
            return label
        }()
        
        let activityTypeSubtitleLabel: UILabel = {
            let label = UILabel()
            
            label.frame = CGRect(x: 45, y: 20, width: 200, height: 35)
            
            switch section {
            case 0:
                label.text = "Tous les évènements les plus récents"
            case 1:
                label.text = "Toutes les nouvelles les plus récentes"
            case 2:
                label.text = "Tous les horaires de l'atelier à venir"
            default:
                label.text = "Tous les évènements les plus récents"
            }
        
            label.textColor = UIColor.lightGray
            
            label.font = UIFont(name: "System", size: 12)
            label.adjustsFontSizeToFitWidth = true
            
            return label
        }()
                
        let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            
            view.addSubview(activityTypeImage)
            view.addSubview(activityTypeLabel)
            view.addSubview(activityTypeSubtitleLabel)
            
            return view
        }()
        
        return headerView
    }
    
    override internal final func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override internal final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255.0
    }
    
    override internal final func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? ActivitiesContainerTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    override internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesContainerCell", for: indexPath) as! ActivitiesContainerTableViewCell
        
        return cell
    }
}

extension DashBoardController: UICollectionViewDelegate, UICollectionViewDataSource {
    internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.addToCalendarButton.addTarget(self, action: #selector(self.addEventToCalendar(withTitle:startDate:endDate:)), for: .touchUpInside)
        
        return cell
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventInfosCtrl = EventInfosController.fromStoryboard()
                
        self.navigationController?.pushViewController(eventInfosCtrl, animated: true)
    }
}
