import PackageDescription

let package = Package(
    name: "Recognition",
     dependencies : [
    	.Package(url: "https://github.com/nifty-swift/Nifty",
    		versions: Version(1,0,0)..<Version(4,0,0)
    		)
    ]
)
