//
//  NewInfosController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-11-26.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

import FirebaseFirestore

class NewInfosController: UITableViewController {
    //
    var new: NewObject?
    var newReference: DocumentReference?
    
    //
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorEmailLabel: UILabel!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> NewInfosController {
        let controller = storyboard.instantiateViewController(withIdentifier: "NewInfosController") as! NewInfosController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = new?.title
        
        // Rendre la barre de navigation plus petite afin d'éviter d'empiéter sur le contenu
        navigationItem.largeTitleDisplayMode = .never
        
        self.authorNameLabel.text = new?.author["name"]
        self.authorEmailLabel.text = new?.author["email"]
        
        self.descriptionTextView.text = new?.body
    }
    
    @IBAction func shareBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let title = self.new?.title else {
            return
        }
        
        guard let body = self.new?.body else {
            return
        }
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [title, body], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
