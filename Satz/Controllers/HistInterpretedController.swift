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
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var AiTextOutput: UITextView!
    @IBOutlet weak var helperText: UITextView!
    @IBOutlet weak var typeHereIndicator : UILabel!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var refLanguageTextField: UITextField!
    @IBOutlet weak var introductionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clearAllButton : UIButton!
    

    var referenceTranslationHidden = false
    let deeplTranslator = DeepLTranslator()
    var deeplInputSourceLanguage = 0
    var deeplOutputRefTargetLanguage = 2
    
    var languagePickerView = UIPickerView()
    var refLanguagePickerView = UIPickerView()
    let YtranslationsForViews = CGFloat(40.0)
    
    @IBAction func clearAll(_sender: UIButton) {
        clearTexts()
        self.translationCompletedState(textPresent: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
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
        AiTextOutput.roundCornersCA(CA_Corners: "upperhalf", radius: CGFloat(10.0))
        inputText.roundCornersCA(CA_Corners: "bottomhalf", radius: CGFloat(10.0))
        helperText.roundCornersCA(CA_Corners: "all", radius: CGFloat(10.0))
        introductionView.roundCornersCA(CA_Corners: "all", radius: CGFloat(10.0))
        addDoneButtonOnKeyboard()
  
    }
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
            let clear: UIBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(self.clearTexts))

            let items = [flexSpace, clear, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            inputText.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            inputText.resignFirstResponder()
            
        }
    
        @objc func clearTexts(){
            self.inputText.text = ""
            self.AiTextOutput.text = ""
            self.helperText.text = ""
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func translationTriggerAnimations() {
        let YposToReach = YtranslationsForViews
        let YposToReachFrom = self.AiColloquial.frame.origin.y
        let translationY = -(YposToReachFrom - YposToReach)
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        UIView.animate(withDuration: 0.2) {
            
            self.introductionView.transform = CGAffineTransform(translationX: -500, y: 0)
            self.view.transform = CGAffineTransform(translationX: 0, y: translationY)
       
        } completion: { (bool) in
            self.referenceTranslationHidden = bool
        }
    }
    
    func translationCompletedState(textPresent: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -(YtranslationsForViews)), animated: false)
        UIView.animate(withDuration: 0.2, animations: {
            self.introductionView.transform = .identity
            self.view.transform = .identity
        })
        
        if (!textPresent) {
            self.typeHereIndicator.isHidden = false
            self.introductionView.transform = .identity
            

        }else {
            self.typeHereIndicator.isHidden = true
            let YposToReach = YtranslationsForViews
            let YposToReachFrom = self.AiColloquial.frame.origin.y
            let translationY = -(YposToReachFrom - YposToReach)
            scrollView.setContentOffset(CGPoint(x: 0.0, y: -(translationY)), animated: true)
            self.introductionView.transform = CGAffineTransform(translationX: -500, y: 0)
            
        }
        clearAllButton.isHidden = !textPresent
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        translationTriggerAnimations()
        self.typeHereIndicator.isHidden = true
        let isLanguageSelected = isSuitableSourceLanguageSelected()
        if(!isLanguageSelected){
            translationCompletedState(textPresent: false)
            
        }
        return isLanguageSelected
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
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
            
            if (refLanguageTextField.text == "") {
                let defaultHelperLanguage = self.deeplTranslator.deepLsupportedLanguages[deeplOutputRefTargetLanguage].key + " (Default)"
                refLanguageTextField.text = defaultHelperLanguage
            }

        }
        if (pickerView.isEqual(refLanguagePickerView)){
            refLanguageTextField.text = selectedLanguage
            deeplOutputRefTargetLanguage = row
        }
        
    }
    
    
}
