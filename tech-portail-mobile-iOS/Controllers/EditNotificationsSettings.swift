//
//  EditNotificationsSettings.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-23.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilement
import Eureka

class EditNotificationsSettingsController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Notifications"
        
        // Formulaire
        form +++ Section()
            <<< SwitchRow() { row in
                row.title = "Ne pas déranger"
            }
            +++ Section(footer: "Affichez ou masquez les aperçus des messages dans les alertes et les bannières quand vous n'utilisez pas l'application.")
            <<< SwitchRow() { row in
                row.title = "Voir les aperçus"
            }
    }
}
