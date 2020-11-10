#import "DilexusPlugin.h"
#if __has_include(<dilexus/dilexus-Swift.h>)
#import <dilexus/dilexus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dilexus-Swift.h"
#endif

@implementation DilexusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDilexusPlugin registerWithRegistrar:registrar];
}
@end
