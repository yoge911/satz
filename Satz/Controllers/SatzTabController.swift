//
//  SatzTabController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 14.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class SatzTabController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
    }
}
