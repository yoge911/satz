//
//  RegisterViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 08.10.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoView: UIView!

    @IBAction func didRegisterWithFacebook() {
        registerTheUser(true)
    }
    
    @IBAction func didRegisterWithEmail() {
       //registerTheUser(false)
       // animateStrokes()
    }
    
    func registerTheUser(_ registered: Bool) {
        if registered {
            self.performSegue(withIdentifier: "SignedInSegueIdentifier", sender: nil)
        }
        
    }
    //var charLayers = [CAShapeLayer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateTitle(Parentview: logoView)
    }



}
