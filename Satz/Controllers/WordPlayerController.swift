//
//  ViewController.swift
//  imean
//
//  Created by Yogesh Rokhade on 27.07.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import AVFoundation
import AWSTranslate
import Firebase

@available(iOS 13.0, *)
class WordPlayerController: UIViewController {

    var timer: Timer?
    var timeLeft = 5
    var timerResetVal = 5
    var timePickerDisplayed = false
    var wordExamplesDisplayed = false
    var instantTranslation = true
    var intutionBuilderStart = false
    var effect: UIVisualEffect!
    var sessionWords = [String]()
    var sessionWordIterator = 0
    var timerListShowed = false
    var isTrialStillValid = false
    
    @IBOutlet weak var timeCounterLabel: UILabel!
    @IBOutlet weak var translatedView: UILabel!
    @IBOutlet weak var RandomWordLabel: UILabel!
    @IBOutlet weak var RandomSecondWordLabel: UILabel!
    @IBOutlet weak var playButtonIcon: UIButton!
    @IBOutlet weak var playerControlsView: UIVisualEffectView!
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var cardModeView: UIView!
    @IBOutlet weak var wordExampleView: UIVisualEffectView!
    @IBOutlet weak var nowPlayingWordView: UIView!
    @IBOutlet weak var nowPlayingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var helperTitleLabel : UILabel!
    @IBOutlet weak var sentencesStackView: UIStackView!
    
