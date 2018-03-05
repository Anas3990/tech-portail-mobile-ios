//
//  TabBarController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> TabBarController {
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
