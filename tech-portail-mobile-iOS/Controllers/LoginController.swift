//
//  LoginController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginController: UIViewController {
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        button.setTitle("S'inscrire", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Fonction qui gère l'authentification (ne pas porter attention au @objc)
    @objc func handleLoginRegister() {
        
        // Vérifier lequel des segments (S'inscire ou se connecter) est sélectionné et agir en conséquence
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            // Appeler la fonction qui fait partie de la classe AuthService et qui s'occupe de connecter un utilisateur à Firebase
            if let email = emailTextField.text, let password = passwordTextField.text {
                User().signIn(withEmail: email, password: password, completion: { (error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        let tabBarCtrl = TabBarController.fromStoryboard()
                        self.present(tabBarCtrl, animated: true, completion: nil)
                    }
                })
            }
        } else {
            // Appeler la fonction qui s'occupe de rajouter l'utilisateur sur Firebase
            if let userName = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
                handleRegister(email: email, password: password, userName: userName)
            }
        }
    }
        
    // Fonction qui s'occupe de rajouter un utilisateur sur Firebase
    func handleRegister(email: String, password: String, userName: String) {
        if userName != "" {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    //
                    let alertController = UIAlertController(title: "Oups !", message: "Une erreur est survenue lors de la tentative de création de votre compte : \(error.localizedDescription)" , preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
        } else {
            let alertController = UIAlertController(title: "Oups !", message: "Veuillez vous assurer que tous les champs soient correctement remplis avant de soumettre votre formulaire d'inscription." , preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Mot de passe oublié ?", for: .normal)
        button.setTitleColor(UIColor(red:0.94, green:0.68, blue:0.31, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Fonction qui envoie un courriel à l'utilisateur afin qu'il puisse réinitialiser son mot de passe
    @objc func handleForgotPassword() {
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
            
            if let email = emailTextField.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Oups !", message: "Le courriel de réinitialisation de votre mot de passe n'a pas pu être envoyé : \(error.localizedDescription)" , preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Courriel envoyé !", message: "Le courriel de réinitialisation de votre mot de passe a été envoyé avec succès !" , preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            } else {
                let alertController = UIAlertController(title: "Oups !", message: "Veuillez entrer un courriel valide !" , preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        alertVC.addAction(alertActionSend)
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nom complet"
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.keyboardAppearance = .dark
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Courriel"
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardAppearance = .dark
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Mot de passe"
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        tf.isSecureTextEntry = true
        tf.keyboardAppearance = .dark
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "t4k-logo")
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Se connecter", "S'inscrire"])
        sc.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
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
    
    // Cacher le clavier lorsque l'utilisateur clique à un endroit (peu importe) sur l'écran
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Bloquer la rotation de l'écran (seulment sur l'écran de connexion !)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changer la couleur de fond de la vue
        view.backgroundColor = UIColor(red: 0.13, green: 0.12, blue: 0.12, alpha: 1.0)
        
        // Ajouter les vues à la vue parent
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(forgotPasswordButton)
        
        // Effectuer les fonctions qui établissent les contraintes de la vue
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupForgotPasswordButton()
    }
    
    func setupProfileImageView() {
        // x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        // x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
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
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        // x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupForgotPasswordButton() {
        // x, y, width, height constraints
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 15).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
