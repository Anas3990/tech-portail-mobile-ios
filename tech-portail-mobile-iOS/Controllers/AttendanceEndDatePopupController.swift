//
//  AttendanceEndDatePopupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import FirebaseFirestore
import FirebaseAuth

//
import StatusAlert

class AttendanceEndDatePopupController: UIViewController {
    
    // Déclaration de l'objet AuthService
    let authService = AuthService()
    
    //
    @IBOutlet weak var attendanceEndDatePicker: UIDatePicker!
    
    //
    var eventReference: DocumentReference?
    var event: EventObject!
    var attendanceStartDate: Date!
    var attendanceEndDate: Date!
    
    var currentUserFullName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        authService.getCurrentUserData { (userData) in
            self.currentUserFullName = "\(userData.firstName) \(userData.name)"
        }
        
        attendanceEndDatePicker.date = attendanceEndDate
    }
    
    @IBAction func postAttendanceButtonTapped(_ sender: Any) {
        guard let reference = eventReference else { return }
        
        //
        let batch = Firestore.firestore().batch()
        
        //
        let attendancesCollection = reference.collection("attendances")
        let attendanceReference = attendancesCollection.document(Auth.auth().currentUser!.uid)
        
        batch.setData(["attendantName": self.currentUserFullName ?? "", "present": true, "attendanceStartsAt": attendanceStartDate, "attendanceEndsAt": attendanceEndDatePicker.date, "confirmedAt": FieldValue.serverTimestamp()], forDocument: attendanceReference)
        
        let usersCollection = Firestore.firestore().collection("users")
        let currentUserAttendancesEventDocument = usersCollection.document(Auth.auth().currentUser!.uid).collection("attendances").document(reference.documentID)
        
        batch.setData(["eventTitle": self.event.title, "eventStartDate": self.event.startDate, "eventEndDate": self.event.endDate, "eventBody": self.event.body, "attendanceStartsAt": attendanceStartDate, "attendanceEndsAt": attendanceEndDatePicker.date, "confirmedAt": FieldValue.serverTimestamp()], forDocument: currentUserAttendancesEventDocument)
        

        batch.commit { (error) in
            if let error = error {
                // Alerte à afficher si une erreur est survenue
                let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de confirmation de votre présence : \(error.localizedDescription)" , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                //
                let statusAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "presenceConfirmedIcon"), title: "Présent", message: "Votre présence a été confirmée avec succès.")
                
                //
                statusAlert.show()
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
