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
        if (call.method == "shareToFeed") {
            if let arg = call.arguments as? [String:Any] {
                let path = arg["path"] as! String
                let type = arg["type"] as! String

                shareToFeed(path: path, type: type)
                result(true)
            }
            
        }
    }
    
    private func shareToFeed(path: String, type: String) {
        var image: UIImage = UIImage(contentsOfFile: path)!
        print("123")
        print(image.pngData())
        print("321")
        guard let instagramUrl = URL(string: "instagram-stories://share") else {
                          return
                      }

                      if UIApplication.shared.canOpenURL(instagramUrl) {
                        var pasterboardItems:[[String:Any]]? = nil
                        pasterboardItems = [["com.instagram.sharedSticker.backgroundImage": image as Any]]
                       
                       
                        if #available(iOS 10.0, *) {
                            UIPasteboard.general.setItems(pasterboardItems!)
                            UIApplication.shared.open(instagramUrl)
                        } else {
                            return
                        }
                      } else {
                        print("no esta instalado")
                          // Instagram app is not installed or can't be opened, pop up an alert
                      }

        
        

    }
}
