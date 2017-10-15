//
//  AssetBtnTrainBtnsView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/15/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Foundation
import UIKit

class AssetBtnTrainStandingOkView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainStandingOk(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

class AssetBtnTrainStandingNokView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainStandingNok(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

class AssetBtnTrainSittingOkView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainSittingOk(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

class AssetBtnTrainSittingNokView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainSittingNok(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

class AssetBtnTrainMovingOkView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainMovingOk(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

class AssetBtnTrainMovingNokView: UIView {
    
    private var _isPressed: Bool = false
    
    var isPressed: Bool {
        set(newIsPressed) {
            _isPressed = newIsPressed
            // Refresh the animation whenever we get a new value from the timer
            setNeedsDisplay()
        }
        get {
            return _isPressed
        }
    }
    
    private var _takingMeasurement: Bool = false
    
    var takingMeasurement: Bool {
        set(newTakingMeasurement) {
            _takingMeasurement = newTakingMeasurement
        }
        get {
            return _takingMeasurement
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoButtonTrainMovingNok(frame: CGRect(x: 0, y: 0, width: 90, height: 66), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}

