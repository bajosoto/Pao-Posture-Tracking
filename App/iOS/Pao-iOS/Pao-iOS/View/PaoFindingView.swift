//
//  PaoFindingView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/2/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class PaoFindingView: UIView {

    private var _animationProgress: CGFloat = 0.0
    
    var animationProgress: CGFloat {
        set(newProgress) {
            if newProgress > 1.0 {
                _animationProgress = 0.0
            } else if newProgress < 0 {
                _animationProgress = 0
            } else {
                _animationProgress = newProgress
            }
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _animationProgress
        }
    }
    
    override func draw(_ rect: CGRect) {
        // TODO: 250 is hardcoded and won't display properly on other resolutions
        PaoDrawingAssets.drawPaoEgg(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), time: animationProgress)
    }

}
