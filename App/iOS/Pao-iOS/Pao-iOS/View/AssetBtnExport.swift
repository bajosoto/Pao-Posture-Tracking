//
//  AssetBtnExport.swift
//  Pao-iOS
//
//  Created by Sergio on 10/7/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class AssetBtnExport: UIView {

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
    
    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawExportButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit, isPressed: _isPressed)
    }
}
