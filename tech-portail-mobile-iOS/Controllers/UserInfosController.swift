//
//  UserInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import MessageUI

import FirebaseFirestore

class UserInfosController: UITableViewController, MFMailComposeViewControllerDelegate {
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
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        self.firstNameLabel.text = user?.firstName
        self.nameLabel.text = user?.name
        self.emailLabel.text = user?.email
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            // Alerte à afficher si l'appareil de l'utilisateur ne supporte pas cette fonctionnalité
            let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative d'envoi du courriel : \(error.localizedDescription)" , preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        } else {
            // Dismiss the mail compose view controller.
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    // Fonction qui permet à un utilisateur
    @IBAction func sendMailBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !MFMailComposeViewController.canSendMail() {
            // Alerte à afficher si l'appareil de l'utilisateur ne supporte pas cette fonctionnalité
            let alertController = UIAlertController(title: "Oups !", message: "Il semble que votre téléphone ne supporte pas cette fonctionnalité." , preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        } else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configuration du courriel de la personne à qui le message sera envoyé
            composeVC.setToRecipients([self.user!.email])
            
            self.present(composeVC, animated: true, completion: nil)
        }
    }
}
