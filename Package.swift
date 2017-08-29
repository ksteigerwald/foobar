// Generated automatically by Perfect Assistant Application
// Date: 2017-08-28 00:19:57 +0000
import PackageDescription
let package = Package(
	name: "foobar",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", majorVersion: 2),
		.Package(url: "https://github.com/ReactiveX/RxSwift.git", Version(3,6,1)),
		.Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
		.Package(url: "https://github.com/BrettRToomey/Jobs.git", majorVersion: 1),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Redis.git", majorVersion: 2),
		.Package(url: "https://github.com/SwiftORM/Postgres-StORM.git", majorVersion: 1, minor: 3),
		.Package(url: "https://github.com/SwiftORM/StORM.git", majorVersion: 1),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2),
	]
)
