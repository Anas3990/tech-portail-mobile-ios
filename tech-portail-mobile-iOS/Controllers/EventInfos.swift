//
//  EventInfos.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import EventKit

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
        let attendanceReference = attendancesCollection.document(Auth.auth().currentUser!.uid)
        
        
        listener = attendanceReference.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            if document.exists {
                guard let attendance = document.data() ["present"] as? Bool else { return }
                
                if attendance != true {
                    self.isUserAttendingLabel.text = "Vous ne participez pas à l'évènement"
                    self.notAttendingCheckButton.setImage(#imageLiteral(resourceName: "absentSelectedCellIcon"), for: .normal)
                    
                    self.attendingCheckButton.setImage(#imageLiteral(resourceName: "presentCellIcon"), for: .normal)
                } else {
                    self.isUserAttendingLabel.text = "Vous participez à l'évènement"
                    self.attendingCheckButton.setImage(#imageLiteral(resourceName: "presentSelectedCellIcon"), for: .normal)
                    
                    self.notAttendingCheckButton.setImage(#imageLiteral(resourceName: "absentCellIcon"), for: .normal)
                }
            }
        }
    }
    
    // Action à effectuer lorsque l'utilisateur appuie sur l'icône "Partager" (soit montrer un action sheet similaire à celui que l'on retrouve sur l'application Photos)
    @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let title = self.event?.title else {
            return
        }
        
        guard let body = self.event?.body else {
            return
        }
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [title, body], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
        
    // Fonction qui permet à un utilisateur d'ajouter un évènement à son calendrier personnel
    func addEventToCalendar(title: String, body: String?, startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        
        //
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                
                event.notes = body
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                //
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print(error)
                    return
                }
            } else {
                
            }
        })
    }
    
    //
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
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAttendancesSegue" {
            if let vc = segue.destination as? AttendancesController {
                guard let reference = self.eventReference else { return }
                
                vc.eventReference = reference
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
