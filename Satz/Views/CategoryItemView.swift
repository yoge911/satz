//
//  CategoryItempicture.swift
//  Satz
//
//  Created by Yogesh Rokhade on 05.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class CategoryItemView: UIStackView {
   
    var categoryImageLabel = UILabel()
    var categoryImage = UIImageView()
    var categoryStatusLabel = UILabel()
    
    var imageLabel: String? {
        didSet{
            categoryImageLabel.text = imageLabel
        }
    }
    
    var imageToDisplay: UIImage? {
        didSet{
          categoryImage.image = imageToDisplay
        }
    }
    
    var statusLabel: String? {
        didSet{
            categoryStatusLabel.text = statusLabel
        }
    }
    
    @IBInspectable var categoryLabelColor: UIColor? {
        didSet{
            categoryImageLabel.textColor = categoryLabelColor
        }
    }
    
    @IBInspectable var categoryStatusLabelColor: UIColor? {
        didSet{
            categoryStatusLabel.textColor = categoryStatusLabelColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCategoryItem()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setCategoryItem()
    }
    
    private func setCategoryItem() {
   
        setCategoryImage()
        setCategoryLabel()
        setCategoryStatus()
        //self.axis = .vertical
        //self.spacing = 5.0

    }
    
    private func setCategoryImage() {
        categoryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        categoryImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        categoryImage.layer.cornerRadius = 30
        categoryImage.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(tapGestureRecognizer:)))
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tapGestureRecognizer)
        addArrangedSubview(categoryImage)
    }
    
    private func setCategoryLabel() {
        categoryImageLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 60, height: 20))
        categoryImageLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryImageLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        categoryImageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        categoryImageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        categoryImageLabel.textAlignment = .center
        categoryImageLabel.textColor = .white
        addArrangedSubview(categoryImageLabel)
    }
    
    private func setCategoryStatus() {
        categoryStatusLabel = UILabel(frame: CGRect(x: 0, y: -5, width: 60, height: 10))
        categoryStatusLabel.text = ""
        categoryStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryStatusLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        categoryStatusLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        categoryStatusLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        categoryStatusLabel.textAlignment = .center
        categoryStatusLabel.textColor = .lightText
        addArrangedSubview(categoryStatusLabel)
    }
    
    @objc func categoryTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        if statusLabel == "" {
            statusLabel = "Active"
            let synthesizer = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "Hallo ihr Lieben, Wie geht's euch?")
            utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
            utterance.pitchMultiplier = 1.1
            utterance.rate = 0.5
            synthesizer.speak(utterance)
        }else{
            statusLabel = ""
        }
        
    }
    
    public func removeAllSubViewswithContent() {
        for aView in self.arrangedSubviews {
            aView.removeFromSuperview()
        }
    }

}
