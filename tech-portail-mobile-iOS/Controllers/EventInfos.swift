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
    
    @IBOutlet weak var isUserAttendingLabel: UILabel!
    @IBOutlet weak var attendancesCountLabel: UILabel!
    
    @IBOutlet weak var attendingCheckButton: UIButton!
    @IBOutlet weak var notAttendingCheckButton: UIButton!
    
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
 
        self.title = event?.title
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        //
        self.authorNameLabel.text = event?.author["name"]
        self.authorEmailLabel.text = event?.author["email"]
        
        //        
        self.attendancesCountLabel.text = "personne(s) y participe(nt)"
        
        //
        let dateOnlyFormatter = DateFormatter()
        let timeOnlyFormatter = DateFormatter()
        
        //
        dateOnlyFormatter.dateFormat = "EEEE dd MMMM"
        timeOnlyFormatter.dateFormat = "hh:mm"
        
        self.startDate.text = "le " + dateOnlyFormatter.string(from: (event?.startDate)!) + ", " + " à " + timeOnlyFormatter.string(from: (event?.startDate)!)
        self.endDate.text = "le " + dateOnlyFormatter.string(from: (event?.startDate)!) + ", " + " à " + timeOnlyFormatter.string(from: (event?.endDate)!)
        
        //
        self.descriptionTextView.text = event?.body
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
        
        attendanceReference.setData(["nonAttendantName": "Anas Merbouh", "present": false, "confirmedAt": FieldValue.serverTimestamp()]) { (error) in
            if let error = error {
                // Alerte à afficher si une erreur est survenue
                let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de confirmation de votre absence : \(error.localizedDescription)" , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendancesSegue" {
            guard let reference = eventReference else { return }
            
            let attendancesCtrl = AttendancesController.fromStoryboard()
            attendancesCtrl.eventReference = reference
        } else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
