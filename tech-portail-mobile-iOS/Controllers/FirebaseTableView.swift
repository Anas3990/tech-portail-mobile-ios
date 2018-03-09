//
//  FirebaseTableView.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-09.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FirebaseTableView: UITableViewController {
    
    public var cellId: String = "baseFirebaseCell"
    public var cellClass: AnyClass = BaseFirebaseTableViewCell.self
    
    public var data: [New] = []
    public var documents: [DocumentSnapshot] = []
    public var listener: ListenerRegistration?
    
    public var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeData()
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellClass, forCellReuseIdentifier: cellId)
        
        query = baseQuery()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopObserving()
    }
    
    /* MARK: */
    public func baseQuery() -> Query {
        return Firestore.firestore().collection("news").order(by: "timestamp", descending: true)
    }
    
    private func stopObserving() {
        listener?.remove()
    }
    
    public func observeData() {
        guard let query = query else { return }
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
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /* MARK: */
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}


