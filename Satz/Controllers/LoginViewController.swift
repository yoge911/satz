//
//  LoginViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 08.10.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var resetmypasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPasswordCancelBtn: UIButton!
    @IBOutlet weak var logoView: UIView!
    
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetmypasswordButton.isHidden = true
        self.resetPasswordCancelBtn.isHidden = true
        setupSpinner()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateTitle(Parentview: logoView)
    }
    
    @IBAction func didTapCancelResetPassword() {
        resetToLoginMode()
    }
    
    @IBAction func loginTheUserwithEmail() {
        activityIndicator.startAnimating()
        signInUserwithEmail { (logInSuccessfull) in
            if(logInSuccessfull){
                self.redirectUsersToMainApp()
            }
            self.activityIndicator.stopAnimating()
        }
    }
    

    
    @IBAction func loginTheUserwithFB() {
        activityIndicator.startAnimating()
        signInUserwithFB { (logInSuccessfull) in
            if(logInSuccessfull){
                self.redirectUsersToMainApp()
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func didClickForgotPasswordLink() {
        
        let posYofpassWordTextField = self.passwordTextField.frame.origin.y
        let posYofEmailTextField = self.emailTextField.frame.origin.y        
        let translationY = posYofpassWordTextField - posYofEmailTextField
        
        let posXofForgotPassBtn = self.forgotPasswordButton.frame.origin.x
        let posXofBackBtn = self.resetPasswordCancelBtn.frame.origin.x
        let translationX = posXofForgotPassBtn - posXofBackBtn
        
        UIView.animate(withDuration: 0.2, animations: {
            self.passwordTextField.transform = CGAffineTransform(translationX: -500, y: 0)
            self.passwordTextLabel.transform = CGAffineTransform(translationX: -500, y: 0)
            self.forgotPasswordButton.transform = CGAffineTransform(translationX: -500, y: 0)
            self.emailTextLabel.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.emailTextField.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.swapVisibilityLoginAndResetPassButton()
            self.resetPasswordCancelBtn.transform = CGAffineTransform(translationX: translationX, y: 0)
            
        })

    }
    
    func  resetToLoginMode()  {
        UIView.animate(withDuration: 0.2, animations: {
            self.passwordTextField.transform = .identity
            self.passwordTextLabel.transform = .identity
            self.forgotPasswordButton.transform = .identity
            self.resetPasswordCancelBtn.transform = .identity
            self.emailTextLabel.transform = .identity
            self.emailTextField.transform = .identity
            self.swapVisibilityLoginAndResetPassButton()
        })
    }
    
    @IBAction func didClickResetMyPasswordBtn() {
        resetPassword()
    }
    
    func swapVisibilityLoginAndResetPassButton()  {
        self.loginButton.isHidden = (!self.loginButton.isHidden)
        self.resetmypasswordButton.isHidden = !self.resetmypasswordButton.isHidden
        self.resetPasswordCancelBtn.isHidden = !self.resetPasswordCancelBtn.isHidden
    }

    func setupSpinner() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    func redirectUsersToMainApp() {
        self.performSegue(withIdentifier: "loggedInSegueIdentifier", sender: nil)
    }
    
    func registerUser(completion: @escaping(Bool) -> Void) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            activityIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        self!.handleError(errorCode: errCode, defaultErrorMessage: error.localizedDescription)
                    }
                    completion(false)
                }else {
                    completion(true)
                }
                self!.activityIndicator.stopAnimating()
            }
        }
    }
    
    func signInUserwithEmail(completion: @escaping(Bool) -> Void){
        if let email = emailTextField.text, let password = passwordTextField.text {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            authenticateWithFirebase(credential: credential) { (authSuccess) in
                completion(authSuccess)
            }
        }
    }
    
    func authenticateWithFirebase(credential: AuthCredential, completion: @escaping(Bool) -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    self!.handleError(errorCode: errCode, defaultErrorMessage: error.localizedDescription)
                }
                completion(false)
            }else {
                completion(true)
            }
        }
    }
    
    func handleError(errorCode: AuthErrorCode, defaultErrorMessage: String){
        switch errorCode {
        case .accountExistsWithDifferentCredential:
            self.showAlert(message: "It appears your email is already used with an other form of authentication")
        case .invalidEmail:
            self.showAlert(message: "The email you provided is invalid.")
        case .userDisabled:
            self.showAlert(message: "It appears your account is disabled. Please raise a request to unlock in the settings tab. ")
        default:
            self.showAlert(message: defaultErrorMessage)
        }
    }
    

    
    func signInUserwithFB(completion: @escaping(Bool) -> Void){
        loginManager.logIn(permissions: ["email","public_profile"], from: self) { [weak self] (result, error) in
            
            guard error == nil else {
                self!.showAlert(message: "Facebook" + error!.localizedDescription)
                completion(false)
                return
            }

            guard let result = result, !result.isCancelled else {
                self!.showAlert(message: "Facebook: Login cancelled")
                completion(false)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            self?.authenticateWithFirebase(credential: credential) { (authSuccess) in
                completion(authSuccess)
            }

        }
    }
    
    func resetPassword() {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    let message = "An email to reset password has been set. Please follow the email instructions"
                    self.showAlert(message: message) { (alertControllerDismissed) in
                        if alertControllerDismissed{
                            self.resetToLoginMode()
                        }
                    }
                   
                }
            }
        }
    }

    
    func logOutUserFromFB(completion: @escaping(Bool) -> Void) {
        loginManager.logOut()
        completion(true)
    }
    
}


//            let request = GraphRequest(
//            graphPath: "me",
//            parameters: ["fields": "id, email, name, first_name, last_name, picture.type(large)"],
//            tokenString: AccessToken.current?.tokenString,
//            version: nil,
//            httpMethod: .get)
//
//            request.start { (connection, result, error) in
//                let fields = result as? [String:Any]
//                let email = fields!["email"] as? String
//
//            }
