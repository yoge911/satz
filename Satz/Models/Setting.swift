//
//  Setting.swift
//  Satz
//
//  Created by Yogesh Rokhade on 25.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let userid: UUID
    let name: String
    let email: String
    let membership: String
    let languages: [Language]
}

struct Language: Codable {
    let type: String
    let code: String
    let displayName: String
}

//NOTE: Anytime the number of properties are changed -> update the numberOfRows function for that specifc section manually
struct Account: Codable {
    var Name: String
    var Email: String
    var Membership: String
    
    init(useraccount: UserInfo) {
        Name = useraccount.name
        Email = useraccount.email
        Membership = useraccount.membership
    }
}

struct dataSection {
    let sectionIndex: Int
    let sectionName: String
    let sectionRows: Int
    let generalSection: Account?
    let languagesSection: [Language]
    
    
    init(_ sectionIndex: Int, object: Account, _ sectionRows: Int, _ sectionName: String? = "General") {
        self.sectionIndex = sectionIndex
        self.generalSection = object
        self.sectionRows = sectionRows
        self.sectionName = sectionName!
        self.languagesSection = [Language]()
    }
    
    init(_ sectionIndex: Int, object: [Language], _ accountObject: Account? = nil, _ sectionRows: Int, _ sectionName: String? = "Languages") {
        self.sectionIndex = sectionIndex
        self.languagesSection = object
        self.sectionRows = sectionRows
        self.sectionName = sectionName!
        self.generalSection = accountObject
    }
}



