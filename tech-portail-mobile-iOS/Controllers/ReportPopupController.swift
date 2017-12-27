//
//  ReportPopupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 17-12-27.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class ReportPopupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
