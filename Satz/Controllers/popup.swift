//
//  popup.swift
//  Satz
//
//  Created by Yogesh Rokhade on 11.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

@IBDesignable class popup: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        addBlurArea(area: self.frame, style: UIBlurEffect.Style.dark)
      
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        addBlurArea(area: self.frame, style: UIBlurEffect.Style.dark)
    }
    
    func addBlurArea(area: CGRect, style: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: effect)

        let container = UIView(frame: area)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
        container.addSubview(blurView)
        container.alpha = 0.8
        self.insertSubview(container, at: 1)
    }

}
