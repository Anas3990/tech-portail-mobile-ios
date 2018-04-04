//
//  SchedulesFeedCell.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-09.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class SchedulesFeedCell: DashboardCell {
    
    /* MARK: Table View configuration */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        guard let startDate = activities[section].startDate else {
            return "N/A"
        }
        
        return DateFormatter.localizedString(from: startDate, dateStyle: .full, timeStyle: .none)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.section]
        
        if indexPath.section == 0 {
            let mostRecentActivityCell = tableView.dequeueReusableCell(withIdentifier: "mostRecentActivityCell")! as! MostRecentActivityCell
            
            mostRecentActivityCell.populateCell(withActivity: activity)
            
            return mostRecentActivityCell
        }
        
        let recentActivityCell = tableView.dequeueReusableCell(withIdentifier: "workshopScheduleCell", for: indexPath) as! ScheduleCell
        
        recentActivityCell.populateCell(withActivity: activity)
        
        return recentActivityCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        }
        
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        
        return true
    }
}
