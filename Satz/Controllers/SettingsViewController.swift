//
//  SettingsViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 20.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  

    @IBOutlet weak var settingsTableView: UITableView!
    let userSettings = """
    {
      "Identifier": "AccountTypeCell"
       "name" : "Yogesh Rokhade",
       "email": "yoge911@gmail.com",
       "membership": "(7-days)Trial"
       "primaryLanguage": "English"
       "learningLanguage": "German"
    }
    """
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
       
    }
    
    func setupView() {
        setupTableView()
    }
    
    func setupTableView() {
        
        let nameCard_nib = UINib(nibName: "ItemDisplayTableViewCell", bundle: nil)
        settingsTableView.register(nameCard_nib, forCellReuseIdentifier: "ItemDisplayTableViewCell")
        
        let option_nib = UINib(nibName: "OnOrOffTableViewCell", bundle: nil)
        settingsTableView.register(option_nib, forCellReuseIdentifier: "OnOrOffTableViewCell")
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        

    }

}

extension SettingsViewController {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else {
            return 50
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier =  "rightDetailCell"
        let cell =  tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Name"
        cell.detailTextLabel?.text = "Yogesh"
        return cell
//        switch indexPath.row {
//        case 0:
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDisplayTableViewCell",
//                                                     for: indexPath) as! ItemDisplayTableViewCell
//            cell.itemName.text = "Yogesh Rokhade"
//            cell.ItemSubText.text = "yoge911@gmail.com"
//            return cell
//
//        case 4:
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
//            cell.textLabel?.text = userSettings[indexPath.row]
//            cell.accessoryType = .disclosureIndicator
//            return cell
//
//
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell",
//                                                    for: indexPath) as! OnOrOffTableViewCell
//            cell.optionName.text = userSettings[indexPath.row - 1]
//            cell.optionName.textColor = UIColor.white
//            return cell
//        }
        

    }

}

struct UserDetails: Decodable {

    
    let name: String
    let email: String
    let membership: String
    let primaryLanguage: String
    let learningLanguage: String
}


