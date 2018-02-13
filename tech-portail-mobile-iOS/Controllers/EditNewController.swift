//
//  EditNewController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-06.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import Eureka

class EditNewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Modif. nouvelle"
        
        // Personnaliser la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        // Configuration des boutons de la vue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modifier", style: .plain, target: self, action: #selector(handlePost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        
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
                
                //
                let dynamicHeight: TextAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 100)
                $0.textAreaHeight = dynamicHeight
        }
    }
    
    @objc func handlePost() {
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

