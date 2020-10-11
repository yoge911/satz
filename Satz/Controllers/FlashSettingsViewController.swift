//
//  FlashSettingsControllerViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 20.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class FlashSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var levelsTableView: UITableView!
    let optionlevels = ["Easy", "Medium", "Hard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        setupView()
    }
    
    func setupView() {
        let nib = UINib(nibName: "OnOrOffTableViewCell", bundle: nil)
        levelsTableView.register(nib, forCellReuseIdentifier: "OnOrOffTableViewCell")
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
    }


}

extension FlashSettingsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionlevels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = levelsTableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell", for: indexPath) as! OnOrOffTableViewCell
        cell.optionName.text = optionlevels[indexPath.row]
        cell.optionName.textColor = UIColor.white
        return cell
    }
}
