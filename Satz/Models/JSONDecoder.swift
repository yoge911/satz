//
//  JSONDecoder.swift
//  Satz
//
//  Created by Yogesh Rokhade on 25.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping(T) -> Void) {
        
        guard let path = Bundle.main.path(forResource: url, ofType: "json") else {
            fatalError("Invalid File/URL passed")
        }

        DispatchQueue.global().async {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let usersettings = try self.decode(type, from: data)
                DispatchQueue.main.async {
                    completion(usersettings)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func decodeFromURL<T: Decodable>(_ type: T.Type, fromURL url: URL, completion: @escaping(T) -> Void) {

        DispatchQueue.global().async {
            do {
               
                let data = try Data(contentsOf: url)
                let response = try self.decode(type, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
//let useraccount = usersettings.first!
//self.accountSettings.append(Account(useraccount: useraccount))
//self.languageSettings = useraccount.languages
//self.tableViewSections.append(sectionInfo(0, object: self.accountSettings, 3))
//self.tableViewSections.append(sectionInfo(1, object: self.languageSettings, self.languageSettings.count, "Languages"))
//self.tableView.reloadData()
