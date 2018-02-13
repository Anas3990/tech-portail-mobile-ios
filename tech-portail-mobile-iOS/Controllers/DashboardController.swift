//
//  DashboardController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DashBoardController: UICollectionViewController {
    
    private var user = User()
    
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
    
    @IBOutlet weak var upcomingEventsCollectionView: UICollectionView!
    
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
            self.upcomingEventsCollectionView.reloadData()
            }
        }
    }
    
    /* MARK: */
    public final func showActivityDetail() {
        let activityDetailCtrl = ActivityDetailController.fromStoryboard()
        self.navigationController?.pushViewController(activityDetailCtrl, animated: true)
    }
    
    /* MARK: */
    override internal final func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeaderView", for: indexPath) as! CollectionViewHeader
        
        switch indexPath.section {
        case 0:
            headerView.populateHeader(withTitle: "Évènements à venir", subtitle: "Tous les évènenements à venir")
        case 1:
            headerView.populateHeader(withTitle: "Nouvelles", subtitle: "Toutes les nouvelles les plus récentes")
        case 2:
            headerView.populateHeader(withTitle: "Horaire atelier", subtitle: "Toutes les heures d'ouvertures de l'atelier à venir")
        default:
            headerView.populateHeader(withTitle: "N/A", subtitle: "N/A")
        }
        
        return headerView
    }
    
    override internal final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCellContainer", for: indexPath) as! UpcomingEventCollectionViewCellContainer
    
        cell.setupCollectionView()
        cell.dashboardCtrl = self
        
        return cell 
    }
}
