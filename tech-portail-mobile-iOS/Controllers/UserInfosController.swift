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
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
  
    @IBOutlet weak var mobilePhoneNumberLabel: UILabel!
    @IBOutlet weak var homePhoneNumber1Label: UILabel!
    @IBOutlet weak var homePhoneNumber2Label: UILabel!
    
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
        profilePictureImageView.loadImageUsingCacheWithUrlString(urlString: user.photoUrl)
            self.fullNameLabel.text = "\(user.firstName) \(user.name)"
            self.emailLabel.text = user.email
            
            if user.roles["mentor"] != true {
                self.roleLabel.text = "Élève"
                
                self.mobilePhoneNumberLabel.text = user.mobilePhoneNumber
                self.homePhoneNumber1Label.text = user.homePhoneNumber1
                self.homePhoneNumber2Label.text = user.homePhoneNumber2
            } else {
                self.roleLabel.text = "Mentor"
                
                self.mobilePhoneNumberLabel.text = user.mobilePhoneNumber
                self.homePhoneNumber1Label.isHidden = true
                self.homePhoneNumber2Label.isHidden = true
            }
        } else {
            
        }
    }
}
