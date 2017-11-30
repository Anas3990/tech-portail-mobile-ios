//
//  DocumentsController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-29.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore

class DocumentsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var foldersTableView: UITableView!
    
    //
    let backgroundView = UIImageView()
    
    
    // Déclaration de l'array de nouvelles
    private var folders: [FolderObject] = []
    private var documents: [DocumentSnapshot] = []
    
    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeFolders()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        foldersTableView.dataSource = self
        foldersTableView.delegate = self
        
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeFolders()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("folders").order(by: "timestamp", descending: true)
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }

    //
    func observeFolders() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> FolderObject in
                if let model = FolderObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(FolderObject.self) with dictionary \(document.data())")
                }
            }
            self.folders = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.foldersTableView.reloadData()
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
    
    // Retourner autant de cellules qu'il y a de dossiers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    // Populer la cellule des informations sur le dossier
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! FolderCell
        
        //
        let folder = folders[indexPath.row]
        
        //
        cell.populate(folder: folder)
        
        return cell
    }
        
}

// Classe de la cellule d'un dossier
class FolderCell: UITableViewCell {
    // Référence aux éléments de l'interface de l'application
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    func populate(folder: FolderObject) {
        //
        timestampLabel.text = "Dernière modification le \(folder.timestamp)"
        nameLabel.text = folder.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
