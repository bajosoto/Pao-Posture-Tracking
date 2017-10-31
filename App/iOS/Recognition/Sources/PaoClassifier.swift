protocol PaoClassifier {

	init(_ traindata: [IPostureEntry])

	func classifySampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]
}