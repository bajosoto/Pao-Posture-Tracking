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
                _posture = 1.0
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
        
        PaoDrawingAssets.drawPaoMovingGoal(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, postureGoalPercentage: 0.1)
    }
}

class PaoStepsGoalView: UIView {
    
    private var _posture: CGFloat = 0.0
    
    var posture: CGFloat {
        set(newPosture) {
            if newPosture > 1.0 {
                _posture = 1.0
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
        
        PaoDrawingAssets.drawPaoStepGoal(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, postureGoalPercentage: posture)
    }
}

class PaoStandingGoalView: UIView {
    
    private var _posture: CGFloat = 0.0
    
    var posture: CGFloat {
        set(newPosture) {
            if newPosture > 1.0 {
                _posture = 1.0
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
        
        PaoDrawingAssets.drawPaoStandingGoal(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, postureGoalPercentage: 0.90)
    }
    
}


class PaoSittingGoalView: UIView {
    
    private var _posture: CGFloat = 0.0
    
    var posture: CGFloat {
        set(newPosture) {
            if newPosture > 1.0 {
                _posture = 1.0
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
        
        PaoDrawingAssets.drawPaoSittingGoal(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height) , resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, postureGoalPercentage: 0.5)
    }
    
}
