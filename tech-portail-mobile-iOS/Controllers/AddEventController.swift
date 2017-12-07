//
//  AddEventController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-13.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

class AddEventController: FormViewController {
    //
    let dbService = DatabaseService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Nouv. évènement"
        
        // Personnaliser la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        // Configuration des boutons de la vue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handlePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        
        // Formulaire
        form +++ Section()
            <<< TextRow() { titleRow in
                titleRow.title = "Titre"
                titleRow.tag = "Title"
                
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
            <<< TextAreaRow() {
                $0.placeholder = "Description"
                $0.tag = "Description"
        }
    }

    
    //
    @objc func handlePost() {
        // Récupérer les information saisies dans les champs
        if let titleRow: TextRow = form.rowBy(tag: "Title"), let startDateRow: DateTimeInlineRow = form.rowBy(tag: "startDate"), let endDateRow: TimeInlineRow = form.rowBy(tag: "endDate"), let descriptionRow: TextAreaRow = form.rowBy(tag: "Description") {
            if let title = titleRow.value, let startDate = startDateRow.value, let endDate = endDateRow.value, let description = descriptionRow.value {
                // Envoyer les informations stockées dans la constante "event" sur Firebase
                dbService.writeEvent(withTitle: title, startDate: startDate, endDate: endDate, body: description)
                    
                //
                dismiss(animated: true, completion: nil)
            } else if let title = titleRow.value, let startDate = startDateRow.value, let endDate = endDateRow.value {
                // Envoyer les informations stockées dans la constante "event" sur Firebase
                dbService.writeEvent(withTitle: title, startDate: startDate, endDate: endDate, body: "Aucune description n'a été fournie.")
                    
                //
                dismiss(animated: true, completion: nil)
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
