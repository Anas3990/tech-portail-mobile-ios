//
//  ActivityDetailController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas Merbouh on 18-02-13.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class ActivityDetailController: UITableViewController {
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> ActivityDetailController {
        let controller = storyboard.instantiateViewController(withIdentifier: "ActivityDetailController") as! ActivityDetailController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
