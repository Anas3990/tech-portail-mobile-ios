//
//  NewsController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-14.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NewsController: UITableViewController, FirebaseTableViewDelegate {
    
    var data = [Any]()
    var documents = [DocumentSnapshot]()
    var listener: ListenerRegistration?
    
    var query: Query?
    
    /* MARK: View's lifecyle */
    override internal final func viewDidLoad() {
        super.viewDidLoad()
        
        // View's title
        navigationItem.title = NSLocalizedString("tabBarSecondItemTitle", comment: "Describes the title of the second item in the navigation bar (should be the news tab)")
        
        //
        tableView.register(UINib(nibName: "BaseCell", bundle: nil), forCellReuseIdentifier: "baseCell")
        query = baseQuery()
    }
    
    override internal final func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeData()
    }
    
    override internal final func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopObserving()
    }
    
    /* MARK: */    
    func baseQuery() -> Query {
        return Firestore.firestore().collection("news").order(by: "timestamp", descending: true)
    }
    
    func observeData() {
        guard let query = query else  { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> New in
                if let model = New(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(New.self) with dictionary \(document.data())")
                }
            }
            self.data = models
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func stopObserving() {
        listener?.remove()
    }
    
    /* MARK: Table view configuration */
    override internal final func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseCell
        
        let new = data[indexPath.row] as! New
        cell.populateCell(withNew: new)
        
        return cell
    }
    
    override internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

