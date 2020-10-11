//
//  InterpretViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 12.09.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class InterpretViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var helperText: UITextView!
    @IBOutlet weak var similarityLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var percentageView: UIView!


     let deeplTranslator = DeepLTranslator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //setupSpinner()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func done(_ sender: UIButton) {
        sender.resignFirstResponder()
    }
    
    func setupView() {
        self.inputText.delegate = self
        self.translatedText.delegate = self
        self.helperText.delegate = self
        self.percentageView.roundCorners(.allCorners, radius: 10.0)
    }
    
    func setupSpinner() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    func performLexicalSimilarityAnalysis() {
        
        let text1wordsArr = self.inputText.Text.lowercased().components(separatedBy: " ")
        let text2wordsArr = self.translatedText.Text.lowercased().components(separatedBy: " ")
        self.similarityLabel.text = String(calculateJaccardRatio(text1wordsArr: text1wordsArr, text2wordsArr: text2wordsArr)) + "%"

        
    }
    
    func calculateJaccardRatio(text1wordsArr: [String], text2wordsArr: [String]) -> Int{
        let text1wordsArr = Set(text1wordsArr)
        let text2wordsArr = Set(text2wordsArr)
       
            let common_words = (Array(text1wordsArr.intersection(text2wordsArr))).count
            let unmatchingWords_text1 = text1wordsArr.count - common_words
            let unmatchingWords_text2 = text2wordsArr.count - common_words
            let totalwords = common_words + unmatchingWords_text1 + unmatchingWords_text2
            let ratio = floor(Double(common_words)/Double(totalwords) * 100)
        
            guard !(ratio.isNaN || ratio.isInfinite) else {
                return 0
            }
        
            return Int(ratio)

    }
    
      func textViewDidChange(_ textView: UITextView) {
          if textView.isEqual(self.inputText) {
             // activityIndicator.startAnimating()
              self.deeplTranslator.fetchTranslation(text: self.inputText.text, interpret: true)
              {
                  (translations) in
                  self.translatedText.text = translations[1]
                  self.helperText.text =  translations[0]
    
              }
              
          }
      
      }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.isEqual(self.inputText) {
            performLexicalSimilarityAnalysis()
            //activityIndicator.stopAnimating()
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
