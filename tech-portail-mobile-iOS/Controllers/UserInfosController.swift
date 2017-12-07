//
//  UserInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore

class UserInfosController: UITableViewController {
    //
    var user: UserObject?
    var userReference: DocumentReference?
    
    //
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var mobilePhoneNumberLabel: UITableViewCell!
    @IBOutlet weak var homePhoneNumber1Label: UILabel!
    @IBOutlet weak var homePhoneNumber2Label: UILabel!
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> UserInfosController {
        let controller = storyboard.instantiateViewController(withIdentifier: "UserInfosController") as! UserInfosController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user?.firstName
        
        //
        
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        self.firstNameLabel.text = user?.firstName
        self.nameLabel.text = user?.name
        self.emailLabel.text = user?.email
    }
}
