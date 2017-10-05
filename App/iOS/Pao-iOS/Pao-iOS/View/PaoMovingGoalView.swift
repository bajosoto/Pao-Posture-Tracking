//
//  PaoMovingGoalView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/5/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class PaoMovingGoalView: UIView {

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
        
        PaoDrawings.drawWalkingGoal(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawings.ResizingBehavior.aspectFit, postureGoalPercentage: 0.1)
        }
}
