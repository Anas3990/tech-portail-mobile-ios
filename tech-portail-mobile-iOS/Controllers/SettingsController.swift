//
//  SettingsController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-10.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import MessageUI

import FirebaseFirestore
import FirebaseAuth

class SettingsController: UITableViewController, MFMailComposeViewControllerDelegate {
    // Référence à la classe AuthService
    let authService = AuthService()
    
    //
    let user = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let editEmailCtrl = EditEmailController()
                
                self.navigationController?.pushViewController(editEmailCtrl, animated: true)
            case 1:
                let editPhoneNumberCtrl = EditPhoneNumberController()
                
                self.navigationController?.pushViewController(editPhoneNumberCtrl, animated: true)
            default:
                print("00")
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("2")
            case 1:
                print("3")
            default:
                print("11")
            }
        case 2:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Modifier mon mot de passe", message: "Pour des raisons de sécurité, veuillez indiquer votre courriel ainsi que votre mot de passe avant d'effectuer cette opération.", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Annuler", style: .default, handler: nil)
                alertController.addAction(alertActionCancel)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.keyboardType = UIKeyboardType.emailAddress
                    textField.placeholder = "Votre courriel"
                }
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "Votre mot de passe"
                }
                
                // Action à effectuer si le bouton "Envoyer" est appuyé
                let alertActionSend = UIAlertAction(title: "Continuer", style: .default) {
                    (_) in
                    let emailTextField = alertController.textFields![0]
                    let passwordTextField = alertController.textFields![1]
                    
                    var credential: AuthCredential
                    
                    
                   
                }
                alertController.addAction(alertActionSend)
                
                self.present(alertController, animated: true, completion: nil)
            case 1:
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
                    composeVC.setToRecipients(["webmaster@team3990.com "])
                    
                    self.present(composeVC, animated: true, completion: nil)
                }
            case 2:
                print("5")
            default:
                print("22")
            }
        default:
            print("lol")
        }
    }
    
    @IBAction func disconnectTapped(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Se déconnecter", message: "Êtes-vous sûrs de vouloir vous déconnecter du Tech Portail ?", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Non", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        
        // Action à effectuer si le bouton "Envoyer" est appuyé
        let alertActionConfirm = UIAlertAction(title: "Oui", style: .default) {
            (_) in
            // Stocker la valeur retournée par la fonction "doLogout()" dans la constante "isLogoutSuccessful"
            let isLogoutSuccessful = self.authService.logout()
            
            // Si l'utilisateur a été capable de se déconnecter, enlever son token et le rediriger vers la page de connexion
            if isLogoutSuccessful == true {
                let loginCtrl = LoginController()
                self.present(loginCtrl, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de déconnexion !", preferredStyle: .alert)
                
                let alertActionOkay = UIAlertAction(title: "Non", style: .default, handler: nil)
                alertVC.addAction(alertActionOkay)
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        alertVC.addAction(alertActionConfirm)
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func okTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
