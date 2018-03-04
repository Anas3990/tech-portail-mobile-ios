//
//  EventsController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-12.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventsController: UITableViewController {
    
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var eventsTableView: UITableView!
    
    // Déclaration de l'array d'évènements
    private var events = [Event]()
    private var documents: [DocumentSnapshot] = []
    
    private var listener: ListenerRegistration?
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeEvents()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        eventsTableView.dataSource = self

        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeEvents()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("events").whereField("startDate", isLessThan: Date())
    }
    

    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeEvents() {
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
            self.events = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }

    @IBAction func addEventTapped(_ sender: Any) {
        let addEventController = AddEventController()
        let navController = UINavigationController(rootViewController: addEventController)
        
        present(navController, animated: true, completion: nil)
    }
    
    /* MARK: Upcoming Attendances collection view */
    
    
    /* MARK: Events table view */
    override internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override internal final func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let modifyAction = UITableViewRowAction(style: .normal, title: "Modifier") { (action, index) in
            
        }
        
        // Couleur du boutton pour modifier un évènement
        modifyAction.backgroundColor = .black
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, index) in
            // Supprimer l'évènement de Firebase
            self.documents[indexPath.row].reference.delete();
                
            // Supprimer la rangée de la table de données
            self.events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [deleteAction, modifyAction]
    }

    override internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        //
        let event = events[indexPath.row]
        
        //
        cell.populate(event: event)
        
        return cell
    }
    
    /* MARK: Navigation */
    override internal final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventInfosCtrl = EventInfosController.fromStoryboard()
        
        eventInfosCtrl.event = events[indexPath.row]
        eventInfosCtrl.eventReference = documents[indexPath.row].reference
        
        self.navigationController?.pushViewController(eventInfosCtrl, animated: true)
    }
}
