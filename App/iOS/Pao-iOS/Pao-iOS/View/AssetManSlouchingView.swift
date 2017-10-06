//
//  AssetManSlouchingView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/6/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class AssetManSlouchingView: UIView {

    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawPaoManSlouching(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit)
    }
}
