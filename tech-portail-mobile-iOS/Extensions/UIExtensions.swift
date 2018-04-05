//
//  UIExtensions.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-04-04.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

extension UIAlertController {
    open func showErrorAlert(withMessage message: Error, presenter: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("errorAlertControllerTitle", comment: "Describes the title for alert controller responsible to show error messages"), message: "\(NSLocalizedString("errorAlertControllerMessage", comment: "Describes the message for alert controller responsible to show error messages")): \(message.localizedDescription)", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        presenter.present(alertController, animated: true, completion: nil)
    }
}
