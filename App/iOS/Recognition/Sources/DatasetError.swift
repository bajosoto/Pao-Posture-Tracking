enum DatasetError : RecognitionError{
	case nLabelsAndNSamplesDoNotMatch(_ :Int,_ : Int)
}