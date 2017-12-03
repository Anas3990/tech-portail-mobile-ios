//
//  EventsController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-12.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

import FirebaseFirestore
import FirebaseCrash

class EventsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var eventsTableView: UITableView!
    @IBOutlet weak var eventsFilterSegmentedControl: UISegmentedControl!
    
    //
    let backgroundView = UIImageView()
    
    // Déclaration de l'array d'évènements
    private var events = [EventObject]()
    private var documents: [DocumentSnapshot] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeEvents()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        backgroundView.contentMode = .scaleAspectFit
        backgroundView.alpha = 0.5
        eventsTableView.backgroundView = backgroundView
        
        //
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        //
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
        return Firestore.firestore().collection("events").whereField("past", isEqualTo: false).order(by: "timestamp", descending: true)
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
            let models = snapshot.documents.map { (document) -> EventObject in
                if let model = EventObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    FirebaseCrashMessage("Unable to initialize data with dictionary")
                    fatalError("Unable to initialize type \(EventObject.self) with dictionary \(document.data())")
                }
            }
            self.events = models
            self.documents = snapshot.documents
            
            if self.documents.count > 0 {
                self.eventsTableView.backgroundView = nil
            } else {
                self.eventsTableView.backgroundView = self.backgroundView
            }
            
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }
    
    @IBAction func eventsFilterSegmentedControlSwitch(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func addEventTapped(_ sender: Any) {
        let addEventController = AddEventController()
        let navController = UINavigationController(rootViewController: addEventController)
        
        present(navController, animated: true, completion: nil)
    }
    
    // Retourner autant de cellules qu'il y a de nouvelles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    

    // Fonction qui permet de supprimer/modifier un évènement
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertVC = UIAlertController(title: "Supprimer l'évènement", message: "Êtes-vous sûr de vouloir supprimer cet évènement ? Cette action est irréversible", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Non", style: .default, handler: nil)
            alertVC.addAction(alertActionCancel)
            
            // Action à effectuer si le bouton "Envoyer" est appuyé
            let alertActionDelete = UIAlertAction(title: "Oui", style: .default) {
                (_) in
                // Supprimer l'évènement de Firebase
                self.documents[indexPath.row].reference.delete();
                
                // Supprimer la rangée de la table de données
                self.events.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alertVC.addAction(alertActionDelete)
            
            
            self.present(alertVC, animated: true, completion: nil)
        }
     }
    
    // Populer la cellule des informations sur la nouvelle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        
        //
        let event = events[indexPath.row]
        
        //
        cell.populate(event: event)
        
        return cell
    }
    
    // Action à effectuer lorsqu'une cellule a été sélectionnée
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventInfosCtrl = EventInfosController.fromStoryboard()
        eventInfosCtrl.event = events[indexPath.row]
        eventInfosCtrl.eventReference = documents[indexPath.row].reference
        
        self.navigationController?.pushViewController(eventInfosCtrl, animated: true)
    }
}

// Classe de la cellule d'un utilisateur
class EventCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func populate(event: EventObject) {
        //
        let dateOnlyFormatter = DateFormatter()
        let timeOnlyFormatter = DateFormatter()
        
        dateOnlyFormatter.dateFormat = "EEEE dd MMMM"
        timeOnlyFormatter.dateFormat = "hh:mm"
        
        //
        dateLabel.text = "Le " + dateOnlyFormatter.string(from: event.startDate) + ", de " + timeOnlyFormatter.string(from: event.startDate) + " à " + timeOnlyFormatter.string(from: event.endDate)
        titleLabel.text = event.title
        bodyLabel.text = event.body
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
