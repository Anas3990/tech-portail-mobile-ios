//
//  DashboardController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

//
import FirebaseFirestore

class DashBoardController: UIViewController  {
    
    //
    private var events: [EventObject] = []
    private var documents: [DocumentSnapshot] = []
    

    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeRecentEvents()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Définir le nom de la vue
        self.title = "Accueil"
        
    
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeRecentEvents()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("events").order(by: "timestamp", descending: true).limit(to: 7)
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeRecentEvents() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> EventObject in
                if let model = EventObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(EventObject.self) with dictionary \(document.data())")
                }
            }
            self.events = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
}
