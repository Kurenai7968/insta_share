import Flutter
import UIKit

public class SwiftInstaSharePlugin: NSObject, FlutterPlugin {
    private static let CHANNEL = "com.kurenai7968.insta_share."
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL + "method", binaryMessenger: registrar.messenger())
        let instance = SwiftInstaSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // switch call.method {
        //     case "share":
        //     case "installed":
        // }
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
        print("123" + path)
//        var image: UIImage = UIImage(contentsOfFile: path)!
        let instagramUrl = URL(string: "instagram://library?LocalIdentifier=" + path)
        print("123")
        print(URL(string: "instagram://library?LocalIdentifier=\(path)"))
//        print(image.pngData())
        print("321")
        
        guard FileManager.default.fileExists(atPath: path) else {
            print("File is not exist.")
            return
        }

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

        if #available(iOS 10.0, *) {
            print("555" + instagramUrl!.path)
            UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(instagramUrl!)
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
