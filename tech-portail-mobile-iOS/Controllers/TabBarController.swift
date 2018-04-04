//
//  TabBarController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let dashboardController: UINavigationController = {
        let controller = UINavigationController(rootViewController: DashboardController())
        
        controller.tabBarItem.title = NSLocalizedString("tabBarFirstItemTitle", comment: "Describes the title of the first item in the navigation bar (should be the dashboard)")
        controller.tabBarItem.image = UIImage(named: "home")
        
        return controller
    }()
    
    let newsController: UINavigationController = {
        let controller = UINavigationController(rootViewController: NewsController())
        
        controller.tabBarItem.title = NSLocalizedString("tabBarSecondItemTitle", comment: "Describes the title of the second item in the navigation bar (should be the news tab)")
        controller.tabBarItem.image = UIImage(named: "advertising")
        
        return controller
    }()
    
    let eventsController: UINavigationController = {
        let controller = UINavigationController(rootViewController: EventsController())
        
        controller.tabBarItem.title = NSLocalizedString("tabBarThirdItemTitle", comment: "Describes the title of the third item in the navigation bar (should be the news tab)")
        controller.tabBarItem.image = UIImage(named: "calendar")
        
        return controller
    }()
    
    let teamController: UINavigationController = {
        let controller = UINavigationController(rootViewController: TeamController())
        
        controller.tabBarItem.title = NSLocalizedString("tabBarLastItemTitle", comment: "Describes the title of the last item in the navigation bar (should be the news tab)")
        controller.tabBarItem.image = UIImage(named: "people")
        
        return controller
    }()
    
    private final func setupTabBar() {
        //
        viewControllers = [dashboardController, newsController, eventsController, teamController]
        
        //
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
}
