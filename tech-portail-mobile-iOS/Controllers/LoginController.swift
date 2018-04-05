//
//  LoginController.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseAuth
import FirebaseFirestore

class LoginController: UIViewController, UITextFieldDelegate {
    
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
    
    public let emailTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = NSLocalizedString("emailTextFieldPlaceholder", comment: "The placeholder for the email text field in the login/signup screen")
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        tf.keyboardType = .emailAddress
        tf.keyboardAppearance = .light
        tf.returnKeyType = .continue
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    private let emailSeparatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.placeholder = NSLocalizedString("passwordTextFieldPlaceholder", comment: "The placeholder for the password text field in the login/signup screen")
        tf.tintColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        tf.addTarget(self, action: #selector(handlePasswordVisibilityToggling), for: UIControlEvents.editingChanged)
        
        tf.isSecureTextEntry = true
        
        tf.returnKeyType = .done
        tf.keyboardAppearance = .light
        
        tf.translatesAutoresizingMaskIntoConstraints = false
    
        return tf
    }()
    
    private let passwordVisibilityButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        
        button.setImage(UIImage(named: "visible"), for: .normal)
        button.addTarget(self, action: #selector(handlePasswordVisibility), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    public let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red:0.96, green:0.92, blue:0.08, alpha:1.0)
        
        button.setTitle(NSLocalizedString("loginButtonTitle", comment: "The title for the login button in the login screen"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .disabled)
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
        
        button.setTitle(NSLocalizedString("forgotPasswordButtonTitle", comment: "The title for the forgot password button in the login screen"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(NSLocalizedString("signupButtonTitle", comment: "The title for the signup button in the login/signup screen"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        button.addTarget(self, action: #selector(showSignupVC), for: .touchUpInside)
        
        return button
    }()
    
    public let bottomControlsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
    
    private var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    
    private final func setupInputsContainerView() {
        // x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputsContainerViewCenterYAnchor = inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        inputsContainerViewCenterYAnchor?.isActive = true
        
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        // x, y, width, height constraints
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
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
        // Add the image view to the inputs container view
        inputsContainerView.addSubview(passwordVisibilityButton)
        
        // x, y, width, height constraints
        passwordVisibilityButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        passwordVisibilityButton.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -8.0).isActive = true
        passwordVisibilityButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        passwordVisibilityButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    private var loginButtonWidthAnchor: NSLayoutConstraint?
    private var loginButtonCenterXAnchor: NSLayoutConstraint?
    private var loginButtonTrailingAnchor: NSLayoutConstraint?
    
    private final func setupLoginButton() {
        // x, y, width, height constraints
        loginButtonCenterXAnchor = loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        loginButtonCenterXAnchor?.isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 14).isActive = true
        loginButtonWidthAnchor = loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor)
        loginButtonWidthAnchor?.isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add the loading indicator to the button
        loginButton.addSubview(loginActivityIndicatorView)
        
        // x, y, width, height constraints
        loginActivityIndicatorView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        loginActivityIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
    }
    
    private final func setupBottomStackView() {
        // Adding the arranged subviews
        self.bottomControlsStackView.addArrangedSubview(forgotPasswordButton)
        self.bottomControlsStackView.addArrangedSubview(signupButton)
        
        // x, y, width, height constraints
        bottomControlsStackView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        bottomControlsStackView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor).isActive = true
        bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view's background color
        view.backgroundColor = UIColor(red: 0.13, green: 0.12, blue: 0.12, alpha: 1.0)
        
        // Add subviews to the superview
        view.addSubview(logoImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(bottomControlsStackView)
        
        // Setup the views' constraints
        setupLogoImageView()
        setupErrorBoxView()
        setupInputsContainerView()
        setupPasswordTextFieldImageView()
        setupLoginButton()
        setupBottomStackView()
        
        // Text fields' delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Keyboard's interactions observers
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override internal func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /* MARK: Keyboard and text fields managment */
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    internal final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            self.handleLogin()
            
        default:
            break
        }
        
        return true
    }
    
    internal final func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.passwordTextField.text?.isEmpty != true {
            self.passwordVisibilityButton.isHidden = false
        }
    }
    
    internal final func textFieldDidEndEditing(_ textField: UITextField) {
        self.passwordVisibilityButton.isHidden = true
    }
    
    private var inputsContainerViewBottomAnchor: NSLayoutConstraint?
    
    @objc private final func handleKeyboardWillShowNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            UIView.animate(withDuration: 1, animations: {
                self.inputsContainerViewCenterYAnchor?.isActive = false
                self.inputsContainerViewBottomAnchor = self.inputsContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardFrame!.height)
                self.inputsContainerViewBottomAnchor?.isActive = true

                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private final func handleKeyboardWillHideNotification() {
        UIView.animate(withDuration: 1) {
            self.inputsContainerViewBottomAnchor?.isActive = false
            self.inputsContainerViewCenterYAnchor = self.inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.inputsContainerViewCenterYAnchor?.isActive = true
            
            self.view.layoutIfNeeded()
        }
    }
}

/* MARK: Buisness logic */
extension LoginController {
    @objc private final func handlePasswordVisibilityToggling() {
        if passwordTextField.text != "" {
            self.passwordVisibilityButton.isHidden = false
        } else {
            self.passwordVisibilityButton.isHidden = true
        }
    }
    
    @objc public func handleLogin() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        self.loginButton.setTitle(nil, for: .normal)
        self.loginActivityIndicatorView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // Make the phone vibrate for a better user feedback
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                self.loginButton.setTitle(NSLocalizedString("loginButtonTitle", comment: "The title for the login button in the login screen"), for: .normal)
                self.loginActivityIndicatorView.stopAnimating()
                self.showErrorBox(withMessage: error.localizedDescription)
                
                return
            }
            
            if let user = user {
                user.getProfile(completion: { (data, error) in
                    if let error = error {
                        // Make the phone vibrate for a better user feedback
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        self.loginButton.setTitle(NSLocalizedString("loginButtonTitle", comment: "The title for the login button in the login screen"), for: .normal)
                        self.loginActivityIndicatorView.stopAnimating()
                        self.showErrorBox(withMessage: error.localizedDescription)
                        
                        return
                    }
                    
                    if let userProfile = data {
                        
                    } else {
                        // Make the phone vibrate for a better user feedback
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        self.loginButton.setTitle(NSLocalizedString("loginButtonTitle", comment: "The title for the login button in the login screen"), for: .normal)
                        self.loginActivityIndicatorView.stopAnimating()
                        self.showErrorBox(withMessage: "Nous n'avons pas pu récupérer les données de l'utilisateur")
                    }
                })
            }
        }
    }
    
    @objc private final func showSignupVC() {
        let signupController = UINavigationController(rootViewController: SignupController())
        present(signupController, animated: true, completion: nil)
    }
    
    @objc private final func handleForgotPassword() {
        
    }
    
    @objc public final func handlePasswordVisibility() {
        let cursorPosition = passwordTextField.selectedTextRange
        
        if passwordVisibilityButton.image(for: .normal) == UIImage(named: "visible") {
            passwordTextField.isSecureTextEntry = false
            
            // Reset the cursor offset from the text
            passwordTextField.selectedTextRange = nil
            passwordTextField.selectedTextRange = cursorPosition!
            
            passwordVisibilityButton.setImage(UIImage(named: "invisible"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordVisibilityButton.setImage(UIImage(named: "visible"), for: .normal)
        }
    }
    
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
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
