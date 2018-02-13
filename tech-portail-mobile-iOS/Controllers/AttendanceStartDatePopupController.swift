//
//  AttendanceStartDatePopupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AttendanceStartDatePopupController: UIViewController {
    //
    @IBOutlet weak var eventScheduleLabel: UILabel!
    @IBOutlet weak var eventScheduleDateLabel: UILabel!
    @IBOutlet weak var attendanceStartDatePicker: UIDatePicker!
    
    //
    var eventReference: DocumentReference?
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventScheduleLabel.text = "Début de l'évènement"
        
        attendanceStartDatePicker.date = self.event.startDate
        eventScheduleDateLabel.text = DateFormatter.localizedString(from: self.event.startDate, dateStyle: .none, timeStyle: .short)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendanceEndDatePopup" {
            if let vc = segue.destination as? AttendanceEndDatePopupController {
                //
                self.eventScheduleLabel.text = "Fin de l'évènement"
                self.eventScheduleDateLabel.text = DateFormatter.localizedString(from: self.event.endDate, dateStyle: .none, timeStyle: .short)

                //
                vc.attendanceStartDate = self.attendanceStartDatePicker.date
                vc.attendanceEndDate = self.event.endDate
                
                vc.event = self.event
                vc.eventReference = self.eventReference
            }
        }
    }
}
