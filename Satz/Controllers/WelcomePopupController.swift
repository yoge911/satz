//
//  Wordtypecontroller.swift
//  Satz
//
//  Created by Yogesh Rokhade on 02.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class WelcomePopupController: UIViewController {    
    
    var loggedIn = false
    
    @IBOutlet weak var logoView: UIView!

    @IBAction func didTapForLogin() {
        self.performSegue(withIdentifier: "initialSegue_Login", sender: nil)
    }
    
    @IBAction func didTapForSignUp() {
        self.performSegue(withIdentifier: "initialSegue_Register", sender: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateTitle(Parentview: logoView)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: nil)
        }
    }
    

    
    func setupFBLoginButton() {
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
    } 

  
}

extension WelcomePopupController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"],
                                                 tokenString: token, version: nil,httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            //print(result)
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out FB")
    }
}

