//
//  SignupController.swift
//  tech-portail-mobile-iOS
//
//  Created by Anas MERBOUH on 18-03-07.
//  Copyright © 2018 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class SignupController: UIViewController {
    
    /* MARK: Views' declarations */
    private let slideShowSection: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let formSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .green
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let displayNameTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private let sectionsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    /* MARK: Views' Auto layout constraints */
    private final func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
    }
    
    private final func setupSectionsStackView() {
        // Add the stackview to the superview
        view.addSubview(sectionsStackView)
        
        // Add the arranged subviews to the stackview
        sectionsStackView.addArrangedSubview(slideShowSection)
        sectionsStackView.addArrangedSubview(formSection)
        
        // x, y, width, height constraints
        sectionsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sectionsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true 
        sectionsStackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        sectionsStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //
        formSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    private final func setupFormSection() {
        formSection.addSubview(displayNameTextField)
        
        // x, y, width, height constraints for the display name text field
        
    }
    
    override internal final func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        //
        setupNavigationBar()
        setupSectionsStackView()
        setupFormSection()
    }
    
    @objc private final func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
