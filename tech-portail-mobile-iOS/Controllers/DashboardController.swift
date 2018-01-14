//
//  DashboardController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//
import UIKit

//
import FirebaseFirestore
import FirebaseAuth

class DashBoardController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    // Référence aux éléments de l'interface de l'application
    @IBOutlet weak var upComingUserAttendancesTableView: UITableView!
    
    //
    let backgroundView = UIImageView()
    
    //
    private var upComingUserAttendances: [UserAttendanceObject] = []
    private var documents: [DocumentSnapshot] = []
    
    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeUpComingUserAttendances()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        upComingUserAttendancesTableView.dataSource = self
        upComingUserAttendancesTableView.delegate = self
    
        //
        query = baseQuery()
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeUpComingUserAttendances()
    }
    
    // Détacher le listener lorsque la vue disparaît afin de ne pas abuser de la mémoire du téléphone et de la bande passante du réseau
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    //
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("attendances").whereField("eventStartDate", isGreaterThan: Date())
    }
    
    //
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    //
    func observeUpComingUserAttendances() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> UserAttendanceObject in
                if let model = UserAttendanceObject(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(UserAttendanceObject.self) with dictionary \(document.data())")
                }
            }
            self.upComingUserAttendances = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.upComingUserAttendancesTableView.reloadData()
            }
        }
    }
    
    //
    deinit {
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upComingUserAttendances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upComingUserAttendanceCell", for: indexPath) as! UpComingUserAttendanceCell
        
        //
        let upComingUserAttendance = upComingUserAttendances[indexPath.row]
        
        //
        cell.populate(upComingUserAttendance: upComingUserAttendance)
        
        //
        return cell
    }
}

class UpComingUserAttendanceCell: UITableViewCell {
    @IBOutlet weak var upComingEventTitleLabel: UILabel!
    @IBOutlet weak var upComingEventBodyLabel: UILabel!
    
    func populate(upComingUserAttendance: UserAttendanceObject) {
        //
        upComingEventTitleLabel.text = upComingUserAttendance.eventTitle
        upComingEventBodyLabel.text = upComingUserAttendance.eventBody
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
