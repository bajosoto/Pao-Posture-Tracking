//
//  PostureEntry.swift
//  Pao-iOS
//
//  Created by Sergio on 10/4/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Foundation
import RealmSwift
import Recognition

class PostureEntry: Object, IPostureEntry {
    // TODO: I think these should be '@objc dynamic'
    @objc dynamic var date: Date = Date()
    @objc dynamic var accX: Int16 = Int16(0)
    @objc dynamic var accY: Int16 = Int16(0)
    @objc dynamic var accZ: Int16 = Int16(0)
    @objc dynamic var gyrX: Int16 = Int16(0)
    @objc dynamic var gyrY: Int16 = Int16(0)
    @objc dynamic var gyrZ: Int16 = Int16(0)
    @objc dynamic var phi: Int16 = Int16(0)
    @objc dynamic var theta: Int16 = Int16(0)
    @objc dynamic var psi: Int16 = Int16(0)
    @objc dynamic var p2p: Double = Double(0)
    @objc dynamic var posture: Double = 0
    @objc dynamic var postureLbl: String = ""
    
    // Save this entry into realm database
//    func save() {
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(self)
//            }
//        } catch let error as NSError {
//            fatalError(error.localizedDescription)
//        }
//    }
}
