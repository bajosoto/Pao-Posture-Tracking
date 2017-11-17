//
//  KnnClassifier.swift
//  Pao-iOS
//
//  Created by Sergio on 10/15/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Recognition

class Classifier {
    
    var rawRealm: Realm!
    var procRealm: Realm!
    var entriesRealm: Realm!
    private var _bleConn: BleConnection
    // Current sample number counter
    //private var _sampleCount = 0
    // Max number of samples before classifying (window size)
    private var _numSamples = 10
    // Number of consecutive bad postures before buzzing.
    private var _numBadPosturesThresh: Int
    // Current amount of bad postures
    private var _numBadPosturesCount = 0
    
    var hasBeenTrained = false
//    private var axBuff = 0
//    private var ayBuff = 0
//    private var azBuff = 0
//    private var gxBuff = 0
//    private var gyBuff = 0
//    private var gzBuff = 0
//    private var axMin = 0
//    private var axMax = 0
//    private var ayMin = 0
//    private var ayMax = 0
//    private var azMin = 0
//    private var azMax = 0
    private var trainSet: Results<PostureEntry>
    private var trainSetForFramework:[PostureEntry] = [PostureEntry]()
    var myPaoKnn: PaoKnnClassifier?
    var samplesBuffer:[PostureEntry] = [PostureEntry]()
    
    
    init(numSamples:Int, bleConn: BleConnection) {
        _numSamples = numSamples
        // Currently pao sends data every 100ms, therefore the division result is seconds (5s for demo purposes)
        _numBadPosturesThresh = Int((10.0 / Double(_numSamples)) * 5)
        _bleConn = bleConn
        var procConfig = Realm.Configuration()
        var rawConfig = Realm.Configuration()
        var entriesConfig = Realm.Configuration()
        // Get URLs for processed and raw dataset Realms
        procConfig.fileURL = procConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("processed.realm")
        rawConfig.fileURL = rawConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("raw.realm")
        entriesConfig.fileURL = entriesConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("entries.realm")
        // Open processed and raw dataset Realms
        procRealm = try! Realm(configuration: procConfig)
        rawRealm = try! Realm(configuration: rawConfig)
        entriesRealm = try! Realm(configuration: entriesConfig)
        // Start tracking the train set (this updates in real time when objects are added!)
        trainSet = rawRealm.objects(PostureEntry.self)
    }
    
    public func train() {
        trainSetForFramework.removeAll()
        for sample in trainSet {
            trainSetForFramework.append(sample)
        }
        myPaoKnn = PaoKnnClassifier(self.trainSetForFramework)
        hasBeenTrained = true
    }
    
    public func addToDataset(ax:Int16, ay:Int16, az:Int16, gx:Int16, gy:Int16, gz:Int16, phi: Int16, theta:Int16,
                             psi:Int16, label:String) {
        // Create and store entry in raw Realm
        let rawEntry = PostureEntry()
        rawEntry.accX = ax
        rawEntry.accY = ay
        rawEntry.accZ = az
        rawEntry.gyrX = gx
        rawEntry.gyrY = gy
        rawEntry.gyrZ = gz
        rawEntry.phi = phi
        rawEntry.theta = theta
        rawEntry.psi = psi
        rawEntry.postureLbl = label
        try! rawRealm.write {
            rawRealm.add(rawEntry)
        }
//        _bleConn.logMsg(message: "Stored raw sample \(_sampleCount): \(label)")
//        print("Stored raw sample \(_sampleCount): \(label)")
//
//        // Accumulate value within window
//        axBuff += Int(ax)
//        ayBuff += Int(ay)
//        azBuff += Int(az)
//        gxBuff += Int(gx)
//        gyBuff += Int(gy)
//        gzBuff += Int(gz)
//
//        // Increase number of sample
//        _sampleCount += 1
//
//        // Keep track of min and max values for accelerometer data
//        if(_sampleCount == 1) {
//            axMin = Int(ax)
//            axMax = Int(ax)
//            ayMin = Int(ay)
//            ayMax = Int(ay)
//            azMin = Int(az)
//            azMax = Int(az)
//        } else {
//            if(ax < axMin) { axMin = Int(ax) }
//            if(ax > axMax) { axMax = Int(ax) }
//            if(ay < ayMin) { ayMin = Int(ay) }
//            if(ay > ayMax) { ayMax = Int(ay) }
//            if(az < azMin) { azMin = Int(az) }
//            if(az > azMax) { azMax = Int(az) }
//        }
//
//        // If all samples within window have been captured, calculate p2p and averages
//        if(_sampleCount == _numSamples) {
//            let p2p =   (pow(Double(axMax-axMin), 2.0) +
//                        pow(Double(ayMax-ayMin), 2.0) +
//                        pow(Double(azMax-azMin), 2.0) ).squareRoot()
//            axBuff /= _numSamples
//            ayBuff /= _numSamples
//            azBuff /= _numSamples
//            gxBuff /= _numSamples
//            gyBuff /= _numSamples
//            gzBuff /= _numSamples
//            // Create and store entry in processed Realm
//            let procEntry = PostureEntry()
//            procEntry.accX = Int16(axBuff)
//            procEntry.accY = Int16(ayBuff)
//            procEntry.accZ = Int16(azBuff)
//            procEntry.gyrX = Int16(gxBuff)
//            procEntry.gyrY = Int16(gyBuff)
//            procEntry.gyrZ = Int16(gzBuff)
//            procEntry.postureLbl = label
//            procEntry.p2p = p2p
//            try! procRealm.write {
//                procRealm.add(procEntry)
//            }
//            _bleConn.logMsg(message: "Stored processed sample: \(label)")
//            print("Stored processed sample: \(label)")
        
            // Reset sample counter
//            _sampleCount = 0
//        }
    }
    
