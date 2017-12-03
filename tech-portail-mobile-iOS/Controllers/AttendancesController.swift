//
//  AttendancesController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore

class AttendancesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Référence aux éléments de l'interface de l'application
    @IBOutlet var attendancesTableView: UITableView!
    
    //
    var eventReference: DocumentReference?
    
    //
    private var attendances: [AttendanceObject] = []
    private var documents: [DocumentSnapshot] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeAttendances()
            }
        }
    }
    
     private var listener: ListenerRegistration?
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> AttendancesController {
        let controller = storyboard.instantiateViewController(withIdentifier: "AttendancesController") as! AttendancesController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        attendancesTableView.dataSource = self
        attendancesTableView.delegate = self
        
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeAttendances()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        guard let reference = eventReference else {
            print("Document reference not found")
            return Firestore.firestore().collection("events")
        }
        
        let attendancesCollection = reference.collection("attendances").whereField("present", isEqualTo: true)
        
       return attendancesCollection
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeAttendances() {
        guard let query = query else { return }
        
        guard let reference = eventReference else { return }
        
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> AttendanceObject in
                if let model = AttendanceObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(AttendanceObject.self) with dictionary \(document.data())")
                }
            }
            self.attendances = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.attendancesTableView.reloadData()
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
    
    // Retourner autant de cellules qu'il y a de nouvelles
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.count
    }
    
    // Populer la cellule des informations sur la nouvelle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendanceCell", for: indexPath) as! AttendanceCell
        
        //
        let attendance = attendances[indexPath.row]
        
        //
        cell.populate(attendance: attendance)
        
        return cell
    }
}

// Classe de la cellule d'une présence
class AttendanceCell: UITableViewCell {
    // Référence aux éléments de l'interface de l'application
    @IBOutlet weak var attendantNameLabel: UILabel!
    @IBOutlet weak var attendanceLengthLabel: UILabel!

    
    func populate(attendance: AttendanceObject) {
        //
        attendantNameLabel.text = attendance.attendantName
        attendanceLengthLabel.text = "De \(attendance.attendanceStartsAt) à \(attendance.attendanceEndsAt)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
