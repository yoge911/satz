//
//  SettingsTableViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 25.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {

   let dataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.dataChanged = {[weak self] in
            self?.tableView.reloadData()
        }
        
         //Points to data.json local
        dataSource.fetch("data")
        tableView.dataSource = dataSource
        
        let user = Auth.auth().currentUser
        guard let _ = user else{
            return
        }
        
//        print(thisUser.displayName)
//        print(thisUser.email)
//        print(thisUser.photoURL)
//        print(thisUser.uid)
    }
    
    @IBAction func logOutUserButton(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
          self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }

    
    


    
}
