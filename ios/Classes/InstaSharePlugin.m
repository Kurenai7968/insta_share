#import "InstaSharePlugin.h"
#if __has_include(<insta_share/insta_share-Swift.h>)
#import <insta_share/insta_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "insta_share-Swift.h"
#endif

@implementation InstaSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInstaSharePlugin registerWithRegistrar:registrar];
}
@end
