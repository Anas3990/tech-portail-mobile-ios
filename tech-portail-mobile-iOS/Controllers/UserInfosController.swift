//
//  UserInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

class UserInfosController: UITableViewController {
    //
    var user: UserObject?
    var userReference: DocumentReference?
    
    //
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var additionalDataTitle: UILabel!
    @IBOutlet weak var additionalDataLabel: UILabel!
    
    @IBOutlet weak var mobilePhoneNumberLabel: UILabel!
    @IBOutlet weak var homePhoneNumber1Label: UILabel!
    @IBOutlet weak var homePhoneNumber2Label: UILabel!
    
    @IBOutlet weak var homePhoneNumber1Cell: UITableViewCell!
    @IBOutlet weak var homePhoneNumber2Cell: UITableViewCell!
    
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> UserInfosController {
        let controller = storyboard.instantiateViewController(withIdentifier: "UserInfosController") as! UserInfosController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user?.firstName
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        //
        if let user = user {
            self.firstNameLabel.text = user.firstName
            self.nameLabel.text = user.name
            self.emailLabel.text = user.email
            
            if user.roles["mentor"] != true {
                self.additionalDataTitle.text = "Groupe"
                self.additionalDataLabel.text = user.group
                
                self.mobilePhoneNumberLabel.text = user.mobilePhoneNumber
                self.homePhoneNumber1Label.text = user.homePhoneNumber1
                self.homePhoneNumber2Label.text = user.homePhoneNumber2
            } else {
                self.additionalDataTitle.text = "Titre professionnel"
                self.additionalDataLabel.text = user.professionalTitle
                
                self.mobilePhoneNumberLabel.text = user.mobilePhoneNumber
                self.homePhoneNumber1Cell.isHidden = true
                self.homePhoneNumber2Cell.isHidden = true
            }
        } else {
            
        }
    }
}
