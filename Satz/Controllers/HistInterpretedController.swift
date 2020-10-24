//
//  HistInterpretedController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 14.10.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class HistInterpretedController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var AiColloquial: UIView!
//    @IBOutlet weak var referenceTranslationView: UIView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var AiTextOutput: UITextView!
    @IBOutlet weak var helperText: UITextView!
    @IBOutlet weak var typeHereIndicator : UILabel!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var refLanguageTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var introductionView: UIView!

    
    var referenceTranslationHidden = false
    let deeplTranslator = DeepLTranslator()
    var deeplInputSourceLanguage = 0
    var deeplOutputRefTargetLanguage = 2
    
    var languagePickerView = UIPickerView()
    var refLanguagePickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.hideKeyboardWhenTappedAround()
        self.clearButton.isHidden = true
        self.inputText.delegate = self
        self.AiTextOutput.delegate = self
        self.helperText.delegate = self
        languagePickerView.delegate = self
        languagePickerView.dataSource = self
        refLanguagePickerView.delegate = self
        refLanguagePickerView.dataSource = self
        languageTextField.inputView = languagePickerView
        languageTextField.textAlignment = .center
        refLanguageTextField.inputView = refLanguagePickerView
        refLanguageTextField.textAlignment = .center
        
        setUpViews()
    }
    
    func setUpViews()  {
        typeHereIndicator.layer.zPosition = 1
        clearButton.layer.zPosition = 1
        AiTextOutput.roundCornersCA(CA_Corners: "upperhalf", radius: CGFloat(10.0))
        inputText.roundCornersCA(CA_Corners: "bottomhalf", radius: CGFloat(10.0))
        helperText.roundCornersCA(CA_Corners: "all", radius: CGFloat(10.0))
        clearButton.roundCornersCA(CA_Corners: "all", radius: CGFloat(8.0))
        introductionView.roundCornersCA(CA_Corners: "all", radius: CGFloat(10.0))
    }
    

    
    func translationTriggerAnimations() {
        let YposToReach = CGFloat(30.0)
        let YposToReachFrom = self.AiColloquial.frame.origin.y
        let translationY = -(YposToReachFrom - YposToReach)
        UIView.animate(withDuration: 0.2) {
            self.AiColloquial.transform = CGAffineTransform(translationX: 0, y: translationY)
       
        } completion: { (bool) in
            self.referenceTranslationHidden = bool
        }
    }
    
    func translationCompletedState(textPresent: Bool) {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.AiColloquial.transform = .identity
//        })
        
        if (!textPresent) {
            self.typeHereIndicator.isHidden = false
            self.clearButton.isHidden = true
        }else {
            self.typeHereIndicator.isHidden = true
            self.clearButton.isHidden = false
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //translationTriggerAnimations()
        self.typeHereIndicator.isHidden = true
        self.clearButton.isHidden = false
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (isSuitableSourceLanguageSelected()) {
            if textView.isEqual(self.inputText) {
                self.deeplTranslator.fetchTranslation(
                    text: self.inputText.text,
                    sourceLang: self.deeplInputSourceLanguage,
                    targetLang: self.deeplOutputRefTargetLanguage,
                    interpret: true)
                {
                    (translations) in
                    self.AiTextOutput.text = translations[1]
                    self.helperText.text =  translations[0]
                }
            }
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.isEqual(self.inputText) {
//            performLexicalSimilarityAnalysis()
//        }
        translationCompletedState(textPresent: self.inputText.Text.count > 0)
        
    }
    
    func performLexicalSimilarityAnalysis() {
        
        let text1wordsArr = self.inputText.Text.lowercased().components(separatedBy: " ")
        let text2wordsArr = self.AiTextOutput.Text.lowercased().components(separatedBy: " ")

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
    
    func isSuitableSourceLanguageSelected() -> Bool {
        if (deeplInputSourceLanguage == 0) {
            showAlert(message: "Choose the language you wish to improve")
            return false
        }
        return true
    }
    
}

@available(iOS 11.0, *)
extension HistInterpretedController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.deeplTranslator.deepLsupportedLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  self.deeplTranslator.deepLsupportedLanguages[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let selectedLanguage = self.deeplTranslator.deepLsupportedLanguages[row].key
        
        if (pickerView .isEqual(languagePickerView)) {
            languageTextField.text = selectedLanguage
            deeplInputSourceLanguage = row
        }
        if (pickerView.isEqual(refLanguagePickerView)){
            refLanguageTextField.text = selectedLanguage
            deeplOutputRefTargetLanguage = row
        }
        
    }
    
    
}
