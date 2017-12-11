//
//  EditPhoneNumberController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-10.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

class EditPhoneNumberController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Téléphone"
        
        // Personnaliser la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
    }
}
