//
//  AttendanceEndDatePopupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AttendanceEndDatePopupController: UIViewController {
    //
    @IBOutlet weak var attendanceEndDatePicker: UIDatePicker!
    
    //
    var eventReference: DocumentReference?
    var event: Event!
    var attendanceStartDate: Date!
    var attendanceEndDate: Date!
    
    var currentUserFullName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendanceEndDatePicker.date = attendanceEndDate
    }
    
    @IBAction func postAttendanceButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
