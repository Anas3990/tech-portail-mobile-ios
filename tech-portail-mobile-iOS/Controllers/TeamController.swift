//
//  TeamController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-03-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TeamController: UITableViewController {
    
    private var students = [User]()
    private var mentors = [User]()


    /* MARK: View's lifecycle */
    override internal final func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.students.count
            
        case 1:
            return self.mentors.count
            
        default:
            return students.count
        }
    }
    
    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamMemberCell", for: indexPath)
        
        return cell
    }
}
