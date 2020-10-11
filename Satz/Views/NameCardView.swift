//
//  NameCardView.swift
//  Satz
//
//  Created by Yogesh Rokhade on 19.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class NameCardView:  UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.systemFill
        
    }
}

struct user : Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var displayName: String
    var emailId: String
}

let users = """
[
    {
        "id": 1,
        "firstName": "Yogesh"
        "lastName" : "Rokhade"
        "displayName: "Optimus"
        "emailId": "yoge911@gmail.com
    },
    {
        "id": 2,
        "firstName": "Lexus"
        "lastName" : "Rafus"
        "displayName: "Unicorn"
        "emailId": "Lexus67@gmail.com
    }
]
"""



