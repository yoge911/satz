//
//  TranslatorViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 16.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit


class TranslatorViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var sourceTextBox: UITextView!
    @IBOutlet weak var targetTextBox: UITextView!
    @IBOutlet weak var referenceTextTranslation: UITextView!
    @IBOutlet weak var similarityLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultsView: UIVisualEffectView!
    @IBOutlet weak var resultsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextContainerView: UIView!
    
    var similarityViewDisplayed = false

    let deeplTranslator = DeepLTranslator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        setupView()
        setupSpinner()
        

    }
    
    
    
    func setupSpinner() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    func setupView() {
        setupTextViewPlaceHolders()
        self.sourceTextBox.layer.cornerRadius = 5
        self.targetTextBox.layer.cornerRadius = 5
        self.sourceTextBox.delegate = self
        self.targetTextBox.delegate = self
    }
    
    func setupTextViewPlaceHolders() {
        self.sourceTextBox.text = "Type something in the language to learn..."
        self.sourceTextBox.tag = 0
        self.targetTextBox.text = "Get the right way of saying it..."
    }
    
    func performLexicalSimilarityAnalysis() {
        
        let text1wordsArr = self.sourceTextBox.Text.lowercased().components(separatedBy: " ")
        let text2wordsArr = self.targetTextBox.Text.lowercased().components(separatedBy: " ")
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
        if textView.isEqual(self.sourceTextBox) {
            dismissResultsViewer()
            activityIndicator.startAnimating()
            self.deeplTranslator.fetchTranslation(text: self.sourceTextBox.text, interpret: true)
            {
                (translations) in
                self.targetTextBox.text = translations[1]
                self.referenceTextTranslation.text =  translations[0]
  
            }
            
        }
    
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.isEqual(self.sourceTextBox) {
            if textView.tag == 0 {
                self.sourceTextBox.text = ""
                self.sourceTextBox.tag = 1              
            }
        }
        dismissResultsViewer()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.isEqual(self.sourceTextBox) {
            performLexicalSimilarityAnalysis()
            activityIndicator.stopAnimating()
            presentResultsViewer()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func presentResultsViewer() {
        
        //view positioning
        let posYToreach = self.inputTextContainerView.frame.origin.y + self.sourceTextBox.frame.height + 20
        let posYofViewNow = self.resultsView.frame.origin.y
        let translationY =  posYToreach - posYofViewNow
        print(translationY)
        UIView.animate(withDuration: 0.2, animations: {
            self.resultsView.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.resultsViewHeight.constant = self.view.bounds.height - posYToreach
            print (self.resultsViewHeight.constant)
        }) { (true) in
            self.similarityViewDisplayed = true
        }
    }
    
    @objc func  dismissResultsViewer() {
        if similarityViewDisplayed {
            UIView.animate(withDuration: 0.2, animations: {
                self.resultsView.transform = .identity
                
            }) { (true) in
                self.similarityViewDisplayed = false
            }
        }
    }
    
    
    
    


}
