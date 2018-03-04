//
//  TeamController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class TeamController: UITableViewController {
    
    private let authProvider: AuthProvider = AuthProvider()
    
    override internal final func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logoutTaped(_ sender: UIBarButtonItem) {
        self.authProvider.disconnetUser { (error) in
            if let error = error {
                print(error)
                
                return
            }
            
            self.navigationController?.present(LoginController(), animated: true, completion: nil)
        }
    }
}
