protocol PaoClassifier {

	init(_ traindata: [IPostureEntry])

	func classifySampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]
}

extension PaoClassifier {
	

	func lookup(_ strLabel : String)->Double{
		return labelDict[strLabel]!
	}
	func lookup(_ doubleLabel : Double)->String{
	
		return labelDict.first(where: {$1 == doubleLabel})!.key
	}
}

let labelDict: [String:Double] = [
		"SitOk" 	: 1.0,
		"SitNok"	: 2.0,
		"StandOk"	: 3.0,
		"StandNok"	: 4.0,
		"MovOk" 	: 5.0,
		"MovNok"	: 6.0,
	]