//
//  MyAttendancesController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-28.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

//
import FirebaseFirestore
import FirebaseAuth

class MyAttendancesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //
    @IBOutlet weak var userAttendancesFilterSegmentedControl: UISegmentedControl!
    @IBOutlet var userAttendancesTableView: UITableView!
    
    //
    let backgroundView = UIImageView()
    
    //
    private var userAttendances: [UserAttendanceObject] = []
    private var documents: [DocumentSnapshot] = []
    
    //
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeUserAttendances()
            }
        }
    }
    
    //
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        userAttendancesTableView.dataSource = self
        userAttendancesTableView.delegate = self
        
        //
        query = baseQuery()
    }
    
    //
    @IBAction func userAttendancesFilterSegmentedControlSwitched(_ sender: Any) {
        switch userAttendancesFilterSegmentedControl.selectedSegmentIndex {
            case 0:
                self.query = baseQuery()
            case 1:
                self.query = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("attendances").whereField("eventStartDate", isLessThan: Date())
            default:
                break;
        }
    }
    
    // Débuter le listener dans la méthode "viewWillAppear" à la place de la méthode "viewDidLoad" afin de préserver la batterie ainsi que l'usage de mémoire du téléphone
    override func viewWillAppear(_ animated: Bool) {
        //
        observeUserAttendances()
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
    
    func observeUserAttendances() {
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
            self.userAttendances = models
            self.documents = snapshot.documents
            
            DispatchQueue.main.async {
                self.userAttendancesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAttendances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userAttendanceCell", for: indexPath) as! UserAttendanceCell
        
        //
        let userAttendance = userAttendances[indexPath.row]
        
        //
        cell.populate(userAttendance: userAttendance)
        
        //
        return cell
    }
}

class UserAttendanceCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    func populate(userAttendance: UserAttendanceObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        
        //
        titleLabel.text = userAttendance.eventTitle
        bodyLabel.text = userAttendance.eventBody
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
