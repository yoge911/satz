//
//  modalClass.swift
//  Satz
//
//  Created by Yogesh Rokhade on 12.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

@IBDesignable class modalView: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet{
            self.layer.borderWidth = 0.5
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var radius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        //setUpFlashCardGradient()
        //setupFlashCardGesture()
    }
    
//    func setUpFlashCardGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        gradientLayer.colors = [UIColor.random().cgColor, UIColor.random().cgColor]
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
//    func setupFlashCardGesture() {
//        let flashCardTap = UITapGestureRecognizer(target: self, action: #selector(flashCardTapped))
//        self.addGestureRecognizer(flashCardTap)
//    }
    
//    @objc func flashCardTapped() {
//        gradientLayer.colors = [UIColor.random().cgColor, UIColor.random().cgColor]
//        print("View tapped")
//    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() ->UIColor {
        return UIColor(
            red: .random(),
            green: .random(),
            blue: .random(),
            alpha: 1.0
        )
    }
}