    var sentencesStackviewItems = [UIView]()
    let randwordGenerator = wordGenerator()
    let synthesizer = AVSpeechSynthesizer()
    let availableTimers = ["5 second", "10 second", "20 second", "30 second", "35 second", "40 second", "45 second", "50 second", "1 Minute", "2 Minute"]
    
    
    @IBAction func closeDurationPickerButton(_ sender: Any) { dismissDurationPicker() }
    @IBAction func changeTimerValue(_ sender: UIButton) { presentDurationPicker() }  
    @IBAction func translationSwitch(_ sender: UIButton) { showInstantTranslation() }
    @IBAction func startTrainerButton(_ sender: UIButton) { playOrPause() }
    @IBAction func nextWordButton(_ sender: UIButton) { resetTimerForNextWord() }
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        timePickerContainerView.layer.cornerRadius = 10
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(resetTimerForNextWord))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let wordTapped = UITapGestureRecognizer(target: self, action: #selector(wordExampleTapped))
        self.nowPlayingWordView.addGestureRecognizer(wordTapped)
        
        let sentencesTapped = UITapGestureRecognizer(target: self, action: #selector(wordExampleTapped))
        self.sentencesStackView.addGestureRecognizer(sentencesTapped)
        
    }
    
    @objc func wordExampleTapped() {
        if wordExamplesDisplayed {
            dismissWordExampleViewer()
        }else {
            presentExampleViewer()
        }
    }
    
    @objc func resetTimerForNextWord() {
        hapticFeedback(4)
        timeLeft = timerResetVal
    }

    
    func exportDbToJson<T: Codable>(dataset: T, dbFileName: String? = "export.json") -> String{
       let jsonData = try! JSONEncoder().encode(dataset)
       let jsonString = String(data: jsonData, encoding: .utf8)!
       return jsonString
    }
    
   

    override func viewDidAppear(_ animated: Bool) {
        if isTrialStillValid == false {
             //loadMainPage()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    

    
    func showInstantTranslation() {
        instantTranslation = !instantTranslation
        translatedView.isHidden = instantTranslation
    }
    

    
    func presentDurationPicker() {
        playOrPause(stop: true)
        if timePickerDisplayed {
            dismissDurationPicker()
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
                self.timePickerContainerView.transform = CGAffineTransform(translationX: 0, y: -268 )
                self.timeCounterLabel.transform = CGAffineTransform(translationX: 0, y: -50)
                self.RandomWordLabel.transform =  CGAffineTransform(translationX: 0, y: -50)
                self.RandomSecondWordLabel.transform =  CGAffineTransform(translationX: 0, y: -50)
        }) { (true) in
            self.timePickerDisplayed = true
        }
    }
    
    func presentExampleViewer() {
        playOrPause(stop: true)
        
        //word example view positioning
        let posYToreach = self.nowPlayingWordView.frame.origin.y + self.RandomWordLabel.frame.height + self.RandomWordLabel.font.ascender
        let posYofViewNow = self.wordExampleView.frame.origin.y
        let translationY =  posYToreach - posYofViewNow
        
        // main word positioning
        let posXtoReach = CGFloat(10.0)
        let posXNow = self.RandomWordLabel.frame.origin.x
        let translationX = posXtoReach - posXNow
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.wordExampleView.transform = CGAffineTransform(translationX: 0, y: translationY)
            self.RandomWordLabel.transform = CGAffineTransform(translationX: translationX, y: 0)
            self.translatedView.transform = CGAffineTransform(translationX: 300, y: 0)
            self.helperTitleLabel.transform = CGAffineTransform(translationX: 160, y: 0)
            self.nowPlayingViewHeight.constant = self.playerControlsView.frame.maxY - posYToreach
            
        }) { (true) in
            self.updateSentencesStack()
            self.wordExamplesDisplayed = true
        }
    }
    
    func  dismissWordExampleViewer() {
        if wordExamplesDisplayed {
            UIView.animate(withDuration: 0.2, animations: {
                self.wordExampleView.transform = .identity
                 self.RandomWordLabel.transform = .identity
                self.translatedView.transform = .identity
                self.helperTitleLabel.transform = .identity
                
            }) { (true) in               
                self.wordExamplesDisplayed = false
            }
        }
    }

    
    
    
    func dismissDurationPicker() {
        if timePickerDisplayed {
            UIView.animate(withDuration: 0.2, animations: {
                 self.timePickerContainerView.transform = CGAffineTransform.identity
                 self.timeCounterLabel.transform = CGAffineTransform.identity
                 self.RandomWordLabel.transform = CGAffineTransform.identity
                 self.RandomSecondWordLabel.transform = CGAffineTransform.identity
            }) { (true) in
                self.timePickerDisplayed = false
            }
        }

    }

    
    func playOrPause(stop : Bool = false) {
        intutionBuilderStart = !intutionBuilderStart
        
        if stop {
            intutionBuilderStart = false
        }
        
        if(intutionBuilderStart){
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(nextWord), userInfo: nil, repeats: true)
            changeButtonStatus(button: playButtonIcon, systemImageName: "pause.circle.fill")
        }else{
            timer?.invalidate()
            changeButtonStatus(button: playButtonIcon, systemImageName: "play.circle.fill")
            
        }
    }
    

    func loadMainPage() {
        self.performSegue(withIdentifier: "segueToWelcomeController", sender: self)
        isTrialStillValid = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWelcomeController" {
            let welcomeController = segue.destination as! WelcomePopupController
            welcomeController.loggedIn = true
            welcomeController.isModalInPresentation = true

        }
    }
    
    
    func changeButtonStatus(button: UIButton, systemImageName: String) {
        button.setBackgroundImage(UIImage(systemName: systemImageName), for: .normal)
    }
    
    @objc func nextWord() {
        
        guard timer != nil else {
            self.translatedView.text = "Try again..."
            return
        }
        
        timeCounterLabel.text = String(timeLeft)
        
        if timeLeft == timerResetVal {
            setNextWord()
        }
        
        timeLeft -= 1
        if timeLeft == 0 {
            timeLeft = timerResetVal
        }
    }
    
    func setNextWord() {
          
         //Generate Word
         let myWord = randwordGenerator.wordFinder(wordsNeeded: 2)
         sessionWords.append(myWord[0])
         sessionWords.append(myWord[1])
         
         let currentWord = sessionWords[sessionWordIterator]
         let nextWord = sessionWords[sessionWordIterator + 1]
         sessionWordIterator += 1
                   
         self.translatedView.translate(from: "de", to: "en", text: currentWord)
         
        
         
         UIView.transition(with:  self.RandomSecondWordLabel, duration: 0.5,
                           options: .curveEaseOut, animations: {
             self.RandomSecondWordLabel.transform =  CGAffineTransform(translationX: 0, y: -100)
             self.RandomSecondWordLabel.font =  self.RandomSecondWordLabel.font.withSize(48)
             self.RandomWordLabel.transform =  CGAffineTransform(translationX: 0, y: -250)
             self.RandomWordLabel.font =  self.RandomSecondWordLabel.font.withSize(30)
             self.RandomSecondWordLabel.textColor = UIColor.white
             
         }) { (true) in
             self.RandomWordLabel.font =  UIFont(name:"HelveticaNeue-Bold", size: 48.0)
             self.RandomWordLabel.text = currentWord
             self.RandomWordLabel.transform =  CGAffineTransform.identity
             self.RandomSecondWordLabel.font =  self.RandomSecondWordLabel.font.withSize(32)
             self.RandomSecondWordLabel.textColor = .darkGray
             self.RandomSecondWordLabel.text = nextWord
             self.RandomSecondWordLabel.transform =  CGAffineTransform.identity
             
             //Haptic Feedback
             self.hapticFeedback(4)
             
             //Speak the Word
             self.speakWord(word: currentWord)
             
             
         }
    }
    
    func speakWord(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        synthesizer.speak(utterance)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
 
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func hapticFeedback(_ i: Int) {
        if #available(iOS 10.0, *) {
          let generator = UIImpactFeedbackGenerator(style: .light)
          generator.impactOccurred()
        }
    }
    

 
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}


