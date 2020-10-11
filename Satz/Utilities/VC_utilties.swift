//
//  VC_utilties.swift
//  Satz
//
//  Created by Yogesh Rokhade on 30.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit
var activityIndicator: UIActivityIndicatorView?
extension UIView {
    
    func showSpinner() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator?.center = self.center
        activityIndicator?.startAnimating()
        if let activityInd = activityIndicator {
            self.addSubview(activityInd)
        }
        
    }
    
    func removeSpinner() {
       if let activityInd = activityIndicator {
        activityInd.removeFromSuperview()
       }
    }
}

extension UIViewController {
    
    func showAlert(message: String, completion: @escaping(Bool) -> Void) {
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            completion(true)
        }))
        present(alert, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
           print("OK")
        }))
        present(alert, animated: true)
    }
    
    func animateTitle(Parentview: UIView) {
        animateStrokes(charLayers: drawText(parentView: Parentview))
    }
    
    func drawText(parentView: UIView) -> [CAShapeLayer]{
        var charLayers = [CAShapeLayer]()
        let traits = [UIFontDescriptor.TraitKey.weight: UIFont.Weight.ultraLight]
        var imgFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Noteworthy"])
        imgFontDescriptor = imgFontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.traits: traits])
        for layer in charLayers {
           layer.removeFromSuperlayer()
        }
       
        let font = [NSAttributedString.Key.font: UIFont(descriptor: imgFontDescriptor, size: 61) ]
        let attributedString = NSMutableAttributedString(string: "Satz", attributes: font)
        let y = parentView.frame.height
        let charPaths = self.characterPaths(attributedString: attributedString, position: CGPoint(x: 0, y: y))
        
        charPaths.forEach { (cgPath) in
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = self.view.backgroundColor?.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 0.5
            shapeLayer.strokeEnd = 0
            shapeLayer.path = cgPath
            parentView.layer.addSublayer(shapeLayer)
            charLayers.append(shapeLayer)
        }
        return charLayers
  }
    
    func animateStrokes(charLayers: [CAShapeLayer]) {
        let basicAnimation_1 = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation_1.toValue = 1
        let basicAnimation_2 = CABasicAnimation(keyPath: "fillColor")
        basicAnimation_2.toValue = UIColor.white.cgColor
        
        let basicAnimations =  CAAnimationGroup()
        basicAnimations.animations = [basicAnimation_1, basicAnimation_2]
        basicAnimations.duration = 3.5
        basicAnimations.fillMode = .forwards
        basicAnimations.isRemovedOnCompletion = false
        var count = 0
        charLayers.forEach { (shapeLayer) in
            count = count + 1
            shapeLayer.add(basicAnimations, forKey: "animation_\(count)" )
        }
    }

    
    func characterPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {

        let line = CTLineCreateWithAttributedString(attributedString)
        guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}
        var characterPaths = [CGPath]()

        for glyphRun in glyphRuns {
            guard let attributes = CTRunGetAttributes(glyphRun) as? [String:AnyObject] else { continue }
            let font = attributes[kCTFontAttributeName as String] as! CTFont

            for index in 0..<CTRunGetGlyphCount(glyphRun) {
                let glyphRange = CFRangeMake(index, 1)

                var glyph = CGGlyph()
                CTRunGetGlyphs(glyphRun, glyphRange, &glyph)

                var characterPosition = CGPoint()
                CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
                characterPosition.x += position.x
                characterPosition.y += position.y

                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
                    if let charPath = glyphPath.copy(using: &transform) {
                        characterPaths.append(charPath)
                    }
                }
            }
        }
        return characterPaths
   }
}
