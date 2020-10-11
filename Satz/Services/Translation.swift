//
//  Translation.swift
//  Satz
//
//  Created by Yogesh Rokhade on 07.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import AWSTranslate
import Foundation


protocol TranslationTypes : AnyObject {
    var Text: String { get set }
    func translate(from: String, to:String, text:String, interpretMode: Bool?, referenceLabel: UITextView?)
}

extension TranslationTypes{
    
    func translate(from: String, to:String, text:String, interpretMode: Bool? = false, referenceLabel: UITextView? = nil ){
        
        if text.count == 0 {
            self.Text = ""
            return
        }
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "AKIA5QEUFAIM5B72HUMR", secretKey: "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")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let translateClient = AWSTranslate.default()
        let translateRequest = AWSTranslateTranslateTextRequest()
        translateRequest?.sourceLanguageCode = from
        translateRequest?.targetLanguageCode = to
        translateRequest?.text = text
        
        let callback: ( AWSTranslateTranslateTextResponse?, Error?) -> Void = { [weak weakSelf = self] (response, error) in
           guard let response = response else {
            print("Got error \(String(describing: error))")
              return
           }
            
          //Respond and control the Network output into Proper Modes
           if let translatedText = response.translatedText {
             DispatchQueue.main.async {
                if( interpretMode == true){
                    referenceLabel?.text = translatedText
                    self.translate(from: to, to: from, text: translatedText)
                }else{
                    weakSelf?.Text = translatedText
                }
                
             }
              
           }
        }
        translateClient.translateText(translateRequest!, completionHandler:  callback)
    }
    
}

extension UILabel: TranslationTypes {
    var Text: String {
        get { return text ?? "" }
        set { text = newValue }
    }
}

extension UITextView: TranslationTypes {
    var Text: String {
        get { return text ?? "" }
        set { text = newValue }
    }
}

class DeepLTranslator : NSObject {
    
    let apiKey = "861e8644-9ae2-d8dd-2f4b-cb69264d475d"
    var sourceLanguage = "de"
    var targetLanguage = "en"
    var interpretMode = false
        
    var translated: (() -> Void)?
    
    func fetchTranslation(text: String, sourceLang: String? = "de", targetLang: String? = "en", interpret: Bool? = false, completion: @escaping([String]) -> Void) {
        
        if let sourceLangCode = sourceLang {
            sourceLanguage = sourceLangCode
        }
        
        if let targetLangCode = targetLang {
            targetLanguage = targetLangCode
        }
        
        if let interpretation = interpret {
            interpretMode = interpretation
        }
        
        let translationURL = buildURL(textToConvert: text)
        let decoder = JSONDecoder()
        
        decoder.decodeFromURL(DeepLText.self, fromURL: translationURL) { (response) in
            if let firstTranslation = response.properties.first?.translatedText {
                
                let interpretURL = self.buildURL(textToConvert: firstTranslation, interpretNow: true)
                decoder.decodeFromURL(DeepLText.self, fromURL: interpretURL) { (interpretation) in
                    
                    if let interpretText = interpretation.properties.first?.translatedText {
                         completion([firstTranslation, interpretText])
                    }
                }
            }
          
        }
    }
    
    func buildURL(textToConvert: String, interpretNow: Bool? = false) -> URL {
        
        var queryItems = [
            URLQueryItem(name: "auth_key", value: apiKey),
            URLQueryItem(name: "text", value: textToConvert),
            URLQueryItem(name: "source_lang", value: sourceLanguage),
            URLQueryItem(name: "target_lang", value: targetLanguage),
            URLQueryItem(name: "formality", value: "less")
        ]
        
        if interpretNow == true {
            queryItems[3].value = sourceLanguage
            queryItems[2].value = targetLanguage
            
        }
        
        //DeepL API does not support "Formality" query parameter for english target language
        if queryItems[3].value == "en" {
             queryItems.remove(at: 4)
        }
          
        var urlComps = URLComponents(string: "https://api.deepl.com/v2/translate")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!      
        return result
    }
    
}
