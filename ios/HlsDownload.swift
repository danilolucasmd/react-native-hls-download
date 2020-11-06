import AVFoundation

@available(iOS 10.0, *)
@objc(HlsDownload)
class HlsDownload:NSObject {
	static var shared = HlsDownload()
	private var config: URLSessionConfiguration!
	private var downloadSession: AVAssetDownloadURLSession!

	override private init() {
		super.init()
		config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
		downloadSession = AVAssetDownloadURLSession(configuration: config, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
	}

	@objc(setupAssetDownload:)
	func setupAssetDownload(url: String) {
		let options = [AVURLAssetAllowsCellularAccessKey: false]
        
		if let _url = URL(string: url){
			let asset = AVURLAsset(url: _url, options: options)

			// Create new AVAssetDownloadTask for the desired asset
			let downloadTask = downloadSession.makeAssetDownloadTask(asset: asset, assetTitle: "Test Download", assetArtworkData: nil, options: nil)
			// Start task and begin download
			downloadTask?.resume()
		}
	}

	@objc
	func restorePendingDownloads() {
		// Grab all the pending tasks associated with the downloadSession
		downloadSession.getAllTasks { tasksArray in
			// For each task, restore the state in the app
			for task in tasksArray {
				guard let downloadTask = task as? AVAssetDownloadTask else { break }
				// Restore asset, progress indicators, state, etc...
				let asset = downloadTask.urlAsset
				downloadTask.resume()
			}
		}
	}

	@objc(playOfflineAsset:withRejecter:)
	func playOfflineAsset(resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
		guard let assetPath = UserDefaults.standard.value(forKey: "assetPath") as? String else {
			// Present Error: No offline version of this asset available
			resolve(nil)
			return
		}
		let baseURL = URL(fileURLWithPath: NSHomeDirectory())
		let assetURL = baseURL.appendingPathComponent(assetPath)
		 let asset = AVURLAsset(url: assetURL)
		if let cache = asset.assetCache, cache.isPlayableOffline {
			// Set up player item and player and begin playback
			// return asset.url.path
			resolve(asset.url.path)
			return
		} else {
			resolve(nil)
			return
			// Present Error: No playable version of this asset exists offline
		}
	}

	@objc
	func getPath() -> String {
		return UserDefaults.standard.value(forKey: "assetPath") as? String ?? ""
	}

	@objc
	func deleteOfflineAsset() {
		do {
			let userDefaults = UserDefaults.standard
			if let assetPath = userDefaults.value(forKey: "assetPath") as? String {
				let baseURL = URL(fileURLWithPath: NSHomeDirectory())
				let assetURL = baseURL.appendingPathComponent(assetPath)
				try FileManager.default.removeItem(at: assetURL)
				userDefaults.removeObject(forKey: "assetPath")
			}
		} catch {
			print("An error occured deleting offline asset: \(error)")
		}
	}
}

@available(iOS 10.0, *)
@objc(HlsDownload)
extension HlsDownload: AVAssetDownloadDelegate {
	func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
		var percentComplete = 0.0
		// Iterate through the loaded time ranges
		for value in loadedTimeRanges {
			// Unwrap the CMTimeRange from the NSValue
			let loadedTimeRange = value.timeRangeValue
			// Calculate the percentage of the total expected asset duration
			percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
		}
		percentComplete *= 100

		debugPrint("Progress \( assetDownloadTask) \(percentComplete)")

		let params = ["percent": percentComplete]
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completion"), object: nil, userInfo: params)
		// Update UI state: post notification, update KVO state, invoke callback, etc.
	}

	func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
		// Do not move the asset from the download location
		UserDefaults.standard.set(location.relativePath, forKey: "assetPath")
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		debugPrint("Download finished: \(location)")
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		debugPrint("Task completed: \(task), error: \(String(describing: error))")

		guard error == nil else { return }
		guard let task = task as? AVAssetDownloadTask else { return }

		print("DOWNLOAD: FINISHED")
	}
}
