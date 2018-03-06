//
//  LoginController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    /* MARK: Views' declarations */
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "t4k-logo")
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.75, green: 0.34, blue: 0.27, alpha: 1.0)
        label.textAlignment = .center
                
        label.backgroundColor = UIColor(red: 0.95, green: 0.87, blue: 0.87, alpha: 1.0)
        label.layer.borderColor = UIColor(red: 0.92, green: 0.80, blue: 0.82, alpha: 1.0).cgColor
        label.layer.borderWidth = 2.0
        label.layer.cornerRadius = 5.0
        
        label.numberOfLines = 0
        
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Courriel"
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardAppearance = .light
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    private let emailSeparatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Mot de passe"
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.isSecureTextEntry = true
        tf.keyboardAppearance = .light
        
        tf.translatesAutoresizingMaskIntoConstraints = false
    
        return tf
    }()
    
    private let passwordVisibilityButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "visible"), for: .normal)
        button.addTarget(self, action: #selector(handlePasswordVisibility), for: .touchUpInside)
        button.isEnabled = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        button.setTitle("Se connecter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let loginActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Mot de passe oublié", for: .normal)
        button.setTitleColor(UIColor(red:0.94, green:0.68, blue:0.31, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Créer un compte", for: .normal)
        button.setTitleColor(UIColor(red:0.94, green:0.68, blue:0.31, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button
    }()
    
    
    /* MARK: Views' Auto layout constraints */
    private var logoImageViewBottomAnchor: NSLayoutConstraint?
    private var logoImageViewHeightAnchor: NSLayoutConstraint?
    private var logoImageViewWidthAnchor: NSLayoutConstraint?
    
    private final func setupLogoImageView() {
        // x, y, width, height constraints
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        logoImageViewBottomAnchor = logoImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12)
        logoImageViewBottomAnchor?.isActive = true
        
        logoImageViewHeightAnchor = logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        logoImageViewHeightAnchor?.isActive = true
        
        logoImageViewWidthAnchor = logoImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        logoImageViewWidthAnchor?.isActive = true
    }
    
    private final func setupErrorBoxView() {
        errorMessageLabel.isHidden = true
        
        // x, y, width, height constraints
        errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorMessageLabel.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        errorMessageLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        errorMessageLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
    }
    
    private final func setupInputsContainerView() {
        // x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        // x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.85).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    private final func setupPasswordTextFieldImageView() {
        // Add the view to the inputs container view
        inputsContainerView.addSubview(passwordVisibilityButton)
        
        // x, y, width, height constraints
        passwordVisibilityButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        passwordVisibilityButton.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -8.0).isActive = true
        passwordVisibilityButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        passwordVisibilityButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    private final func setupLoginButton() {
        // x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 14).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //
        loginButton.addSubview(loginActivityIndicatorView)
        
        // x, y, width, height constraints
        loginActivityIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        loginActivityIndicatorView.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -15).isActive = true
    }
    
    private final func setupBottomStackView() {
        // Setting up the stackview
        let bottomControlsStackView = UIStackView(arrangedSubviews: [forgotPasswordButton, signupButton])
        
        bottomControlsStackView.axis = .horizontal
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.alignment = .leading
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stackview to the view
        view.addSubview(bottomControlsStackView)
        
        // x, y, width, height constraints
        bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /* */
    @objc private final func handleLogin() {
        loginActivityIndicatorView.startAnimating()
        
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        User().signIn(withEmail: email, password: password) { (error) in
            if let error = error {
                self.loginActivityIndicatorView.stopAnimating()
                self.showErrorBox(withMessage: error.localizedDescription)
                
                return
            }
            
            self.loginActivityIndicatorView.stopAnimating()
            self.present(TabBarController.fromStoryboard(), animated: true, completion: nil)
        }
    }
    
    @objc private final func handleSignup() {
        
    }
    
    @objc private final func handleForgotPassword() {
        let alertVC = UIAlertController(title: "Mot de passe oublié", message: "Veuillez entrer votre courriel dans le champs ci-dessous.", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        
        alertVC.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = UIKeyboardType.emailAddress
            textField.placeholder = "Votre courriel"
        }
        
        // Action à effectuer si le bouton "Envoyer" est appuyé
        let alertActionSend = UIAlertAction(title: "Envoyer", style: .default) {
            (_) in
            let emailTextField = alertVC.textFields![0]
            
            User().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative d'envoie du courriel : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                let alertController = UIAlertController(title: "Courriel envoyé", message: "Veuillez suivre les instructions envoyées à \(String(describing: emailTextField.text)) afin de réinitialiser votre mot de passe." , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
        alertVC.addAction(alertActionSend)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc public final func handlePasswordVisibility() {
        if passwordVisibilityButton.image(for: .normal) == UIImage(named: "visible") {
            passwordTextField.isSecureTextEntry = false
            passwordVisibilityButton.setImage(UIImage(named: "invisible"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordVisibilityButton.setImage(UIImage(named: "visible"), for: .normal)
        }
    }
    
    /* MARK: Keyboard managment */
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    fileprivate(set) var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changer la couleur de fond de la vue
        view.backgroundColor = UIColor(red: 0.13, green: 0.12, blue: 0.12, alpha: 1.0)
        
        
        // Ajouter les vues à la vue parent
        view.addSubview(logoImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        
        // Effectuer les fonctions qui établissent les contraintes de la vue
        setupLogoImageView()
        setupErrorBoxView()
        setupInputsContainerView()
        setupPasswordTextFieldImageView()
        setupLoginButton()
        setupBottomStackView()
    }
}

extension LoginController {
    private final func showErrorBox(withMessage message: String) {
        self.errorMessageLabel.text = message
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.errorMessageLabel.isHidden = false
            
            self.logoImageViewBottomAnchor?.isActive = false
            self.logoImageViewHeightAnchor?.isActive = false
            self.logoImageViewWidthAnchor?.isActive = false
            
            self.logoImageViewBottomAnchor = self.logoImageView.bottomAnchor.constraint(equalTo: self.errorMessageLabel.topAnchor, constant: -12)
            self.logoImageViewHeightAnchor =  self.logoImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
            self.logoImageViewWidthAnchor =  self.logoImageView.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
            
            self.logoImageViewBottomAnchor?.isActive = true
            self.logoImageViewHeightAnchor?.isActive = true
            self.logoImageViewWidthAnchor?.isActive = true
        }, completion: nil)
    }
}

