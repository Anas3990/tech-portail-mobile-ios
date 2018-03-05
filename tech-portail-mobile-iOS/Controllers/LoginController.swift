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
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "t4k-logo")
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    private lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Se connecter", "S'inscrire"])
        sc.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        return sc
    }()
    
    private let errorBoxView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.87, blue: 0.87, alpha: 1.0)
        view.layer.borderColor = UIColor(red: 0.92, green: 0.80, blue: 0.82, alpha: 1.0).cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 5.0
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let errorBoxMessageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Le nom d'utilisateur ou le mot de passe est incorrect. Veuillez réessayer à nouveau."
        label.textColor = UIColor(red: 0.75, green: 0.34, blue: 0.27, alpha: 1.0)
        
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
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nom complet"
        
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.keyboardAppearance = .light
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    private let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
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
        
        //
        tf.backgroundColor = .blue
        
        return tf
    }()
    
    private let passwordVisibilityButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "visible"), for: .normal)
        button.addTarget(self, action: #selector(handlePasswordVisibility), for: .touchUpInside)
        button.isEnabled = true
        
        //
        button.backgroundColor = .green
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        button.setTitle("S'inscrire", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Mot de passe oublié ?", for: .normal)
        button.setTitleColor(UIColor(red:0.94, green:0.68, blue:0.31, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    /* MARK: Views' Auto layout constraints */
    private final func setupProfileImageView() {
        // x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private final func setupLoginRegisterSegmentedControl() {
        // x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: errorBoxView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private final func setupErrorBoxView() {
        // x, y, width, height constraints
        errorBoxView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorBoxView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        errorBoxView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        errorBoxView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        
        // Add the error message label
        errorBoxView.addSubview(errorBoxMessageLabel)
        
        // x, y, width, height constraints
        errorBoxMessageLabel.centerXAnchor.constraint(equalTo: errorBoxView.centerXAnchor).isActive = true
        errorBoxMessageLabel.centerYAnchor.constraint(equalTo: errorBoxView.centerYAnchor).isActive = true
        errorBoxMessageLabel.heightAnchor.constraint(equalTo: errorBoxView.heightAnchor, multiplier: 1).isActive = true
        errorBoxMessageLabel.widthAnchor.constraint(equalTo: errorBoxView.widthAnchor, multiplier: 0.90).isActive = true
    }
    
    private var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    private var nameTextFieldHeightAnchor: NSLayoutConstraint?
    private var emailTextFieldHeightAnchor: NSLayoutConstraint?
    private var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    private final func setupInputsContainerView() {
        // x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.85).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    private final func setupPasswordTextFieldImageView() {
        // Add the view to the inputs container view
        inputsContainerView.addSubview(passwordVisibilityButton)
        
        // x, y, width, height constraints
        passwordVisibilityButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordVisibilityButton.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -10.0).isActive = true
        passwordVisibilityButton.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        passwordVisibilityButton.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
    }
    
    private final func setupLoginRegisterButton() {
        // x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private final func setupForgotPasswordButton() {
        // x, y, width, height constraints
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /* */
    @objc private final func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            User().signIn(withEmail: email, password: password, completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative connexion : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
            })
        } else {
            guard let displayName = nameTextField.text else { return }
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            User().signUp(withDisplayName: displayName, email: email, password: password, completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la création de votre compte : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
            })
        }
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
    
    @objc private final func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Changer la hauteur du inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // Changer la hauteur du nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Changer la hauteur du emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Changer la hauteur du passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    /* MARK: Keyboard managment */
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changer la couleur de fond de la vue
        view.backgroundColor = UIColor(red: 0.13, green: 0.12, blue: 0.12, alpha: 1.0)
        
        // Ajouter les vues à la vue parent
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(errorBoxView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(forgotPasswordButton)
        
        // Effectuer les fonctions qui établissent les contraintes de la vue
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupErrorBoxView()
        setupInputsContainerView()
        setupPasswordTextFieldImageView()
        setupLoginRegisterButton()
        setupForgotPasswordButton()
    }
}
