//
//  EditPasswordController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-11.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import Eureka

//
import FirebaseAuth

class EditPasswordController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Modifier mon mot de passe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Terminé", style: .plain, target: self, action: #selector(handleEditPassword))
                
        // Formulaire
        form +++ Section(footer: "Vous devez choisir un mot de passe d'au minimum 6 caractères.")
            <<< PasswordRow() { row in
                row.placeholder = "Votre nouveau mot de passe"
                row.tag = "newPassword"
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< PasswordRow() { row in
                row.placeholder = "Confirmez votre nouveau mot de passe"
                row.tag = "newPasswordConfirmed"
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
    }
    
    @objc func handleEditPassword() {
        if let newPasswordRow: PasswordRow = form.rowBy(tag: "newPassword"), let newPasswordConfirmedRow: PasswordRow = form.rowBy(tag: "newPasswordConfirmed") {
            if let newPassword = newPasswordRow.value, let newPasswordConfirmed = newPasswordConfirmedRow.value {
                //
                if newPassword != newPasswordConfirmed {
                    let alertController = UIAlertController(title: "Oups !", message: "Les deux champs ne sont pas identiques." , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    Auth.auth().currentUser!.updatePassword(to: newPasswordConfirmed) { (error) in
                        if let error = error {
                            // Alerte à afficher si la tentative de modification du mot de passe a échouée
                            let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de modification de votre mot de passe." , preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default)
                            alertController.addAction(OKAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            return
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                // Alerte à afficher si les champs ne sont pas remplis
                let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer de remplir tous les champs." , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
}
