//
//  AddNewController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-14.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

//
import FirebaseFirestore

class AddNewController: FormViewController {
    
    //
    var newsRef: CollectionReference?
    
    // Déclaration de l'objet AuthService
    let authService = AuthService()
    
    // Déclaration de la variable qui contient les données sur l'auteur
    var authorData: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Nouv. nouvelle"
        
        // Personnaliser la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        // Configuration des boutons de la vue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handlePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        
        // Initialisation de la variable eventsRef
        newsRef = Firestore.firestore().collection("news")
        
        // Initialisation de la variable authorData à l'aide de la méthode getCurrentUserData() du AuthService
        authService.getCurrentUserData { (retrievedData) in
            self.authorData = retrievedData
        }
        
        // Formulaire
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Titre"
                row.tag = "Title"
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            +++ Section()
            <<< TextAreaRow() {
                $0.placeholder = "Description"
                $0.tag = "Description"
                
                let dynamicHeight: TextAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 100)
                $0.textAreaHeight = dynamicHeight
        }
    }
        
    @objc func handlePost() {
        // Récupérer les information saisies dans les champs
        if let titleRow: TextRow = form.rowBy(tag: "Title"), let descriptionRow: TextAreaRow = form.rowBy(tag: "Description") {
            if let title = titleRow.value, let description = descriptionRow.value {
                //
                if let authorData = authorData {
                    if let newsRef = self.newsRef {
                        newsRef.addDocument(data: ["author": ["name": "\(authorData.firstName) \(authorData.name)", "email": authorData.email], "title": title, "body": description, "timestamp": FieldValue.serverTimestamp()], completion: { (error) in
                            if let error = error {
                                //
                                let alertController = UIAlertController(title: "Oups !", message: "La nouvelle n'a pas pu être publiée : \(error.localizedDescription)" , preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                //
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                } else {
                    return
                }
            } else if let title = titleRow.value {
                //
                if let authorData = authorData {
                    if let newsRef = self.newsRef {
                        newsRef.addDocument(data: ["author": ["name": "\(authorData.firstName) \(authorData.name)", "email": authorData.email], "title": title, "body": "Aucune description n'a été fournie.", "timestamp": FieldValue.serverTimestamp()], completion: { (error) in
                            if let error = error {
                                //
                                let alertController = UIAlertController(title: "Oups !", message: "La nouvelle n'a pas pu être publiée : \(error.localizedDescription)" , preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                } else {
                    return
                }
            } else {
                // Alerte à afficher si aucun titre n'est fourni
                let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer de donner un titre à votre nouvelle." , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
