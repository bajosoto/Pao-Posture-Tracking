//
//  PaoPostureBarView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/4/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class PaoPostureBarView: UIView {

    
    private var _posture: CGFloat = 0.0
    
    var posture: CGFloat {
        set(newPosture) {
            if newPosture > 1.0 {
                _posture = 0.0
            } else if newPosture < 0 {
                _posture = 0
            } else {
                _posture = newPosture
            }
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _posture
        }
    }
    
    override func draw(_ rect: CGRect) {
        // TODO: 250 is hardcoded and won't display properly on other resolutions
        PaoDrawingAssets.drawPaoPostureBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), currentPosture: _posture)
    }
    
}

