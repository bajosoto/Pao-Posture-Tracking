//
//  AssetGyroIconView.swift
//  Pao-iOS
//
//  Created by Sergio on 10/7/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class AssetGyroIconView: UIView {

    override func draw(_ rect: CGRect) {
        
        PaoDrawingAssets.drawGyroIcon(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), resizing: PaoDrawingAssets.ResizingBehavior.aspectFit)
    }
}
