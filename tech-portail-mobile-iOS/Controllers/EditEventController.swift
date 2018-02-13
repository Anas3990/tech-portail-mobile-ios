//
//  EditEventController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-07.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import Eureka

class EditEventController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Modif. évènement"
        
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
                
            }
            <<< TimeInlineRow() { endDateRow in
                endDateRow.title = "Fin"
                endDateRow.tag = "endDate"
                
            }
            +++ Section()
            <<< TextAreaRow() { descriptionRow in
                descriptionRow.placeholder = "Description"
                descriptionRow.tag = "Description"
                
                //
                let dynamicHeight: TextAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 100)
                descriptionRow.textAreaHeight = dynamicHeight
        }
    }
    
    
    //
    @objc func handlePost() {

    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
