//
//  TeamController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class TeamController: UITableViewController {
    
    private let authProvider: AuthProvider = AuthProvider()
    
    override internal final func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logoutTaped(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Se déconnecter", message: "Êtes-vous sûrs de vouloir vous déconnecter du Tech Portail ?", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Non", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        
        let alertActionConfirm = UIAlertAction(title: "Oui", style: .default) {
            (_) in
            self.authProvider.disconnetUser(completion: { (error) in
                if let error = error {
                    let alertVC = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de déconnexion : \(error.localizedDescription)", preferredStyle: .alert)
                    
                    let alertActionOkay = UIAlertAction(title: "Non", style: .default, handler: nil)
                    alertVC.addAction(alertActionOkay)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    return
                }
                
                self.present(LoginController(), animated: true, completion: nil)
            })
        }
        alertVC.addAction(alertActionConfirm)
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
