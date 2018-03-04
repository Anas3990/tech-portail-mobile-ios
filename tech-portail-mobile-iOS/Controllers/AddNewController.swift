//
//  AddNewController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-14.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import Eureka

class AddNewController: FormViewController {
    
    private let dbProvider: DatabaseProvider = DatabaseProvider()
    
    override internal final func viewDidLoad() {
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
                
        // Formulaire
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Titre"
                row.tag = "title"
                
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
                $0.tag = "body"
                
                let dynamicHeight: TextAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 100)
                $0.textAreaHeight = dynamicHeight
        }
    }
        
    @objc private final func handlePost() {
        guard let titleRow: TextRow = form.rowBy(tag: "title") else { return }
        guard let bodyRow: TextRow = form.rowBy(tag: "body") else { return }
        
        let new: New = New(title: titleRow.value ?? "Aucun titre n'a été fourni.", body: bodyRow.value ?? "Aucune description n'a été fournie.", author: ["name": "Anas Merbouh", "email": "anas.merbouh@outlook.com"], timestamp: Date())
        
        self.dbProvider.publsishNew(new) { (error) in
            if let error = error {
                print(error)
                
                return
            }
        }
    }
    
    @objc private final func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
