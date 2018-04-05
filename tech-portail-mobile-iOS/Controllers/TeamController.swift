//
//  TeamController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-09.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class TeamController: UITableViewController {
    
    /* MARK: View's lifecyle */
    override internal final func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("tabBarLastItemTitle", comment: "Describes the title of the last item in the navigation bar (should be the news tab)")
    }
}
