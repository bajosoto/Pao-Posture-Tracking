protocol PaoClassifier {

	/**
	 * trains a classifier
	 * @param traindata [array of raw data]
	 */
	init(_ traindata: [IPostureEntry])

	/**
	 * classifiy a bunch of samples
	 * @param testdata [raw data, should be multiples of the selected window size
	 *                  each window results in one classification]
	 * @return 		   [ list of predictions ]	 
	 */
	func classifySampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]
}


