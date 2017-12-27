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
    
    //
    @IBOutlet weak var attendanceEndDatePicker: UIDatePicker!
    
    //
    var eventReference: DocumentReference?
    var attendanceStartDate: Date!
    var attendanceEndDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendanceEndDatePicker.date = attendanceEndDate
    }
    
    @IBAction func postAttendanceButtonTapped(_ sender: Any) {
        guard let reference = eventReference else { return }
        let attendancesCollection = reference.collection("attendances")
        let attendanceReference = attendancesCollection.document(Auth.auth().currentUser!.uid)
        
        attendanceReference.setData(["attendantName": "Anas Merbouh", "present": true, "attendanceStartsAt": attendanceStartDate, "attendanceEndsAt": attendanceEndDatePicker.date, "confirmedAt": FieldValue.serverTimestamp()], completion: { (error) in
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
                
                //
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
