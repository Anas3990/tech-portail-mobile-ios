//
//  AccountSettingsController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import Eureka

//
import FirebaseFirestore

//
import StatusAlert

class AccountSettingsController: FormViewController {
    
    var currentUser: UserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Mon compte"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Terminé", style: .plain, target: self, action: #selector(handleEditAccount))
        
        form +++ Section(header: "Informations personnelles", footer: "")
            <<< TextRow() { row in
                row.title = "Prénom"
                row.tag = "userFirstName"
                
                row.value = currentUser?.firstName
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                    } else if row.isValid {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    }
            }
            <<< TextRow() { row in
                row.title = "Nom"
                row.tag = "userName"
                
                row.value = currentUser?.name
                
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                    } else if row.isValid {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    }
            }
            <<< LabelRow() { row in
                if currentUser?.roles["mentor"] == true {
                    row.title = "Titre professionnel"
                    row.tag = "userProfessionalTitle"
                    
                    row.value = currentUser?.professionalTitle
                } else {
                    row.title = "Groupe"
                    row.tag = "userGroup"
                    
                    row.value = currentUser?.group
                }
            }
            <<< LabelRow() { row in
                row.title = "Rôle"
                row.tag = "userRole"
                
                if currentUser?.roles["mentor"] == true {
                    row.value = "Mentor"
                } else {
                    row.value = "Élève"
                }
            }
            +++ Section(header: "Informations de contact", footer: "Les champs pour les numéros de téléphone sont les numéros à contacter en cas d'urgence.")
            <<< PhoneRow() { row in
                row.title = "Cellulaire"
                row.tag = "userMobilePhoneNumber"
                
                row.value = currentUser?.mobilePhoneNumber
            }
            <<< PhoneRow() { row in
                row.title = "Maison #1"
                row.tag = "userHomePhoneNumber1"
                
                row.value = currentUser?.homePhoneNumber1
                
                if currentUser?.roles["mentor"] == true {
                    row.hidden = true
                }
            }
            <<< PhoneRow() { row in
                row.title = "Maison #2"
                row.tag = "userHomePhoneNumber2"
                
                row.value = currentUser?.homePhoneNumber2
                
                if currentUser?.roles["mentor"] == true {
                    row.hidden = true
                }
            }
    }
    
    @objc func handleEditAccount() {
        let userDocRef = Firestore.firestore().collection("users").document(currentUser!.uid)
        
        if currentUser?.roles["mentor"] != true {
            guard let userFirstNameRow: TextRow = form.rowBy(tag: "userFirstName") else { return }
            guard let userNameRow: TextRow = form.rowBy(tag: "userName") else { return }
            
            guard let userMobilePhoneNumberRow: PhoneRow = form.rowBy(tag: "userMobilePhoneNumber") else { return }
            guard let userHomePhoneNumber1Row: PhoneRow = form.rowBy(tag: "userHomePhoneNumber1") else { return }
            guard let userHomePhoneNumber2Row: PhoneRow = form.rowBy(tag: "userHomePhoneNumber2") else { return }
            
            userDocRef.updateData(["firstName": userFirstNameRow.value ?? "", "name": userNameRow.value ?? "", "mobilePhoneNumber": userMobilePhoneNumberRow.value ?? "", "homePhoneNumber1": userHomePhoneNumber1Row.value ?? "", "homePhoneNumber2": userHomePhoneNumber2Row.value ?? ""], completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de modification de votre compte : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                } else {
                    //
                    let statusAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "presenceConfirmedIcon"), title: "Compte modifié", message: "Votre compte a été modifié avec succès.")
                    
                    //
                    statusAlert.show()
                }
            })
        } else {
            guard let userFirstNameRow: TextRow = form.rowBy(tag: "userFirstName") else { return }
            guard let userNameRow: TextRow = form.rowBy(tag: "userName") else { return }
            guard let userProfessionalTitleRow: LabelRow = form.rowBy(tag: "userProfessionalTitle") else { return }
            
            guard let userMobilePhoneNumberRow: PhoneRow = form.rowBy(tag: "userMobilePhoneNumber") else { return }
            
            userDocRef.updateData(["firstName": userFirstNameRow.value ?? "", "name": userNameRow.value ?? "", "professionalTitle": userProfessionalTitleRow.value ?? "", "mobilePhoneNumber": userMobilePhoneNumberRow.value ?? ""], completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de modification de votre compte : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                } else {
                    //
                    let statusAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "presenceConfirmedIcon"), title: "Compte modifié", message: "Votre compte a été modifié avec succès.")
                    
                    //
                    statusAlert.show()
                }
            })
        }
        
    }
}
