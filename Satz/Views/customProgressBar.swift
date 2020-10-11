//
//  customProgressBar.swift
//  Satz
//
//  Created by Yogesh Rokhade on 23.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

@IBDesignable class rotatableProgressBar: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setupView() {
        self.layer.frame.size.height = 5.0
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi / 2))
    }
}
