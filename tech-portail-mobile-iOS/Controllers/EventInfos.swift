//
//  EventInfos.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

class EventInfosController: UITableViewController {
    // Références aux éléments de l'interface de l'application    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorEmailLabel: UILabel!
    
    @IBOutlet weak var attendancesCountLabel: UILabel!
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //
    var event: EventObject?
    var eventReference: DocumentReference?
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> EventInfosController {
        let controller = storyboard.instantiateViewController(withIdentifier: "EventInfosController") as! EventInfosController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        
        self.title = event?.title
        
        self.authorNameLabel.text = event?.author["name"]
        self.authorEmailLabel.text = event?.author["email"]
        
        self.attendancesCountLabel.text = "personne(s) y participe(nt)"
        
        self.startDate.text = dateFormatter.string(from: (event?.startDate)!)
        self.endDate.text = dateFormatter.string(from: (event?.endDate)!)
        
        self.descriptionTextView.text = event?.body
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendancesListSegue" {
            let attendancesCtrl = AttendancesController()
            
            attendancesCtrl.eventReference = self.eventReference
        }
    }
    
    @IBAction func presentTapped(_ sender: Any) {
        let addAttendanceCtrl = AddAttendanceController()
        let navController = UINavigationController(rootViewController: addAttendanceCtrl)
        
        addAttendanceCtrl.eventReference = self.eventReference
        addAttendanceCtrl.eventStartDate = self.event?.startDate
        addAttendanceCtrl.eventEndDate = self.event?.endDate
        
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func absentTapped(_ sender: Any) {
        guard let reference = eventReference else { return }
        let attendancesCollection = reference.collection("attendances")
        let attendanceReference = attendancesCollection.document(Auth.auth().currentUser!.uid)
        
        let firestore = Firestore.firestore()
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let eventSnapshot: DocumentSnapshot
            do {
                try eventSnapshot = transaction.getDocument(reference)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            guard let event = EventObject(dictionary: eventSnapshot.data()) else {
                let error = NSError(domain: "TechPortailErrorDomain", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to write to attendance at Firestore path: \(reference.path)"
                ])
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.setData(["nonAttendantName": "Anas Merbouh", "present": false, "confirmedAt": FieldValue.serverTimestamp()], forDocument: attendanceReference)
            
            return nil
        }) { (object, error) in
            if let error = error {
                print(error)
            } else {
                print("Absence confirmée")
            }
        }
    }
    
   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
