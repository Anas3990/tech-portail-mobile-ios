//
//  AddEventController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-13.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation
import Eureka

class AddEventController: FormViewController {
    
    private let dbProvider: DatabaseProvider = DatabaseProvider()
    
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
    @objc private final func handlePost() {
        guard let titleRow: TextRow = form.rowBy(tag: "title") else { return }
        guard let startDateRow: DateTimeInlineRow = form.rowBy(tag: "startDate") else { return }
        guard let endDateRow: TimeInlineRow = form.rowBy(tag: "endDate") else { return }
        guard let descriptionRow: TextAreaRow = form.rowBy(tag: "body") else { return }
        
        let event: Event = Event(author: ["name": "Anas Merbouh", "email": "anas.merbouh@outlook.com"], body: descriptionRow.value ?? "Aucune description n'a été fournie.", endDate: endDateRow.value ?? Date(), startDate: startDateRow.value ?? Date(), timestamp: Date(), title: titleRow.value ?? "Aucun titre n'a été fourni.")
        
        self.dbProvider.publishEvent(event) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
 
    @objc private final func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

