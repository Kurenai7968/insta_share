import Flutter
import UIKit
import Photos

public class SwiftInstaSharePlugin: NSObject, FlutterPlugin {
    private static let CHANNEL = "com.kurenai7968.insta_share."
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL + "method", binaryMessenger: registrar.messenger())
        let instance = SwiftInstaSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "share") {
            if let arg = call.arguments as? [String:Any] {
                let path = arg["path"] as! String
                let type = arg["type"] as! String

                instagramShare(path: path, type: type)
            }
        }

        if (call.method == "installed") {
            result(installed())
        }
    }
    
    private func instagramShare(path: String, type: String) {
        // Check if the file exists
        guard FileManager.default.fileExists(atPath: path) else {
            print("File is not exist.")
            return
        }
        
        // Check if the instagram is installed
        guard installed() else {
            print("Instagram is not installed.")
            let installUrl = URL(string: "https://itunes.apple.com/app/instagram/id389801252")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(installUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(installUrl!)
            }
            return
        }
        
        // Save image or video to photo and then share to instagram
        do {
            var shareUrl = ""
            defer {
                if let urlForRedirect = URL(string: shareUrl) {
                    UIApplication.shared.openURL(urlForRedirect)
                }
            }
            try PHPhotoLibrary.shared().performChangesAndWait {
                let fileUrl = URL(string: path)
                let request = type == "video" ? PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl!) : PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl!)

                let assetID = request?.placeholderForCreatedAsset?.localIdentifier ?? ""
                shareUrl = "instagram://library?LocalIdentifier=" + assetID
                
            }
        } catch {
            print("Image or video cannot save to photo")
        }
    }
    
    

    private func installed() -> Bool {
        let instagramUrl = URL(string: "instagram://app")
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            return true
        }
        return false
    }
}
