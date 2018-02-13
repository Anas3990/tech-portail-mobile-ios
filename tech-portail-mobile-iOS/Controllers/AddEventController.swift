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
    @objc func handlePost() {
        
    }
 
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

