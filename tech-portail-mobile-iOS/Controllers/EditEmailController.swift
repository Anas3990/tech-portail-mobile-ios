//
//  EditEmailController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-10.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

//
import FirebaseAuth

class EditEmailController: FormViewController {
    //
    let user = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Courriel"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Terminé", style: .plain, target: self, action: #selector(handleEditEmail))
        
        // Formulaire
        form +++ Section(footer: "Vous pouvez utiliser ce courriel afin de vous connecter ou pour récupérer votre mot de passe")
            <<< EmailRow() { row in
                row.placeholder = "Votre courriel"
                row.tag = "email"
                
                row.value = user.email
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                    } else if row.isValid {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    }
        }
    }
    
    @objc func handleEditEmail() {
        if let emailRow: EmailRow = form.rowBy(tag: "email") {
            if let newEmail = emailRow.value {
                let alertController = UIAlertController(title: "Modifier mon courriel", message: "Pour des raisons de sécurité, veuillez indiquer votre courriel ainsi que votre mot de passe avant d'effectuer cette opération.", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Annuler", style: .default, handler: nil)
                alertController.addAction(alertActionCancel)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.keyboardType = UIKeyboardType.emailAddress
                    textField.placeholder = "Votre courriel"
                }
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "Votre mot de passe"
                }
                
                // Action à effectuer si le bouton "Envoyer" est appuyé
                let alertActionSend = UIAlertAction(title: "Continuer", style: .default) {
                    (_) in
                    let emailTextField = alertController.textFields![0]
                    let passwordTextField = alertController.textFields![1]
                    
                    if let email = emailTextField.text, let password = passwordTextField.text {
                        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
                        
                        self.user.reauthenticate(with: credential, completion: { (error) in
                            if let error = error {
                                let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de vérification de votre identité." , preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                return
                            } else {
                                self.user.updateEmail(to: newEmail, completion: { (error) in
                                    if let error = error {
                                        // Alerte à afficher si la tentative de modification du courriel a échouée
                                        let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de modification de votre courriel." , preferredStyle: .alert)
                                        
                                        let OKAction = UIAlertAction(title: "OK", style: .default)
                                        alertController.addAction(OKAction)
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                        return
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                            }
                        })
                    }
                }
                alertController.addAction(alertActionSend)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
