//
//  PostureEntry.swift
//  Pao-iOS
//
//  Created by Sergio on 10/4/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Foundation
import RealmSwift

class PostureEntry: Object {
    // TODO: I think these should be '@objc dynamic'
    @objc dynamic var date: Date = Date()
    @objc dynamic var accX: Int = Int(0)
    @objc dynamic var accY: Int = Int(0)
    @objc dynamic var accZ: Int = Int(0)
    @objc dynamic var gyrX: Int = Int(0)
    @objc dynamic var gyrY: Int = Int(0)
    @objc dynamic var gyrZ: Int = Int(0)
    @objc dynamic var posture: Double = 0
    @objc dynamic var postureLbl: String = ""
    
    // Save this entry into realm database
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}
