//
//  NewsController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-14.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NewsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var newsTableView: UITableView!
    
    //
    let backgroundView = UIImageView()
    
    // Déclaration de l'array de nouvelles
    private var news: [New] = []
    private var documents: [DocumentSnapshot] = []
    
    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeNews()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeNews()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("news").order(by: "timestamp", descending: true)
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeNews() {
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
            self.news = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
    
    // Action à effectuer lorsque le bouton "+" est appuyé
    @IBAction func addNewTapped(_ sender: Any) {
        let addNewController = AddNewController()
        let navController = UINavigationController(rootViewController: addNewController)
        
        present(navController, animated: true, completion: nil)
    }

    
    // Retourner autant de cellules qu'il y a de nouvelles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    // Fonction qui permet de supprimer/modifier une nouvelle
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let modifyAction = UITableViewRowAction(style: .normal, title: "Modifier") { (action, index) in
           
        }
        
        // Couleur du boutton pour modifier une nouvelle
        modifyAction.backgroundColor = .black
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, index) in
            // Supprimer la nouvelle de Firebase
            self.documents[indexPath.row].reference.delete();
                
            // Supprimer la rangée de la table de données
            self.news.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
                
        return [deleteAction, modifyAction]
    }
    
    // Populer la cellule des informations sur la nouvelle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewTableViewCell
        
        //
        let new = news[indexPath.row]
        
        //
        cell.populate(new: new)
        
        return cell
    }

    // Action à effectuer lorsqu'une cellule a été sélectionnée
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newInfosCtrl = NewInfosController.fromStoryboard()
        newInfosCtrl.new = news[indexPath.row]
        newInfosCtrl.newReference = documents[indexPath.row].reference
        
        self.navigationController?.pushViewController(newInfosCtrl, animated: true)
    }
}
