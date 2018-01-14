//
//  SettingsController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-10.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

class SettingsController: UITableViewController {
    
    // Référence à la classe AuthService
    let authService = AuthService()
    
    //
    let user = Auth.auth().currentUser!
    
    //
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        userEmailLabel.text = self.user.email
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersionLabel.text = appVersion
        }
        
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.buildNumberLabel.text = buildNumber
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
                let userRef = Firestore.firestore().collection("users").document(user.uid)
                
                userRef.getDocument { (document, error) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de récupération de votre compte : \(error.localizedDescription)" , preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    } else {
                        if document?.exists ==  true {
                            let userDocument = document.flatMap({ UserObject(dictionary: $0.data()) })
                            let accountSettingsCtrl = AccountSettingsController()
                            
                            accountSettingsCtrl.currentUser = userDocument
                            
                            self.navigationController?.pushViewController(accountSettingsCtrl, animated: true)
                        } else {
                            let alertController = UIAlertController(title: "Oups !", message: "Les informations sur votre compte n'ont pas pu être récupérées. Si ce problème persiste, veuillez contacter l'administrateur." , preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default)
                            alertController.addAction(OKAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                            return
                        }
                    }
                }
            default:
                break;
            }
        case 1:
            switch indexPath.row {
            case 0:
                let editNotificationsSettingsCtrl = EditNotificationsSettingsController()
                
                self.navigationController?.pushViewController(editNotificationsSettingsCtrl, animated: true)
            default:
                break
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
                
                // Action à effectuer si le bouton "Continuer" est appuyé
                let alertActionModify = UIAlertAction(title: "Continuer", style: .default) {
                    (_) in
                    let emailTextField = alertController.textFields![0]
                    let passwordTextField = alertController.textFields![1]
                    
                    if let email = emailTextField.text, let password = passwordTextField.text {
                        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
                        
                        self.user.reauthenticate(with: credential, completion: { (error) in
                            if let error = error {
                                let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de vérification de votre identité : \(error.localizedDescription)" , preferredStyle: .alert)
                                
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                return
                            } else {
                                let editPasswordCtrl = EditPasswordController()
                                
                                self.navigationController?.pushViewController(editPasswordCtrl, animated: true)
                            }
                        })
                    } else {
                        // Alerte à afficher si l'appareil de l'utilisateur n'a pas entré les informations requises
                        let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer de remplir tous les champs avant de continuer." , preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                }
                alertController.addAction(alertActionModify)
                
                self.present(alertController, animated: true, completion: nil)
            default:
                break
            }
        case 3:
            break
        case 4:
            switch indexPath.row {
                case 0:
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
                default:
                    break
            }
        default:
            break
        }
    }
    
    @IBAction func okTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
