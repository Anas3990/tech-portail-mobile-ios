//
//  AddAttendanceController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

// Importation de modules supplémentaires pour construire des formulaires plus facilemment
import Eureka

import FirebaseFirestore
import FirebaseAuth

class AddAttendanceController: FormViewController {
    
    //
    var eventReference: DocumentReference?
    var eventStartDate: Date?
    var eventEndDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration générale de la vue
        self.title = "Confirmer ma présence"
        
        // Personnaliser la couleur de la barre de navigation
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = .black
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .white
        
        // Configuration des boutons de la vue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handlePostAttendance))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(handleCancel))
        
        // Formulaire
        form +++ Section()
            <<< TimeInlineRow() { startDateRow in
                startDateRow.title = "De"
                startDateRow.tag = "attendanceStartsAt"
                
                startDateRow.value = eventStartDate
                startDateRow.minimumDate = eventStartDate
            }
            <<< TimeInlineRow() { endDateRow in
                endDateRow.title = "À"
                endDateRow.tag = "attendanceEndsAt"
                
                endDateRow.value = eventEndDate
                endDateRow.maximumDate = eventEndDate
            }
    }
    
    @objc func handlePostAttendance() {
        if let attendanceStartsAtRow: TimeInlineRow = form.rowBy(tag: "attendanceStartsAt"), let attendanceEndsAtRow: TimeInlineRow = form.rowBy(tag: "attendanceEndsAt") {
            if let attendanceStartsAt = attendanceStartsAtRow.value, let attendanceEndsAt = attendanceEndsAtRow.value {
                guard let reference = eventReference else { return }
                let attendancesCollection = reference.collection("attendances")
                let attendanceReference = attendancesCollection.document(Auth.auth().currentUser!.uid)
                
                attendanceReference.setData(["attendantName": "Anas Merbouh", "present": true, "attendanceStartsAt": attendanceStartsAt, "attendanceEndsAt": attendanceEndsAt, "confirmedAt": FieldValue.serverTimestamp()], completion: { (error) in
                    if let error = error {
                        // Alerte à afficher si une erreur est survenue
                        let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de confirmation de votre présence : \(error.localizedDescription)" , preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                       self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                // Alerte à afficher si les champs requis ne sont pas remplis
                let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer que tous les champs obligatoires soient remplis avant de confirmer votre présence." , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
