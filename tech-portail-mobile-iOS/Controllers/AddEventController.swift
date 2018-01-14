//
//  AddEventController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-13.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import Foundation

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

//
import FirebaseFirestore

class AddEventController: FormViewController {

    // Déclaration de la variable qui contient la référence à l'évènement
    var eventsRef: CollectionReference?
    
    // Déclaration de l'objet AuthService
    let authService = AuthService()
    
    // Déclaration de la variable qui contient les données sur l'auteur
    var authorData: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration du titre de la vue
        title = "Nouv. évènement"
        
        // Personnalisation la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        // Configuration des boutons de la vue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handlePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        
        // Initialisation de la variable eventsRef
        eventsRef = Firestore.firestore().collection("events")
        
        // Initialisation de la variable authorData à l'aide de la méthode getCurrentUserData() du AuthService
        authService.getCurrentUserData { (retrievedData) in
            self.authorData = retrievedData
        }
        
        // Formulaire
        form +++ Section()
            <<< TextRow() { titleRow in
                titleRow.title = "Titre"
                titleRow.tag = "title"
                
                titleRow.add(rule: RuleRequired())
                titleRow.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            +++ Section()
            <<< DateTimeInlineRow() { startDateRow in
                startDateRow.title = "Début"
                startDateRow.tag = "startDate"
                
                startDateRow.value = Date()
                startDateRow.minimumDate = Date()
            }
            <<< TimeInlineRow() { endDateRow in
                endDateRow.title = "Fin"
                endDateRow.tag = "endDate"
                
                endDateRow.value = Date() + 3600
            }
            +++ Section()
            <<< TextAreaRow(){
                $0.placeholder = "Description"
                $0.tag = "body"
                
                let dynamicHeight: TextAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 100)
                $0.textAreaHeight = dynamicHeight
            }
    }

    // Fontion qui permet de publier un évènement
    @objc func handlePost() {
        // Récupérer les information saisies dans les champs
        if let titleRow: TextRow = form.rowBy(tag: "title"), let startDateRow: DateTimeInlineRow = form.rowBy(tag: "startDate"), let endDateRow: TimeInlineRow = form.rowBy(tag: "endDate"), let bodyRow: TextAreaRow = form.rowBy(tag: "body") {            
            if let title = titleRow.value, let startDate = startDateRow.value, let endDate = endDateRow.value, let body = bodyRow.value {
                //
                if let authorData = authorData {
                    if let eventsRef = eventsRef {
                        eventsRef.addDocument(data: ["author": ["name" : "\(authorData.firstName) \(authorData.name)", "email": authorData.email], "body": body, "endDate": endDate, "startDate": startDate, "timestamp": Date(), "title": title], completion: { (error) in
                            if let error = error {
                                //
                                let alertController = UIAlertController(title: "Oups !", message: "L'évènement n'a pas pu être publié : \(error.localizedDescription)" , preferredStyle: .alert)
                                
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
                
            } else if let title = titleRow.value, let startDate = startDateRow.value, let endDate = endDateRow.value {
                //
                if let authorData = authorData {
                    if let eventsRef = eventsRef {
                        eventsRef.addDocument(data: ["author": ["name" : "\(authorData.firstName) \(authorData.name)", "email": authorData.email], "body": "Aucune description n'a été fournie", "endDate": endDate, "startDate": startDate, "timestamp": Date(), "title": title], completion: { (error) in
                            if let error = error {
                                //
                                let alertController = UIAlertController(title: "Oups !", message: "L'évènement n'a pas pu être publié : \(error.localizedDescription)" , preferredStyle: .alert)
                                
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
            } else {
                // Alerte à afficher si les champs requis ne sont pas remplis
                let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer que tous les champs obligatoires soient remplis avant de publier l'évènement." , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
 
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

