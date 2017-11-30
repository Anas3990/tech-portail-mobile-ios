//
//  UsersControllerTableViewController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

import FirebaseFirestore
import FirebaseCrash

class TeamController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var usersTableView: UITableView!
    
    //
    let backgroundView = UIImageView()
    
    // Référence à la classe AuthService
    let authService = AuthService()
    
    // Déclaration de l'array d'utilisateur
    private var users: [UserObject] = []
    private var documents: [DocumentSnapshot] = []
    
    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeUsers()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeUsers()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("users").whereField("role", isEqualTo: "junior_mentor").order(by: "name")
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeUsers() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> UserObject in
                if let model = UserObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(UserObject.self) with dictionary \(document.data())")
                }
            }
            self.users = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Se déconnecter", message: "Êtes-vous sûrs de vouloir vous déconnecter du Tech Portail ?", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Non", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        
        // Action à effectuer si le bouton "Envoyer" est appuyé
        let alertActionConfirm = UIAlertAction(title: "Oui", style: .default) {
            (_) in
            // Stocker la valeur retournée par la fonction "doLogout()" dans la constante "isLogoutSuccessful"
            let isLogoutSuccessful = self.authService.logout()
            
            // Si l'utilisateur a été capable de se déconnecter, enlever son token et le rediriger vers la page de connexion
            if isLogoutSuccessful == true {
                let loginCtrl = LoginController()
                self.present(loginCtrl, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de déconnexion !", preferredStyle: .alert)
                
                let alertActionOkay = UIAlertAction(title: "Non", style: .default, handler: nil)
                alertVC.addAction(alertActionOkay)
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        alertVC.addAction(alertActionConfirm)
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Retourner autant de cellules qu'il y a de nouvelles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
 
    // Populer la cellule des informations sur la nouvelle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        //
        let user = users[indexPath.row]
        
        cell.populate(user: user)
        
        return cell
    }
    
    // Action à effectuer lorsqu'une cellule a été sélectionnée
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfosCtrl = UserInfosController.fromStoryboard()
        userInfosCtrl.user = users[indexPath.row]
        userInfosCtrl.userReference = documents[indexPath.row].reference
        
        self.navigationController?.pushViewController(userInfosCtrl, animated: true)
    }
}

// Classe de la cellule d'un utilisateur
class UserCell: UITableViewCell {
    // Référence aux éléments de l'interface de l'application
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func populate(user: UserObject) {
        //
        nameLabel.text = "\(user.firstName) \(user.name)"
        emailLabel.text = user.email
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
