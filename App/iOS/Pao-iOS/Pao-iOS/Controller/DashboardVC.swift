//
//  DashboardVC.swift
//  Pao-iOS
//
//  Created by Sergio on 10/3/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var dashScrollView: UIScrollView!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var postureBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round off profile picture
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width / 2
        profilePicImg.layer.borderWidth = 3.0
        let blueColor = UIColor(red: 124/255, green: 188/255, blue: 232/255, alpha: 1.0)
        profilePicImg.layer.borderColor = blueColor.cgColor

    }
}
