//
//  AttendanceStartDatePopupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import FirebaseFirestore

class AttendanceStartDatePopupController: UIViewController {
    //
    @IBOutlet weak var eventScheduleLabel: UILabel!
    @IBOutlet weak var eventScheduleDateLabel: UILabel!
    @IBOutlet weak var attendanceStartDatePicker: UIDatePicker!
    
    //
    var eventReference: DocumentReference?
    var eventStartDate: Date?
    var eventEndDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventScheduleLabel.text = "Début de l'évènement"
        
        
        if let eventStartDate = eventStartDate {
            attendanceStartDatePicker.date = eventStartDate
            eventScheduleDateLabel.text = DateFormatter.localizedString(from: eventStartDate, dateStyle: .none, timeStyle: .short)
        } else {
            attendanceStartDatePicker.date = Date()
            attendanceStartDatePicker.minimumDate = Date()
            eventScheduleDateLabel.text = "N/A"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendanceEndDatePopup" {
            if let vc = segue.destination as? AttendanceEndDatePopupController {
                //
                self.eventScheduleLabel.text = "Fin de l'évènement"
                
                
                if let eventEndDate = eventEndDate {
                    self.eventScheduleDateLabel.text = DateFormatter.localizedString(from: eventEndDate, dateStyle: .none, timeStyle: .short)
                } else {
                    eventScheduleDateLabel.text = "N/A"
                }
                
                //
                vc.attendanceStartDate = self.attendanceStartDatePicker.date
                vc.attendanceEndDate = self.eventEndDate
                vc.eventReference = self.eventReference
            }
        }
    }
}
