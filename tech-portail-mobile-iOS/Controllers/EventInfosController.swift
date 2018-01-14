//
//  EventInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import FirebaseFirestore
import FirebaseAuth

//
import StatusAlert

class EventInfosController: UITableViewController {
    
    // Déclaration de l'objet AuthService
    let authService = AuthService()
    
    // Références aux éléments de l'interface de l'application
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorEmailLabel: UILabel!
    
    @IBOutlet weak var isUserAttendingLabel: UILabel!
    @IBOutlet weak var attendanceCommentLabel: UILabel!
    
    @IBOutlet weak var attendingCheckButton: UIButton!
    @IBOutlet weak var notAttendingCheckButton: UIButton!
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //
    var event: EventObject?
    var eventReference: DocumentReference?
    var attendanceReference: DocumentReference?
    var currentUserAttendancesEventDocument: DocumentReference?
    
    var currentUserFullName: String?
    
    private var listener: ListenerRegistration?
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeUserAttendance()
            }
        }
    }
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> EventInfosController {
        let controller = storyboard.instantiateViewController(withIdentifier: "EventInfosController") as! EventInfosController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Configuration du titre de la vue
        self.title = event?.title
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        //
        guard let reference = eventReference else { return }
        
        attendanceReference = reference.collection("attendances").document(Auth.auth().currentUser!.uid)
        currentUserAttendancesEventDocument = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("attendances").document(reference.documentID)
        
        //
        authService.getCurrentUserData { (userData) in
            self.currentUserFullName = "\(userData.firstName) \(userData.name)"
        }
        
        //
        authorNameLabel.text = event?.author["name"]
        authorEmailLabel.text = event?.author["email"]
        
        //        
        attendanceCommentLabel.text = "Confirmer votre présence"
        
        //
        let dateOnlyFormatter = DateFormatter()
        let timeOnlyFormatter = DateFormatter()
        
        //
        dateOnlyFormatter.dateFormat = "EEEE d MMMM"
        timeOnlyFormatter.dateFormat = "hh:mm"
        
        startDate.text = "le " + dateOnlyFormatter.string(from: (event?.startDate)!) + ", " + " à " + timeOnlyFormatter.string(from: (event?.startDate)!)
        endDate.text = "le " + dateOnlyFormatter.string(from: (event?.startDate)!) + ", " + " à " + timeOnlyFormatter.string(from: (event?.endDate)!)
        
        //
        descriptionTextView.text = event?.body
    }

    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeUserAttendance()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeUserAttendance() {
        guard let reference = eventReference else { return }
        
        let attendancesCollection = reference.collection("attendances")
        let attendanceReference =
            attendancesCollection.document(Auth.auth().currentUser!.uid)
        
        listener = attendanceReference.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            if document.exists {
                guard let attendance = document.data() ["present"] as? Bool else { return }
                
                if attendance != true {
                    self.isUserAttendingLabel.text = "Vous ne participez pas à l'évènement"
                    self.attendanceCommentLabel.text = "Nous sommes tristes. Revenez !"
                    self.notAttendingCheckButton.setImage(#imageLiteral(resourceName: "absentSelectedCellIcon"), for: .normal)
                    
                    self.attendingCheckButton.setImage(#imageLiteral(resourceName: "presentCellIcon"), for: .normal)
                } else {
                    self.isUserAttendingLabel.text = "Vous participez à l'évènement"
                    self.attendanceCommentLabel.text = "Merci de participer à l'évènement !"
                    self.attendingCheckButton.setImage(#imageLiteral(resourceName: "presentSelectedCellIcon"), for: .normal)
                    
                    self.notAttendingCheckButton.setImage(#imageLiteral(resourceName: "absentCellIcon"), for: .normal)
                }
            }
        }
    }
        
    @IBAction func absentTapped(_ sender: Any) {
        //
        let batch = Firestore.firestore().batch()
        
        //
        guard let currentUserAttendancesEventDocument = currentUserAttendancesEventDocument else { return }
        guard let attendanceReference = attendanceReference else { return }

        //
        batch.setData(["nonAttendantName": self.currentUserFullName ?? "", "present": false, "confirmedAt": FieldValue.serverTimestamp()], forDocument: attendanceReference)
        batch.deleteDocument(currentUserAttendancesEventDocument)
        
        batch.commit { (error) in
            if let error = error {
                // Alerte à afficher si une erreur est survenue
                let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de confirmation de votre absence : \(error.localizedDescription)" , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                //
                let statusAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "abscenceConfirmedIcon"), title: "Absent", message: "Votre absence a été confirmée avec succès.")
                
                //
                statusAlert.show()
            }
        }
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendancesSegue" {
            if let vc = segue.destination as? AttendancesController {
                guard let reference = self.eventReference else { return }
                
                vc.eventReference = reference
            }
        } else if segue.identifier == "showAttendanceStartDatePopup" {
            if let vc = segue.destination as? AttendanceStartDatePopupController {
                guard let reference = self.eventReference else { return }
                
                if let event = self.event {
                    vc.event = event
                    vc.eventReference = reference
                } else {
                    
                }
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
