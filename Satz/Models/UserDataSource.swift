//
//  UserDataSource.swift
//  Satz
//
//  Created by Yogesh Rokhade on 25.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class UserDataSource: NSObject, UITableViewDataSource {
    
    var userDataSections = [dataSection]()
    var dataChanged: (() -> Void)?
    
    func fetch(_ urlString: String) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        decoder.decode([UserInfo].self, fromURL: urlString) { usersettings in
            let useraccount = usersettings.first!
            self.userDataSections.append(dataSection(0, object: Account(useraccount: useraccount), 3))
            self.userDataSections.append(dataSection(1, object: useraccount.languages, nil, useraccount.languages.count, "Languages"))
            self.dataChanged?()
        }
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return self.userDataSections.count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.userDataSections[section].sectionName
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDataSections[section].sectionRows
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicSettingCell", for: indexPath)
        
        var labelName = ""
        var labelValue = ""
        
        if indexPath.section == 0 {
            let reflected = Mirror(reflecting: self.userDataSections[indexPath.section].generalSection!)
            let idx_start = reflected.children.startIndex
            let idx_end = reflected.children.endIndex
            let childAtIndex = reflected.children.index(idx_start, offsetBy: indexPath.row, limitedBy: idx_end)
            let child = reflected.children[childAtIndex!]
            labelName = child.label!
            labelValue = child.value as! String
            cell.accessoryType = .none
        }
        
        if indexPath.section == 1 {
            let language = self.userDataSections[indexPath.section].languagesSection[indexPath.row]
            labelName = language.type
            let displayvalue = language.displayName + ", \(language.code)"
            labelValue = displayvalue
        }
        
       cell.textLabel?.text = labelName
       cell.detailTextLabel?.text = labelValue
       return cell
    }
}