    public func addAndClassifySample(ax:Int16, ay:Int16, az:Int16, gx:Int16, gy:Int16, gz:Int16, phi: Int16, theta:Int16,
                                     psi:Int16) {
        
        // Create a new PostureEntry with new sample data
        let newEntry = PostureEntry()
        newEntry.accX = ax
        newEntry.accY = ay
        newEntry.accZ = az
        newEntry.gyrX = gx
        newEntry.gyrY = gy
        newEntry.gyrZ = gz
        newEntry.phi = phi
        newEntry.theta = theta
        newEntry.psi = psi
        
        // Add sample to the array of PostureEntries
        samplesBuffer.append(newEntry)
        
        //_bleConn.logMsg(message: "Added sample num: \(samplesBuffer.count - 1)")
        
        // If the sample is the last in the window
        if samplesBuffer.count == _numSamples {
            
            if !rawRealm.isEmpty {
                // Get an array of classified PostureEntries (probably only 1 since the full window size is sent)
                if let classificationResult = myPaoKnn?.predictSampleSoft(samplesBuffer) { // as? [PostureEntry] {
                    // Grab the first result TODO: If we're sending the window size, it should only produce one. Otherwise change this
                    let newClassifiedEntry:PostureEntry = PostureEntry()
//                    newClassifiedEntry.accX = classificationResult[0].accX        // We don't need this data in the classified data
//                    newClassifiedEntry.accY = classificationResult[0].accY
//                    newClassifiedEntry.accZ = classificationResult[0].accZ
//                    newClassifiedEntry.gyrX = classificationResult[0].gyrX
//                    newClassifiedEntry.gyrY = classificationResult[0].gyrY
//                    newClassifiedEntry.gyrZ = classificationResult[0].gyrZ
//                    newClassifiedEntry.phi = classificationResult[0].phi
//                    newClassifiedEntry.theta = classificationResult[0].theta
//                    newClassifiedEntry.psi = classificationResult[0].psi
                    newClassifiedEntry.postureLbl = classificationResult[0].postureLbl
                    newClassifiedEntry.posture = classificationResult[0].posture
                    
                    try! entriesRealm.write {
                        // Add first PostureEntry to Realm TODO: If there's more than one, we need to add those too
                        entriesRealm.add(newClassifiedEntry)
                    }
                    
                    _bleConn.logMsg(message: "Stored classified sample: \(newClassifiedEntry.postureLbl), \(newClassifiedEntry.posture.format(f: ".2"))")
                    print("Stored classified sample: \(newEntry.postureLbl)")
                    
                    // If bad posture detected
                    if newClassifiedEntry.posture < 0.0 {
                        // Increment bad posture count
                        _numBadPosturesCount += 1
                        // Check if amount of bad postures threshold has been reached
                        if _numBadPosturesCount >= _numBadPosturesThresh {
                            // Buzz for 100 ms (0A = 10, which is then multiplied by 10 on ES side, in ms)
                            _bleConn.write(msg: "7E030A")
                            _bleConn.logMsg(message: "Should be buzzing now")
                            // Reset bad postures count
                            _numBadPosturesCount = 0
                        }
                    } else {
                        // Reset bad postures count
                        _numBadPosturesCount = 0
                    }
                    // End for debugging
                    
                } else {
                    _bleConn.logMsg(message: "classificationResult was nil")
                }
            }
            // Empty the samples buffer
            samplesBuffer.removeAll()
        }
    }
    
//    public func classifyKnn(ax:Int16, ay:Int16, az:Int16, gx:Int16, gy:Int16, gz:Int16, nNeighbours: Int) {
//        // Accumulate value within window
//        axBuff += Int(ax)
//        ayBuff += Int(ay)
//        azBuff += Int(az)
//        gxBuff += Int(gx)
//        gyBuff += Int(gy)
//        gzBuff += Int(gz)
//
//        // Increase number of sample
//        _sampleCount += 1
//
//        // Keep track of min and max values for accelerometer data
//        if(_sampleCount == 1) {
//            axMin = Int(ax)
//            axMax = Int(ax)
//            ayMin = Int(ay)
//            ayMax = Int(ay)
//            azMin = Int(az)
//            azMax = Int(az)
//        } else {
//            if(ax < axMin) { axMin = Int(ax) }
//            if(ax > axMax) { axMax = Int(ax) }
//            if(ay < ayMin) { ayMin = Int(ay) }
//            if(ay > ayMax) { ayMax = Int(ay) }
//            if(az < azMin) { azMin = Int(az) }
//            if(az > azMax) { azMax = Int(az) }
//        }
//
//        // If all samples within window have been captured, calculate p2p and averages
//        if(_sampleCount >= _numSamples) {
//            let p2p =   (pow(Double(axMax-axMin), 2.0) +
//                pow(Double(ayMax-ayMin), 2.0) +
//                pow(Double(azMax-azMin), 2.0) ).squareRoot()
//            axBuff /= _numSamples
//            ayBuff /= _numSamples
//            azBuff /= _numSamples
//            gxBuff /= _numSamples
//            gyBuff /= _numSamples
//            gzBuff /= _numSamples
//            // Create and store entry in processed Realm
//            let newEntry = PostureEntry()
//            newEntry.accX = Int16(axBuff)
//            newEntry.accY = Int16(ayBuff)
//            newEntry.accZ = Int16(azBuff)
//            newEntry.gyrX = Int16(gxBuff)
//            newEntry.gyrY = Int16(gyBuff)
//            newEntry.gyrZ = Int16(gzBuff)
//            newEntry.p2p = p2p
//
//            classifyKnnSample(newEntry: newEntry, nNeighbours: nNeighbours)
//
//            try! entriesRealm.write {
//                entriesRealm.add(newEntry)
//            }
//            _bleConn.logMsg(message: "Stored classified sample: \(newEntry.postureLbl), \(newEntry.posture.format(f: ".2"))")
//            print("Stored classified sample: \(newEntry.postureLbl)")
//
//            // Reset sample counter
//            _sampleCount = 0
//        }
//    }
//
//    public func classifyKnnSample(newEntry: PostureEntry, nNeighbours: Int) { //} -> (lbl: String, prob: Double){
//        if(trainSet.isEmpty) {
//            //return (lbl: "Unclassified" , prob: 0)
//            newEntry.postureLbl = "Unclassified"
//            newEntry.posture = 0
//            print("trainset was empty")
//            return
//        }
//        // Tuple array storing distance to each member in the train set and the corresponding label
//        var distances: [(dist: Double, lbl: String)] = []
//        // Tuple storing the resulting label and probability
//        var proba: (lbl: String, prob: Double) = (prob: 0, lbl: "Unclassified")
//
//        // Calculate distance from the new entry to each sample in the train set
//        for sample in trainSet {
//            distances.append((dist(from: sample, to: newEntry), sample.postureLbl))
//        }
//
//        // Sort distances
//        distances = distances.sorted(by: {$0.dist < $1.dist})
//
//        // Calculate probability and label
//        var ranking: [String: Double] = [:]
//        for k in 0..<nNeighbours {
//            let label = distances[k].lbl
//            // Accumulate occurrances
//            ranking[label] = (ranking[label] ?? 0) + 1
//        }
//
//        let result = ranking.sorted(by: {$0.1 > $1.1})[0]
//
//        // Calculate probability relative to opposing class
//        // result.value has the number of occurrances of a given label
//        // we are getting the ratio between only opposing classes
//        // TODO: Don't use strings for this. Too innefficient
//        var perPostureProb = result.value
//        switch result.key {
//        case "SitOk":
//            perPostureProb = perPostureProb / (perPostureProb + (ranking["SitNok"] ?? 0))
//            break
//        case "SitNok":
//            // Negative signs for bad postures
//            perPostureProb = -perPostureProb / (perPostureProb + (ranking["SitOk"] ?? 0))
//            break
//        case "StandOk":
//            perPostureProb = perPostureProb / (perPostureProb + (ranking["StandNok"] ?? 0))
//            break
//        case "StandNok":
//            perPostureProb = -perPostureProb / (perPostureProb + (ranking["StandOk"] ?? 0))
//            break
//        case "MovOk":
//            perPostureProb = perPostureProb / (perPostureProb + (ranking["MovNok"] ?? 0))
//            break
//        case "MovNok":
//            perPostureProb = -perPostureProb / (perPostureProb + (ranking["MovOk"] ?? 0))
//            break
//        default:
//            break
//        }
//        proba = (lbl: result.key, prob: perPostureProb)//result.value / Double(nNeighbours))
//
//        newEntry.postureLbl = proba.lbl
//        newEntry.posture = proba.prob
//
//    }

//    func dist(from: PostureEntry, to: PostureEntry) -> Double {
//        let dax = pow(Double(from.accX - to.accX), 2.0)
//        let day = pow(Double(from.accY - to.accY), 2.0)
//        let daz = pow(Double(from.accZ - to.accZ), 2.0)
//        let dgx = pow(Double(from.gyrX - to.gyrX), 2.0)
//        let dgy = pow(Double(from.gyrY - to.gyrY), 2.0)
//        let dgz = pow(Double(from.gyrZ - to.gyrZ), 2.0)
//        let dp2p = pow(     from.p2p - to.p2p   , 2.0)
//        return (dax + day + daz + dgx + dgy + dgz + dp2p).squareRoot()
//    }

    
    
}
