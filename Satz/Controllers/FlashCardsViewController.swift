//
//  FlashCardsViewController.swift
//  Satz
//
//  Created by Yogesh Rokhade on 20.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class FlashCardsViewController: UIViewController {

    @IBOutlet weak var flashCardText: UILabel!
    @IBOutlet weak var flashCardView: UIView!
    //let gradientLayer = CAGradientLayer()
    let cardStack =  ["der", "die", "das", "hin", "her"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpExtras()
       // setupFlashCardGesture()
    }
    
    func setUpExtras() {
        let shareCardImage = "square.and.arrow.up"
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: shareCardImage), style: .plain, target: self, action: #selector(shareButtonTapped))
        } else {
            // Fallback on earlier versions
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
        }
        
//        //Setup Flash card appearance
//        gradientLayer.frame = self.flashCardView.bounds
//        gradientLayer.colors = [UIColor.random().cgColor, UIColor.random().cgColor]
//        self.flashCardView.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    
    @objc func shareButtonTapped() {
        let activityVC = UIActivityViewController(activityItems: [self.flashCardText.text!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)        
    }
    
//    func setupFlashCardGesture() {
//        let flashCardTap = UITapGestureRecognizer(target: self, action: #selector(flashCardTapped))
//        self.flashCardView.addGestureRecognizer(flashCardTap)
//    }
//
//    @objc func flashCardTapped() {
//        gradientLayer.colors = [UIColor.random().cgColor, UIColor.random().cgColor]
//        hapticFeedback(4)
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
