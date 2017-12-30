//
//  MyAttendancesInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-29.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class MyAttendancesInfosController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
    }
}
