//
//  MyscrollView.swift
//  Satz
//
//  Created by Yogesh Rokhade on 19.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation
import UIKit

class MyScrollView: UIScrollView {
    var priorOffset = CGPoint.zero

    override func layoutSubviews() {
        var offset = contentOffset

        if offset.y < priorOffset.y {
            let yMax = contentSize.height - bounds.height
            if offset.y < yMax {
                offset.y = priorOffset.y
                contentOffset = offset
            }
        }
        priorOffset = offset

        super.layoutSubviews()
    }
}