///Timer Controller
@available(iOS 13.0, *)
extension WordPlayerController : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTimers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTimers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
               
        var multiplier = 1
        var timeUnits = 1
        let selectedTimerValue = availableTimers[row]
        
        if selectedTimerValue.contains("Minute") {
          multiplier = 60
        }
        
        timeUnits = Int(selectedTimerValue.components(separatedBy: " ")[0])!        
        timerResetVal = timeUnits * multiplier
        timeLeft = timerResetVal
        self.timeCounterLabel.text = "\(timerResetVal)"
        
    }
    
}

/// Example sentences view controller
@available(iOS 13.0, *)
extension WordPlayerController {
    
    
    func updateSentencesStack() {

        sentencesStackView.removeAllArrangedSubviews()
        let examplestring1 = "zu übernehmen oder in Konkurs zu geraten. d) Die Schwierigkeiten der Unternehmen müssen auf externe Ursachen zurückzuführen sein."
        let examplestring2 = "placed in danger or could fail; (d) the difficulties of the undertakings must be the result of external rather than internal factors. "
        let sentencePairStack = createSentenceStackItem(fromSentence: examplestring1, toSentence: examplestring2)
        let sentencePairStack2 = createSentenceStackItem(fromSentence: examplestring1, toSentence: examplestring2)

        sentencesStackView.addArrangedSubview(sentencePairStack)
        sentencesStackView.addArrangedSubview(sentencePairStack2)

        sentencesStackviewItems.append(sentencePairStack)
     
    }
    
    func createSentenceStackItem(fromSentence: String, toSentence: String) -> UIStackView {
        let sentence1 = createSentenceLabelObj(sentenceText: fromSentence)
        let sentence2 = createSentenceLabelObj(sentenceText: toSentence)
        let sentencePairStack = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        sentencePairStack.axis = .horizontal
        sentencePairStack.alignment = .fill
        sentencePairStack.distribution = .equalCentering
        sentencePairStack.spacing = 5.0
        sentencePairStack.addArrangedSubview(sentence1)
        sentencePairStack.addArrangedSubview(sentence2)   
        sentencePairStack.layoutIfNeeded()

        
        return sentencePairStack
    }

    
    func createSentenceLabelObj(sentenceText: String) -> UILabel {
   
        let originalSentenceLabel = UILabel(frame: CGRect(x: 0, y: 10, width: (self.view.frame.width / 2), height: 0))
        originalSentenceLabel.translatesAutoresizingMaskIntoConstraints = false
//        originalSentenceLabel.backgroundColor = .cyan
        originalSentenceLabel.font = UIFont(name:"HelveticaNeue", size: 15.0)
        originalSentenceLabel.textAlignment = .left
        originalSentenceLabel.textColor = .white
        originalSentenceLabel.numberOfLines = 0
        originalSentenceLabel.text = sentenceText
        return originalSentenceLabel
    }
}
